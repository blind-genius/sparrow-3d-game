import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_constants.dart';
import '../core/audio_manager.dart';
import '../engine_3d/camera_3d.dart';
import '../engine_3d/particle_3d.dart';
import '../engine_3d/vector3d.dart';
import '../models/collectible_entity.dart';
import '../models/game_status.dart';
import '../models/level_data.dart';
import '../models/obstacle_entity.dart';
import '../models/sparrow_entity.dart';

class GameController extends ChangeNotifier {
  GameState gameState = GameState.menu;
  late LevelData currentLevel;
  
  final SparrowEntity sparrow = SparrowEntity();
  final Camera3D camera = Camera3D();

  final List<ObstacleEntity> obstacles = [];
  final List<CollectibleEntity> collectibles = [];
  final List<Particle3D> particles = [];

  double score = 0;
  double highScore = 0;
  int highestUnlockedLevel = 1;
  double distanceTraveled = 0;

  // Inventory / Feed supplies for direct feeding
  int waterSupply = 3;
  int seedSupply = 3;

  // Timers for spawning
  double _obstacleSpawnTimer = 0.0;
  double _collectibleSpawnTimer = 0.0;

  // Loaded Sprite Images
  ui.Image? sparrowFlyingImage;
  ui.Image? sparrowRestingImage;
  ui.Image? sparrowWoundedImage;
  ui.Image? backgroundImage;
  bool isAssetsLoaded = false;

  final math.Random _random = math.Random();

  GameController() {
    currentLevel = LevelData.getLevel(1);
    loadSavedData();
    loadAssets();
  }

  Future<void> loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      highScore = prefs.getDouble(AppConstants.keyHighScore) ?? 0;
      highestUnlockedLevel = prefs.getInt(AppConstants.keyUnlockedLevel) ?? 1;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Load save error: $e');
    }
  }

  Future<void> saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (score > highScore) {
        highScore = score;
        await prefs.setDouble(AppConstants.keyHighScore, highScore);
      }
      if (currentLevel.levelNumber >= highestUnlockedLevel && currentLevel.levelNumber < 10) {
        highestUnlockedLevel = math.max(highestUnlockedLevel, currentLevel.levelNumber + 1);
        await prefs.setInt(AppConstants.keyUnlockedLevel, highestUnlockedLevel);
      }
    } catch (e) {
      if (kDebugMode) print('Save progress error: $e');
    }
  }

  Future<void> loadAssets() async {
    try {
      sparrowFlyingImage = await _loadImage('assets/images/sparrow_flying.png');
      sparrowRestingImage = await _loadImage('assets/images/sparrow_resting.png');
      sparrowWoundedImage = await _loadImage('assets/images/sparrow_wounded.png');
      backgroundImage = await _loadImage('assets/images/background_resting.jpg');
      isAssetsLoaded = true;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Failed to load image assets: $e');
    }
  }

  Future<ui.Image> _loadImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  void startLevel(int levelNumber) {
    currentLevel = LevelData.getLevel(levelNumber);
    sparrow.reset();
    obstacles.clear();
    collectibles.clear();
    particles.clear();
    distanceTraveled = 0;
    score = 0;
    waterSupply = 3;
    seedSupply = 3;
    _obstacleSpawnTimer = 0.0;
    _collectibleSpawnTimer = 0.0;
    gameState = GameState.playing;
    AudioManager.instance.playChirp();
    notifyListeners();
  }

  void restartLevel() {
    startLevel(currentLevel.levelNumber);
  }

  void nextLevel() {
    if (currentLevel.levelNumber < 10) {
      startLevel(currentLevel.levelNumber + 1);
    } else {
      gameState = GameState.allLevelsWon;
      notifyListeners();
    }
  }

  void pauseGame() {
    if (gameState == GameState.playing) {
      gameState = GameState.paused;
      notifyListeners();
    }
  }

  void resumeGame() {
    if (gameState == GameState.paused) {
      gameState = GameState.playing;
      notifyListeners();
    }
  }

  void returnToMenu() {
    gameState = GameState.menu;
    notifyListeners();
  }

  // Steering controls (from touch drag / joystick / tilt)
  void setSteeringVelocity(double vx, double vy) {
    if (gameState != GameState.playing) return;
    sparrow.velocity.x = vx * 16.0;
    sparrow.velocity.y = vy * 14.0;
  }

  // Direct Feeding action triggered by user
  void feedWater() {
    if (gameState != GameState.playing) return;
    if (waterSupply > 0 || sparrow.health < AppConstants.maxHealth) {
      if (waterSupply > 0) waterSupply--;
      sparrow.drinkWater();
      score += AppConstants.waterScoreBonus;
      particles.addAll(Particle3D.createWaterSplash(sparrow.position));
      AudioManager.instance.playWater();
      notifyListeners();
    }
  }

  void feedSeed() {
    if (gameState != GameState.playing) return;
    if (seedSupply > 0 || sparrow.health < AppConstants.maxHealth) {
      if (seedSupply > 0) seedSupply--;
      sparrow.eatSeed();
      score += AppConstants.seedScoreBonus;
      particles.addAll(Particle3D.createSeedSparkle(sparrow.position));
      AudioManager.instance.playSeed();
      notifyListeners();
    }
  }

  // Main 60 FPS update loop
  void update(double dt) {
    if (gameState != GameState.playing) return;

    // Advance flight distance & passive score
    final speed = currentLevel.flightSpeed;
    distanceTraveled += speed * dt;
    score += dt * 8.0;

    // Check level completion
    if (distanceTraveled >= currentLevel.targetDistance) {
      saveProgress();
      if (currentLevel.levelNumber == 10) {
        gameState = GameState.allLevelsWon;
      } else {
        gameState = GameState.levelCompleted;
      }
      AudioManager.instance.playWin();
      notifyListeners();
      return;
    }

    // Update sparrow physics & animations
    sparrow.update(dt);

    // Natural flapping sound occasionally
    if (sparrow.isFlapping && _random.nextDouble() < 0.04) {
      AudioManager.instance.playFlap();
    }

    // Spawn obstacles
    _obstacleSpawnTimer += dt;
    if (_obstacleSpawnTimer >= currentLevel.obstacleSpawnInterval) {
      _obstacleSpawnTimer = 0.0;
      _spawnObstacle();
    }

    // Spawn collectibles
    _collectibleSpawnTimer += dt;
    if (_collectibleSpawnTimer >= currentLevel.collectibleSpawnInterval) {
      _collectibleSpawnTimer = 0.0;
      _spawnCollectible();
    }

    // Update obstacles & check collision
    for (int i = obstacles.length - 1; i >= 0; i--) {
      final obs = obstacles[i];
      obs.update(dt, speed);

      // Collision check with sparrow
      if (!obs.passed && obs.checkCollision(sparrow.position, sparrow.collisionRadius)) {
        obs.passed = true;
        final hitSuccess = sparrow.hitObstacle(AppConstants.damagePerHit);
        if (hitSuccess) {
          // Penalty: score decreases and health decreases
          score = math.max(0.0, score - AppConstants.scorePenaltyPerHit);
          particles.addAll(Particle3D.createWoundBurst(sparrow.position));
          AudioManager.instance.playHit();

          // Check if sparrow health reaches 0 -> User loses (Game Over)
          if (sparrow.health <= 0) {
            gameState = GameState.gameOver;
            saveProgress();
            AudioManager.instance.playGameOver();
            notifyListeners();
            return;
          }
        }
      }

      // Despawn passed obstacles
      if (obs.position.z < AppConstants.despawnDistanceZ) {
        obstacles.removeAt(i);
      }
    }

    // Update collectibles & check consumption
    for (int i = collectibles.length - 1; i >= 0; i--) {
      final col = collectibles[i];
      col.update(dt, speed);

      if (col.checkCollision(sparrow.position, sparrow.collisionRadius)) {
        col.isCollected = true;
        if (col.type == CollectibleType.water) {
          sparrow.drinkWater();
          waterSupply++;
          score += AppConstants.waterScoreBonus;
          particles.addAll(Particle3D.createWaterSplash(sparrow.position));
          AudioManager.instance.playWater();
        } else {
          sparrow.eatSeed();
          seedSupply++;
          score += AppConstants.seedScoreBonus;
          particles.addAll(Particle3D.createSeedSparkle(sparrow.position));
          AudioManager.instance.playSeed();
        }
        collectibles.removeAt(i);
        continue;
      }

      if (col.position.z < AppConstants.despawnDistanceZ) {
        collectibles.removeAt(i);
      }
    }

    // Update particles
    for (int i = particles.length - 1; i >= 0; i--) {
      final alive = particles[i].update(dt);
      if (!alive) {
        particles.removeAt(i);
      }
    }

    notifyListeners();
  }

  void _spawnObstacle() {
    final types = currentLevel.allowedObstacles;
    final type = types[_random.nextInt(types.length)];

    final spawnZ = AppConstants.spawnDistanceZ;
    final posX = (_random.nextDouble() - 0.5) * (AppConstants.worldWidth * 0.7);
    final posY = (_random.nextDouble() - 0.5) * (AppConstants.worldHeight * 0.6);

    double width = 3.0;
    double height = 3.0;
    Color color = const Color(0xFF6D4C41);

    switch (type) {
      case ObstacleType.treeTrunk:
        width = 2.4;
        height = 14.0;
        color = const Color(0xFF5D4037);
        break;
      case ObstacleType.horizontalLog:
        width = 11.0;
        height = 2.4;
        color = const Color(0xFF4E342E);
        break;
      case ObstacleType.rockPillar:
        width = 3.8;
        height = 9.0;
        color = const Color(0xFF607D8B);
        break;
      case ObstacleType.thornyBush:
        width = 4.2;
        height = 4.2;
        color = const Color(0xFF33691E);
        break;
      case ObstacleType.predatorBird:
        width = 5.0;
        height = 2.5;
        color = const Color(0xFF212121);
        break;
    }

    final isMoving = _random.nextDouble() < currentLevel.movingObstacleChance;
    final oscSpeed = isMoving ? (1.5 + _random.nextDouble() * 2.0) : 0.0;
    final oscAmp = isMoving ? (2.5 + _random.nextDouble() * 2.5) : 0.0;

    obstacles.add(ObstacleEntity(
      position: Vector3D(posX, posY, spawnZ),
      type: type,
      width: width,
      height: height,
      baseColor: color,
      oscillationSpeed: oscSpeed,
      oscillationAmplitude: oscAmp,
    ));
  }

  void _spawnCollectible() {
    final type = _random.nextBool() ? CollectibleType.water : CollectibleType.seed;
    final spawnZ = AppConstants.spawnDistanceZ;
    final posX = (_random.nextDouble() - 0.5) * (AppConstants.worldWidth * 0.65);
    final posY = (_random.nextDouble() - 0.5) * (AppConstants.worldHeight * 0.6);

    collectibles.add(CollectibleEntity(
      position: Vector3D(posX, posY, spawnZ),
      type: type,
      radius: 1.1,
    ));
  }
}
