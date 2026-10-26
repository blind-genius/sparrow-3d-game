import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../controllers/game_controller.dart';
import '../core/app_constants.dart';
import '../engine_3d/world_3d_renderer.dart';
import '../models/game_status.dart';
import '../widgets/hud_overlay.dart';
import 'dialogs/game_over_dialog.dart';
import 'dialogs/level_complete_dialog.dart';
import 'dialogs/victory_dialog.dart';

class GamePlayView extends StatefulWidget {
  final GameController controller;

  const GamePlayView({super.key, required this.controller});

  @override
  State<GamePlayView> createState() => _GamePlayViewState();
}

class _GamePlayViewState extends State<GamePlayView> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _lastTick = Duration.zero;
  final FocusNode _focusNode = FocusNode();

  // Keyboard navigation state
  final Set<LogicalKeyboardKey> _pressedKeys = {};

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (_lastTick == Duration.zero) {
      _lastTick = elapsed;
      return;
    }

    final dt = (elapsed - _lastTick).inMicroseconds / 1000000.0;
    _lastTick = elapsed;

    // Constrain delta time to prevent physics anomalies on frame drops
    final clampedDt = dt.clamp(0.001, 0.05);

    // Process keyboard inputs if any
    _processKeyboardInput();

    widget.controller.update(clampedDt);
  }

  void _processKeyboardInput() {
    if (_pressedKeys.isEmpty) return;

    double vx = 0;
    double vy = 0;

    if (_pressedKeys.contains(LogicalKeyboardKey.arrowLeft) ||
        _pressedKeys.contains(LogicalKeyboardKey.keyA)) {
      vx -= 1.0;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.arrowRight) ||
        _pressedKeys.contains(LogicalKeyboardKey.keyD)) {
      vx += 1.0;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.arrowUp) ||
        _pressedKeys.contains(LogicalKeyboardKey.keyW)) {
      vy += 1.0;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.arrowDown) ||
        _pressedKeys.contains(LogicalKeyboardKey.keyS)) {
      vy -= 1.0;
    }

    widget.controller.setSteeringVelocity(vx, vy);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      _pressedKeys.add(event.logicalKey);
      if (event.logicalKey == LogicalKeyboardKey.keyQ) {
        widget.controller.feedWater();
      } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
        widget.controller.feedSeed();
      }
      return KeyEventResult.handled;
    } else if (event is KeyUpEvent) {
      _pressedKeys.remove(event.logicalKey);
      if (_pressedKeys.isEmpty) {
        widget.controller.setSteeringVelocity(0, 0);
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              fit: StackFit.expand,
              children: [
                // 3D Rendering Viewport
                RepaintBoundary(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: World3DRenderer(
                      sparrow: controller.sparrow,
                      obstacles: controller.obstacles,
                      collectibles: controller.collectibles,
                      particles: controller.particles,
                      level: controller.currentLevel,
                      distanceTraveled: controller.distanceTraveled,
                      sparrowFlyingImage: controller.sparrowFlyingImage,
                      sparrowRestingImage: controller.sparrowRestingImage,
                      sparrowWoundedImage: controller.sparrowWoundedImage,
                      backgroundImage: controller.backgroundImage,
                      camera: controller.camera,
                    ),
                  ),
                ),

                // Interactive HUD Overlay
                HudOverlay(controller: controller),

                // Pause State Overlay
                if (controller.gameState == GameState.paused)
                  _buildPauseOverlay(context),

                // Game Over Dialog (When Sparrow HP reaches 0)
                if (controller.gameState == GameState.gameOver)
                  GameOverDialog(controller: controller),

                // Level Completed Dialog
                if (controller.gameState == GameState.levelCompleted)
                  LevelCompleteDialog(controller: controller),

                // All 10 Levels Won Victory Dialog
                if (controller.gameState == GameState.allLevelsWon)
                  VictoryDialog(controller: controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPauseOverlay(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Colors.black.withValues(alpha: 0.75),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF2B1D12),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.accent, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pause_circle_filled, color: AppColors.accent, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'بازی متوقف شد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: widget.controller.resumeGame,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('ادامه بازی', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white38),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: widget.controller.restartLevel,
                  icon: const Icon(Icons.replay),
                  label: const Text('شروع مجدد این مرحله'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: widget.controller.returnToMenu,
                  child: const Text('بازگشت به منوی اصلی', style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
