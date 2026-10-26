import 'dart:math' as math;
import '../core/app_constants.dart';
import '../engine_3d/vector3d.dart';

class SparrowEntity {
  Vector3D position;
  Vector3D velocity;
  double health;
  double scale;
  
  // Visual & flight orientation
  double roll;  // Banking when turning left/right
  double pitch; // Nose up/down
  double flapTimer;
  bool isFlapping;
  
  // Wounded / Injury state
  bool isWounded;
  double woundDuration;
  double invulnerabilityTimer;
  
  // Feed & Growth stats
  int seedsEaten;
  int waterDrunk;

  SparrowEntity()
      : position = Vector3D(0.0, 0.0, 0.0),
        velocity = Vector3D.zero(),
        health = AppConstants.initialHealth,
        scale = AppConstants.initialScale,
        roll = 0.0,
        pitch = 0.0,
        flapTimer = 0.0,
        isFlapping = false,
        isWounded = false,
        woundDuration = 0.0,
        invulnerabilityTimer = 0.0,
        seedsEaten = 0,
        waterDrunk = 0;

  void reset() {
    position = Vector3D(0.0, 0.0, 0.0);
    velocity = Vector3D.zero();
    health = AppConstants.initialHealth;
    scale = AppConstants.initialScale;
    roll = 0.0;
    pitch = 0.0;
    flapTimer = 0.0;
    isFlapping = false;
    isWounded = false;
    woundDuration = 0.0;
    invulnerabilityTimer = 0.0;
    seedsEaten = 0;
    waterDrunk = 0;
  }

  void update(double dt) {
    // Flight dynamics & banking smoothing
    position.x += velocity.x * dt;
    position.y += velocity.y * dt;

    // Constrain inside bounds
    final boundX = AppConstants.worldWidth * 0.45;
    final boundY = AppConstants.worldHeight * 0.42;
    position.x = position.x.clamp(-boundX, boundX);
    position.y = position.y.clamp(-boundY, boundY);

    // Natural banking roll based on horizontal velocity
    final targetRoll = (-velocity.x * 0.08).clamp(-0.45, 0.45);
    roll += (targetRoll - roll) * (dt * 8.0);

    // Pitch based on climb/dive
    final targetPitch = (velocity.y * 0.06).clamp(-0.35, 0.35);
    pitch += (targetPitch - pitch) * (dt * 8.0);

    // Flap animation cycle (rapid wings flap)
    flapTimer += dt * 14.0;
    isFlapping = (math.sin(flapTimer) > 0.1);

    // Wound timers
    if (woundDuration > 0) {
      woundDuration -= dt;
      if (woundDuration <= 0) {
        isWounded = false;
      }
    }

    if (invulnerabilityTimer > 0) {
      invulnerabilityTimer -= dt;
    }
  }

  // Wounded reaction when colliding with obstacle
  bool hitObstacle(double damage) {
    if (invulnerabilityTimer > 0) return false;

    health = (health - damage).clamp(0.0, AppConstants.maxHealth);
    isWounded = true;
    woundDuration = 1.2; // 1.2 seconds of wound distress visual
    invulnerabilityTimer = 1.5; // Brief invulnerability window

    // Slight recoil
    velocity.y = -2.0;
    return true;
  }

  // Feeding & Drinking mechanics -> Growth
  void drinkWater() {
    waterDrunk++;
    health = (health + AppConstants.waterHealthBonus).clamp(0.0, AppConstants.maxHealth);
    scale = math.min(AppConstants.maxGrowthScale, scale + AppConstants.growthPerItem);
  }

  void eatSeed() {
    seedsEaten++;
    health = (health + AppConstants.seedHealthBonus).clamp(0.0, AppConstants.maxHealth);
    scale = math.min(AppConstants.maxGrowthScale, scale + AppConstants.growthPerItem * 1.2);
  }

  // Radius for 3D collision check based on current growth scale
  double get collisionRadius => 1.1 * scale;
}
