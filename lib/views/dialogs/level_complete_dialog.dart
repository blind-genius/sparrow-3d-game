import 'package:flutter/material.dart';
import '../../controllers/game_controller.dart';
import '../../core/app_constants.dart';

class LevelCompleteDialog extends StatelessWidget {
  final GameController controller;

  const LevelCompleteDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final level = controller.currentLevel;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2E1D).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF66BB6A), width: 2.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF66BB6A).withValues(alpha: 0.35),
                blurRadius: 25,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF66BB6A).withValues(alpha: 0.2),
                ),
                child: const Icon(Icons.workspace_premium, color: Color(0xFFFFD54F), size: 54),
              ),
              const SizedBox(height: 16),
              const Text(
                'مرحله با موفقیت فتح شد!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                level.title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFA5D6A7), fontSize: 14),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('امتیاز این مرحله:', style: TextStyle(color: Colors.white70)),
                        Text(
                          '${controller.score.toInt()}',
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white12, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('رشد نهایی گنجشک:', style: TextStyle(color: Colors.white70)),
                        Text(
                          '${controller.sparrow.scale.toStringAsFixed(1)}x',
                          style: const TextStyle(
                            color: Color(0xFF81C784),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: controller.returnToMenu,
                      child: const Text('منو'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF43A047),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: controller.nextLevel,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('مرحله بعد'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
