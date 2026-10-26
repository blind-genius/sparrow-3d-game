import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../core/app_constants.dart';
import 'joystick_pad.dart';

class HudOverlay extends StatelessWidget {
  final GameController controller;

  const HudOverlay({super.key, required this.controller});

  String _getGrowthTitle(double scale) {
    if (scale < 1.15) return 'جوجه گنجشک';
    if (scale < 1.45) return 'گنجشک چالاک';
    if (scale < 1.85) return 'گنجشک قوی‌بال';
    return 'شاهین‌گنجشک افسانه‌ای';
  }

  @override
  Widget build(BuildContext context) {
    final sparrow = controller.sparrow;
    final level = controller.currentLevel;
    final progress = (controller.distanceTraveled / level.targetDistance).clamp(0.0, 1.0);
    final healthRatio = (sparrow.health / AppConstants.maxHealth).clamp(0.0, 1.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Stack(
          children: [
            // Top HUD Bar
            Positioned(
              top: 8,
              left: 12,
              right: 12,
              child: Column(
                children: [
                  // Health, Score & Pause row
                  Row(
                    children: [
                      // Health Bar (جون گنجشک)
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sparrow.isWounded ? Colors.redAccent : AppColors.accent,
                              width: sparrow.isWounded ? 2.5 : 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: sparrow.isWounded ? Colors.redAccent : Colors.red,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: healthRatio,
                                    minHeight: 12,
                                    backgroundColor: Colors.white24,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      healthRatio > 0.5
                                          ? const Color(0xFF66BB6A)
                                          : (healthRatio > 0.25 ? Colors.orange : Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${sparrow.health.toInt()}٪',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Score Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.gold, width: 1.2),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.gold, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              '${controller.score.toInt()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Pause Button
                      GestureDetector(
                        onTap: controller.pauseGame,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white38, width: 1.2),
                          ),
                          child: const Icon(Icons.pause, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Level Distance Progress Bar & Growth Badge
                  Row(
                    children: [
                      // Level Title & Distance
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    level.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${controller.distanceTraveled.toInt()}m / ${level.targetDistance.toInt()}m',
                                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 6,
                                  backgroundColor: Colors.white12,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Sparrow Growth Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF81C784), width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.height, color: Color(0xFF81C784), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${_getGrowthTitle(sparrow.scale)} (${sparrow.scale.toStringAsFixed(1)}x)',
                              style: const TextStyle(
                                color: Color(0xFFC8E6C9),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Wounded Alert banner at top when injured
            if (sparrow.isWounded)
              Positioned(
                top: 85,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.5),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'برخورد با مانع! گنجشک زخمی شد (-۵۰ امتیاز)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bottom Controls Area
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Dual Virtual Joystick on Bottom Left
                  JoystickPad(
                    onDirectionChanged: controller.setSteeringVelocity,
                  ),

                  // Feeding Buttons on Bottom Right (User gives water & seeds)
                  Row(
                    children: [
                      // Water button
                      _FeedButton(
                        icon: Icons.water_drop,
                        label: 'آب بده',
                        count: controller.waterSupply,
                        color: AppColors.waterBlue,
                        onTap: controller.feedWater,
                      ),
                      const SizedBox(width: 14),
                      // Seed button
                      _FeedButton(
                        icon: Icons.grain,
                        label: 'دانه بده',
                        count: controller.seedSupply,
                        color: AppColors.gold,
                        onTap: controller.feedSeed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _FeedButton({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  State<_FeedButton> createState() => _FeedButtonState();
}

class _FeedButtonState extends State<_FeedButton> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animController.forward().then((_) => _animController.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.65),
            border: Border.all(color: widget.color, width: 2),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.color, size: 24),
              const SizedBox(height: 2),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.count}',
                style: TextStyle(
                  color: widget.color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
