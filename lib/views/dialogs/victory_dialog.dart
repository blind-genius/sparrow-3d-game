import 'package:flutter/material.dart';
import '../../controllers/game_controller.dart';
import '../../core/app_constants.dart';

class VictoryDialog extends StatelessWidget {
  final GameController controller;

  const VictoryDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3E2723), Color(0xFF1B0000)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.gold, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withValues(alpha: 0.2),
                ),
                child: const Icon(Icons.emoji_events, color: AppColors.gold, size: 64),
              ),
              const SizedBox(height: 16),
              const Text(
                'تبریک قهرمان پرواز!',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'شما تمام ۱۰ مرحله سخت و هیجان‌انگیز را با موفقیت به پایان رساندید!\nگنجشک کوچک اکنون به پرنده‌ای نیرومند و اسطوره‌ای در جنگل تبدیل شده است.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مجموع امتیاز نهایی:', style: TextStyle(color: Colors.white70)),
                    Text(
                      '${controller.score.toInt()}',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: controller.returnToMenu,
                icon: const Icon(Icons.home),
                label: const Text(
                  'بازگشت به منوی اصلی',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
