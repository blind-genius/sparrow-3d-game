import 'package:flutter/material.dart';
import '../../controllers/game_controller.dart';
import '../../core/app_constants.dart';

class GameOverDialog extends StatelessWidget {
  final GameController controller;

  const GameOverDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2A1515).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.redAccent, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.35),
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
                  color: Colors.red.withValues(alpha: 0.2),
                ),
                child: const Icon(Icons.heart_broken, color: Colors.redAccent, size: 54),
              ),
              const SizedBox(height: 16),
              const Text(
                'بازی تمام شد!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'جون گنجشک به پایان رسید و توان پرواز را از دست داد.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
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
                        const Text('امتیاز کسب‌شده:', style: TextStyle(color: Colors.white70)),
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
                        const Text('مسافت طی‌شده:', style: TextStyle(color: Colors.white70)),
                        Text(
                          '${controller.distanceTraveled.toInt()} متر',
                          style: const TextStyle(
                            color: Colors.white,
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
                      child: const Text('منوی اصلی'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: controller.restartLevel,
                      icon: const Icon(Icons.replay),
                      label: const Text('تلاش مجدد'),
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
