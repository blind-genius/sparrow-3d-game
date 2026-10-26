import 'package:flutter/material.dart';
import 'obstacle_entity.dart';

class LevelData {
  final int levelNumber;
  final String title;
  final String subtitle;
  final double targetDistance;
  final double flightSpeed;
  final double obstacleSpawnInterval; // Seconds between obstacle spawns
  final double collectibleSpawnInterval;
  final List<ObstacleType> allowedObstacles;
  final Color skyColorTop;
  final Color skyColorBottom;
  final Color fogColor;
  final double movingObstacleChance;
  final String description;

  const LevelData({
    required this.levelNumber,
    required this.title,
    required this.subtitle,
    required this.targetDistance,
    required this.flightSpeed,
    required this.obstacleSpawnInterval,
    required this.collectibleSpawnInterval,
    required this.allowedObstacles,
    required this.skyColorTop,
    required this.skyColorBottom,
    required this.fogColor,
    required this.movingObstacleChance,
    required this.description,
  });

  static const List<LevelData> allLevels = [
    LevelData(
      levelNumber: 1,
      title: 'مرحله ۱: آغاز پرواز در بیشه‌زار',
      subtitle: 'یادگیری کنترل گنجشک، جمع‌آوری آب و دانه',
      targetDistance: 500.0,
      flightSpeed: 12.0,
      obstacleSpawnInterval: 2.8,
      collectibleSpawnInterval: 1.6,
      allowedObstacles: [ObstacleType.treeTrunk],
      skyColorTop: Color(0xFF6A9955),
      skyColorBottom: Color(0xFF8D5524),
      fogColor: Color(0x666A9955),
      movingObstacleChance: 0.0,
      description: 'پرواز را بیاموزید، از شاخه‌ها بگذرید و با خوردن آب و دانه رشد کنید.',
    ),
    LevelData(
      levelNumber: 2,
      title: 'مرحله ۲: جنگل پاییزی',
      subtitle: 'وزش نسیم ملایم و شاخه‌های افقی',
      targetDistance: 650.0,
      flightSpeed: 13.5,
      obstacleSpawnInterval: 2.4,
      collectibleSpawnInterval: 1.7,
      allowedObstacles: [ObstacleType.treeTrunk, ObstacleType.horizontalLog],
      skyColorTop: Color(0xFFD48B38),
      skyColorBottom: Color(0xFF5D3614),
      fogColor: Color(0x66D48B38),
      movingObstacleChance: 0.15,
      description: 'برگ‌های طلایی پاییز فرود می‌آیند و شاخه‌های تنومند در مسیرند.',
    ),
    LevelData(
      levelNumber: 3,
      title: 'مرحله ۳: گذرگاه درختان کهنسال',
      subtitle: 'تراکم بیشتر تنه‌های تنومند بلوط',
      targetDistance: 800.0,
      flightSpeed: 15.0,
      obstacleSpawnInterval: 2.1,
      collectibleSpawnInterval: 1.8,
      allowedObstacles: [ObstacleType.treeTrunk, ObstacleType.horizontalLog],
      skyColorTop: Color(0xFF385E38),
      skyColorBottom: Color(0xFF263D26),
      fogColor: Color(0x77385E38),
      movingObstacleChance: 0.25,
      description: 'درختان چندصد ساله راه پرواز را تنگ‌تر ساخته‌اند.',
    ),
    LevelData(
      levelNumber: 4,
      title: 'مرحله ۴: صخره‌های سنگی و بادهای تند',
      subtitle: 'ظهور صخره‌های نوک‌تیز در مسیر',
      targetDistance: 950.0,
      flightSpeed: 16.5,
      obstacleSpawnInterval: 1.9,
      collectibleSpawnInterval: 1.8,
      allowedObstacles: [ObstacleType.treeTrunk, ObstacleType.rockPillar],
      skyColorTop: Color(0xFF5C6F84),
      skyColorBottom: Color(0xFF37474F),
      fogColor: Color(0x775C6F84),
      movingObstacleChance: 0.35,
      description: 'صخره‌های خارا در میان درختان ظاهر شده‌اند؛ با دقت هدایت کنید.',
    ),
    LevelData(
      levelNumber: 5,
      title: 'مرحله ۵: برکه نیلوفرها و باران بهاری',
      subtitle: 'قطرات فراوان آب و موانع بوته‌ای خاردار',
      targetDistance: 1100.0,
      flightSpeed: 18.0,
      obstacleSpawnInterval: 1.7,
      collectibleSpawnInterval: 1.5,
      allowedObstacles: [ObstacleType.treeTrunk, ObstacleType.thornyBush],
      skyColorTop: Color(0xFF2E6F8E),
      skyColorBottom: Color(0xFF1B4965),
      fogColor: Color(0x882E6F8E),
      movingObstacleChance: 0.40,
      description: 'باران بهاری فضا را پرطراوت کرده، مراقب بوته‌های خار باشید.',
    ),
    LevelData(
      levelNumber: 6,
      title: 'مرحله ۶: بیشه مه‌آلود',
      subtitle: 'کاهش دید و نیاز به واکنش‌های سریع',
      targetDistance: 1250.0,
      flightSpeed: 19.5,
      obstacleSpawnInterval: 1.6,
      collectibleSpawnInterval: 1.8,
      allowedObstacles: [ObstacleType.treeTrunk, ObstacleType.horizontalLog, ObstacleType.rockPillar],
      skyColorTop: Color(0xFF5A6B7C),
      skyColorBottom: Color(0xFF2C3E50),
      fogColor: Color(0xAA5A6B7C),
      movingObstacleChance: 0.45,
      description: 'مه غلیظ جنگل را فرا گرفته و موانع ناگهانی از راه می‌رسند.',
    ),
    LevelData(
      levelNumber: 7,
      title: 'مرحله ۷: قلمرو شاهین‌ها',
      subtitle: 'پرندگان شکارچی در آسمان پرواز می‌کنند',
      targetDistance: 1400.0,
      flightSpeed: 21.0,
      obstacleSpawnInterval: 1.5,
      collectibleSpawnInterval: 1.9,
      allowedObstacles: [ObstacleType.treeTrunk, ObstacleType.predatorBird, ObstacleType.rockPillar],
      skyColorTop: Color(0xFF7E3817),
      skyColorBottom: Color(0xFF3E1F11),
      fogColor: Color(0x887E3817),
      movingObstacleChance: 0.55,
      description: 'شاهین‌های گشت‌زن در آسمان چرخ می‌زنند، از مسیرشان دور بمانید.',
    ),
    LevelData(
      levelNumber: 8,
      title: 'مرحله ۸: تندباد پاییزی و طوفان',
      subtitle: 'سرعت بالا و شاخه‌های متحرک در باد',
      targetDistance: 1600.0,
      flightSpeed: 22.5,
      obstacleSpawnInterval: 1.4,
      collectibleSpawnInterval: 1.9,
      allowedObstacles: [ObstacleType.horizontalLog, ObstacleType.thornyBush, ObstacleType.rockPillar],
      skyColorTop: Color(0xFF4A3B32),
      skyColorBottom: Color(0xFF2B1E16),
      fogColor: Color(0x884A3B32),
      movingObstacleChance: 0.65,
      description: 'طوفان سهمگین شاخه‌ها و خارها را به رقص درآورده است.',
    ),
    LevelData(
      levelNumber: 9,
      title: 'مرحله ۹: دره سنگلاخ گرگ‌ومیش',
      subtitle: 'محیطی باریک با موانع متراکم و پی‌درپی',
      targetDistance: 1800.0,
      flightSpeed: 24.0,
      obstacleSpawnInterval: 1.3,
      collectibleSpawnInterval: 2.0,
      allowedObstacles: [ObstacleType.rockPillar, ObstacleType.predatorBird, ObstacleType.thornyBush],
      skyColorTop: Color(0xFF4A2545),
      skyColorBottom: Color(0xFF1E0E1C),
      fogColor: Color(0x994A2545),
      movingObstacleChance: 0.75,
      description: 'در گرگ‌ومیش غروب، شکاف صخره‌ها تنها راه عبور قهرمان پرواز است.',
    ),
    LevelData(
      levelNumber: 10,
      title: 'مرحله ۱۰: اوج آسمان و پرواز قهرمانانه',
      subtitle: 'آزمون نهایی مهارت، سرعت و استقامت گنجشک',
      targetDistance: 2100.0,
      flightSpeed: 26.0,
      obstacleSpawnInterval: 1.2,
      collectibleSpawnInterval: 2.1,
      allowedObstacles: [
        ObstacleType.treeTrunk,
        ObstacleType.horizontalLog,
        ObstacleType.rockPillar,
        ObstacleType.predatorBird,
        ObstacleType.thornyBush
      ],
      skyColorTop: Color(0xFFB76D29),
      skyColorBottom: Color(0xFF421E07),
      fogColor: Color(0x99B76D29),
      movingObstacleChance: 0.85,
      description: 'مرحله نهایی! از تمام خطرات بگذرید تا به عنوان قهرمان جنگل جاودانه شوید.',
    ),
  ];

  static LevelData getLevel(int number) {
    if (number < 1) return allLevels.first;
    if (number > allLevels.length) return allLevels.last;
    return allLevels[number - 1];
  }
}
