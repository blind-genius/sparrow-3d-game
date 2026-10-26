import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../core/app_constants.dart';
import '../models/level_data.dart';

class LevelSelectView extends StatelessWidget {
  final GameController controller;
  final VoidCallback onBack;

  const LevelSelectView({
    super.key,
    required this.controller,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final highestUnlocked = controller.highestUnlockedLevel;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.warmBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'انتخاب مرحله (۱۰ مرحله)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: LevelData.allLevels.length,
          itemBuilder: (context, index) {
            final level = LevelData.allLevels[index];
            final isUnlocked = level.levelNumber <= highestUnlocked;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: isUnlocked
                      ? [
                          level.skyColorBottom.withValues(alpha: 0.8),
                          level.skyColorTop.withValues(alpha: 0.5),
                        ]
                      : [Colors.grey.shade900, Colors.grey.shade800],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                border: Border.all(
                  color: isUnlocked ? AppColors.accent : Colors.white12,
                  width: isUnlocked ? 1.8 : 1.0,
                ),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isUnlocked
                        ? AppColors.accent.withValues(alpha: 0.3)
                        : Colors.white10,
                    border: Border.all(
                      color: isUnlocked ? AppColors.gold : Colors.white24,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: isUnlocked
                        ? Text(
                            '${level.levelNumber}',
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        : const Icon(Icons.lock, color: Colors.white38, size: 22),
                  ),
                ),
                title: Text(
                  level.title,
                  style: TextStyle(
                    color: isUnlocked ? Colors.white : Colors.white38,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      level.subtitle,
                      style: TextStyle(
                        color: isUnlocked ? Colors.white70 : Colors.white24,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.speed,
                          size: 14,
                          color: isUnlocked ? AppColors.accent : Colors.white24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'سرعت: ${level.flightSpeed.toInt()} | مسافت: ${level.targetDistance.toInt()}m',
                          style: TextStyle(
                            color: isUnlocked ? Colors.white54 : Colors.white24,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: isUnlocked
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () => controller.startLevel(level.levelNumber),
                        child: const Text('شروع', style: TextStyle(fontSize: 14)),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
