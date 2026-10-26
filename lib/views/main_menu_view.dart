import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../core/app_constants.dart';
import '../core/audio_manager.dart';

class MainMenuView extends StatelessWidget {
  final GameController controller;
  final VoidCallback onOpenLevelSelect;

  const MainMenuView({
    super.key,
    required this.controller,
    required this.onOpenLevelSelect,
  });

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF2B1D12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: AppColors.accent, width: 2),
          ),
          title: const Row(
            children: [
              Icon(Icons.menu_book, color: AppColors.accent),
              SizedBox(width: 8),
              Text('راهنمای بازی', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _GuideItem(
                  icon: Icons.navigation,
                  title: 'هدایت گنجشک',
                  desc: 'با کشیدن جوی‌استیک لمسی پایین، گنجشک را در فضا به چپ، راست، بالا و پایین ببرید.',
                ),
                SizedBox(height: 12),
                _GuideItem(
                  icon: Icons.water_drop,
                  color: AppColors.waterBlue,
                  title: 'آب و دانه (رشد گنجشک)',
                  desc: 'با جمع‌آوری قطرات آب و دانه‌ها در مسیر یا زدن دکمه‌های غذا، جون پرنده بازیابی شده و اندازه گنجشک به صورت محسوس رشد می‌کند!',
                ),
                SizedBox(height: 12),
                _GuideItem(
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.woundRed,
                  title: 'موانع و جراحت',
                  desc: 'برخورد با تنه‌های درخت، شاخه‌ها و صخره‌ها باعث کسر ۵۰ امتیاز، کاهش جون و زخمی شدن گنجشک می‌شود. با صفر شدن جون، کاربر می‌بازد.',
                ),
                SizedBox(height: 12),
                _GuideItem(
                  icon: Icons.looks_one,
                  color: AppColors.gold,
                  title: '۱۰ مرحله چالشی',
                  desc: 'بازی دارای ۱۰ مرحله جذاب با سرعت، محیط و سختی افزایشی است.',
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('متوجه شدم!'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background Artwork (Zahra's painting)
            Image.asset(
              'assets/images/background_resting.jpg',
              fit: BoxFit.cover,
            ),

            // Gradient Tint Overlay for readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.75),
                    Colors.black.withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Main Menu Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Audio & Help icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Sound toggle
                        IconButton(
                          icon: Icon(
                            AudioManager.instance.isSoundEnabled
                                ? Icons.volume_up
                                : Icons.volume_off,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            AudioManager.instance.toggleSound();
                            (context as Element).markNeedsBuild();
                          },
                        ),
                        // Help button
                        IconButton(
                          icon: const Icon(Icons.help_outline, color: Colors.white, size: 28),
                          onPressed: () => _showHowToPlay(context),
                        ),
                      ],
                    ),

                    // Title & Sparrow Logo
                    Column(
                      children: [
                        // Sparrow resting cutout
                        Hero(
                          tag: 'sparrow_logo',
                          child: Image.asset(
                            'assets/images/sparrow_resting.png',
                            width: 170,
                            height: 170,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          AppConstants.appTitle,
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 16, offset: Offset(0, 3)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
                          ),
                          child: const Text(
                            AppConstants.appSubtitle,
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // High score display
                        if (controller.highScore > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.gold, width: 1.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.emoji_events, color: AppColors.gold, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'رکورد شما: ${controller.highScore.toInt()}',
                                  style: const TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    // Menu Action Buttons
                    Column(
                      children: [
                        // Start Play Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 8,
                            ),
                            onPressed: () => controller.startLevel(controller.highestUnlockedLevel),
                            icon: const Icon(Icons.play_arrow_rounded, size: 30),
                            label: Text(
                              controller.highestUnlockedLevel > 1
                                  ? 'ادامه بازی (مرحله ${controller.highestUnlockedLevel})'
                                  : 'شروع پرواز',
                              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Select Level Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: AppColors.accent, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.black.withValues(alpha: 0.4),
                            ),
                            onPressed: onOpenLevelSelect,
                            icon: const Icon(Icons.grid_view_rounded, size: 24),
                            label: const Text(
                              'انتخاب مرحله (۱۰ مرحله)',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // How to play button
                        TextButton.icon(
                          onPressed: () => _showHowToPlay(context),
                          icon: const Icon(Icons.info_outline, color: Colors.white70, size: 18),
                          label: const Text(
                            'راهنمای بازی و رشد گنجشک',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;

  const _GuideItem({
    required this.icon,
    this.color = AppColors.accent,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
