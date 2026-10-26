import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'vector3d.dart';

enum ParticleType {
  feather,     // Brown/reddish feathers when wounded
  waterSplash, // Refreshing blue drops
  seedSparkle, // Radiant golden stars
  growthAura,  // Emerald/gold expansion rings
  speedStreak, // White flight lines
}

class Particle3D {
  Vector3D position;
  Vector3D velocity;
  Color color;
  double size;
  double life; // 1.0 -> 0.0
  double maxLife;
  ParticleType type;
  double rotation;
  double rotationSpeed;

  Particle3D({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.maxLife,
    required this.type,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
  }) : life = 1.0;

  bool update(double dt) {
    position = position + (velocity * dt);
    life -= dt / maxLife;
    rotation += rotationSpeed * dt;
    return life > 0;
  }

  static List<Particle3D> createWoundBurst(Vector3D origin) {
    final random = math.Random();
    final list = <Particle3D>[];
    for (int i = 0; i < 18; i++) {
      final vx = (random.nextDouble() - 0.5) * 12.0;
      final vy = (random.nextDouble() - 0.2) * 10.0;
      final vz = (random.nextDouble() - 0.5) * 8.0;
      final isFeather = random.nextBool();
      list.add(Particle3D(
        position: Vector3D.copy(origin),
        velocity: Vector3D(vx, vy, vz),
        color: isFeather
            ? const Color(0xFF8D5524)
            : const Color(0xFFE53935).withValues(alpha: 0.9),
        size: isFeather ? 8.0 + random.nextDouble() * 6.0 : 4.0 + random.nextDouble() * 4.0,
        maxLife: 0.8 + random.nextDouble() * 0.6,
        type: isFeather ? ParticleType.feather : ParticleType.feather,
        rotation: random.nextDouble() * math.pi * 2,
        rotationSpeed: (random.nextDouble() - 0.5) * 10.0,
      ));
    }
    return list;
  }

  static List<Particle3D> createWaterSplash(Vector3D origin) {
    final random = math.Random();
    final list = <Particle3D>[];
    for (int i = 0; i < 14; i++) {
      final vx = (random.nextDouble() - 0.5) * 8.0;
      final vy = (random.nextDouble() + 0.5) * 6.0;
      final vz = (random.nextDouble() - 0.5) * 6.0;
      list.add(Particle3D(
        position: Vector3D.copy(origin),
        velocity: Vector3D(vx, vy, vz),
        color: const Color(0xFF29B6F6).withValues(alpha: 0.8),
        size: 5.0 + random.nextDouble() * 4.0,
        maxLife: 0.6 + random.nextDouble() * 0.4,
        type: ParticleType.waterSplash,
        rotation: 0,
        rotationSpeed: 0,
      ));
    }
    return list;
  }

  static List<Particle3D> createSeedSparkle(Vector3D origin) {
    final random = math.Random();
    final list = <Particle3D>[];
    for (int i = 0; i < 16; i++) {
      final vx = (random.nextDouble() - 0.5) * 7.0;
      final vy = (random.nextDouble() - 0.3) * 7.0;
      final vz = (random.nextDouble() - 0.5) * 7.0;
      list.add(Particle3D(
        position: Vector3D.copy(origin),
        velocity: Vector3D(vx, vy, vz),
        color: const Color(0xFFFFD54F),
        size: 6.0 + random.nextDouble() * 5.0,
        maxLife: 0.7 + random.nextDouble() * 0.5,
        type: ParticleType.seedSparkle,
        rotation: random.nextDouble() * math.pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 8.0,
      ));
    }
    return list;
  }
}
