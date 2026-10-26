import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/collectible_entity.dart';
import '../models/level_data.dart';
import '../models/obstacle_entity.dart';
import '../models/sparrow_entity.dart';
import 'camera_3d.dart';
import 'particle_3d.dart';
import 'vector3d.dart';

class World3DRenderer extends CustomPainter {
  final SparrowEntity sparrow;
  final List<ObstacleEntity> obstacles;
  final List<CollectibleEntity> collectibles;
  final List<Particle3D> particles;
  final LevelData level;
  final double distanceTraveled;
  final ui.Image? sparrowFlyingImage;
  final ui.Image? sparrowRestingImage;
  final ui.Image? sparrowWoundedImage;
  final ui.Image? backgroundImage;
  final Camera3D camera;

  World3DRenderer({
    required this.sparrow,
    required this.obstacles,
    required this.collectibles,
    required this.particles,
    required this.level,
    required this.distanceTraveled,
    required this.sparrowFlyingImage,
    required this.sparrowRestingImage,
    required this.sparrowWoundedImage,
    required this.backgroundImage,
    required this.camera,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw atmospheric sky gradient
    final skyPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [level.skyColorTop, level.skyColorBottom],
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    // 2. Draw Zahra's original painting artwork as panoramic parallax background
    if (backgroundImage != null) {
      _drawParallaxBackground(canvas, size);
    }

    // 3. Draw 3D forest depth canopy and horizon
    _drawForestDepthLines(canvas, size);

    // 4. Collect all renderables and sort by depth Z (Painters Algorithm: back to front)
    final renderList = <_RenderItem>[];

    for (final obs in obstacles) {
      final proj = camera.project(obs.position, size);
      if (proj.isVisible) {
        renderList.add(_RenderItem(
          depth: proj.depth,
          draw: () => _drawObstacle(canvas, size, obs, proj),
        ));
      }
    }

    for (final col in collectibles) {
      final pos = Vector3D(col.position.x, col.position.y + col.hoverOffset, col.position.z);
      final proj = camera.project(pos, size);
      if (proj.isVisible) {
        renderList.add(_RenderItem(
          depth: proj.depth,
          draw: () => _drawCollectible(canvas, col, proj),
        ));
      }
    }

    for (final part in particles) {
      final proj = camera.project(part.position, size);
      if (proj.isVisible) {
        renderList.add(_RenderItem(
          depth: proj.depth,
          draw: () => _drawParticle(canvas, part, proj),
        ));
      }
    }

    // Sparrow projected position
    final sparrowProj = camera.project(sparrow.position, size);
    renderList.add(_RenderItem(
      depth: sparrowProj.depth,
      draw: () {
        _drawSparrowShadow(canvas, size, sparrowProj);
        _drawSparrow(canvas, sparrowProj);
      },
    ));

    // Sort descending: largest depth (farthest away) drawn first
    renderList.sort((a, b) => b.depth.compareTo(a.depth));

    // Execute sorted draw calls
    for (final item in renderList) {
      item.draw();
    }

    // 5. Draw atmospheric depth vignette / fog edges
    _drawAtmosphericVignette(canvas, size);
  }

  void _drawParallaxBackground(Canvas canvas, Size size) {
    final img = backgroundImage!;
    final parallaxX = (sparrow.position.x * 12.0) % size.width;
    final src = Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble());
    
    // Smooth opacity so the artistic painting blends into current level's ambient color
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.38)
      ..filterQuality = FilterQuality.medium;

    final dst1 = Rect.fromLTWH(-parallaxX, 0, size.width, size.height);
    final dst2 = Rect.fromLTWH(-parallaxX + size.width, 0, size.width, size.height);
    final dst3 = Rect.fromLTWH(-parallaxX - size.width, 0, size.width, size.height);

    canvas.drawImageRect(img, src, dst1, bgPaint);
    canvas.drawImageRect(img, src, dst2, bgPaint);
    canvas.drawImageRect(img, src, dst3, bgPaint);
  }

  void _drawForestDepthLines(Canvas canvas, Size size) {
    final centerY = size.height * 0.5;
    final pathPaint = Paint()
      ..color = level.fogColor.withValues(alpha: 0.25)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Perspective depth grid lines converging to center
    for (int i = -4; i <= 4; i++) {
      final bottomX = (size.width / 2.0) + (i * size.width * 0.22);
      canvas.drawLine(
        Offset(size.width / 2.0, centerY),
        Offset(bottomX, size.height),
        pathPaint,
      );
    }
  }

  void _drawObstacle(Canvas canvas, Size size, ObstacleEntity obs, ProjectedPoint proj) {
    final scale = proj.scale;
    final w = obs.width * scale * 20.0;
    final h = obs.height * scale * 20.0;
    
    // Depth fog factor (fades into background color when far)
    final fogFactor = (1.0 - (proj.depth / 240.0)).clamp(0.15, 1.0);
    final color = obs.baseColor.withValues(alpha: fogFactor);

    canvas.save();
    canvas.translate(proj.x, proj.y);

    switch (obs.type) {
      case ObstacleType.treeTrunk:
        _drawTreeTrunk(canvas, w, h, color);
        break;
      case ObstacleType.horizontalLog:
        _drawHorizontalLog(canvas, w, h, color);
        break;
      case ObstacleType.rockPillar:
        _drawRockPillar(canvas, w, h, color);
        break;
      case ObstacleType.thornyBush:
        _drawThornyBush(canvas, w, h, color);
        break;
      case ObstacleType.predatorBird:
        _drawPredatorBird(canvas, w, h, color, obs.timeAlive);
        break;
    }

    canvas.restore();
  }

  void _drawTreeTrunk(Canvas canvas, double w, double h, Color color) {
    final trunkRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: w, height: h),
      Radius.circular(w * 0.25),
    );
    
    // 3D cylindrical lighting
    final grad = Paint()
      ..shader = ui.Gradient.linear(
        Offset(-w / 2, 0),
        Offset(w / 2, 0),
        [
          color.withValues(alpha: 0.8),
          Colors.white.withValues(alpha: 0.3 * color.a),
          color,
          Colors.black.withValues(alpha: 0.5 * color.a),
        ],
        [0.0, 0.25, 0.65, 1.0],
      );
    canvas.drawRRect(trunkRect, grad);

    // Leaves at the top
    final leafPaint = Paint()..color = const Color(0xFF2E7D32).withValues(alpha: color.a);
    canvas.drawCircle(Offset(0, -h / 2), w * 0.9, leafPaint);
  }

  void _drawHorizontalLog(Canvas canvas, double w, double h, Color color) {
    final logRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: w, height: h),
      Radius.circular(h * 0.4),
    );
    final grad = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, -h / 2),
        Offset(0, h / 2),
        [
          color.withValues(alpha: 0.7),
          Colors.white.withValues(alpha: 0.25 * color.a),
          color,
          Colors.black.withValues(alpha: 0.6 * color.a),
        ],
      );
    canvas.drawRRect(logRect, grad);
  }

  void _drawRockPillar(Canvas canvas, double w, double h, Color color) {
    final path = Path()
      ..moveTo(0, -h / 2)
      ..lineTo(w / 2, h / 2)
      ..lineTo(-w / 2, h / 2)
      ..close();
    final rockPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(-w / 2, 0),
        Offset(w / 2, 0),
        [color, color.withValues(alpha: 0.5 * color.a), Colors.black54],
      );
    canvas.drawPath(path, rockPaint);
  }

  void _drawThornyBush(Canvas canvas, double w, double h, Color color) {
    final bushPaint = Paint()..color = color;
    canvas.drawCircle(Offset.zero, w * 0.45, bushPaint);
    final thornPaint = Paint()
      ..color = const Color(0xFF8D5524).withValues(alpha: color.a)
      ..strokeWidth = 3.0;
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi) / 4.0;
      final p1 = Offset(math.cos(angle) * w * 0.35, math.sin(angle) * w * 0.35);
      final p2 = Offset(math.cos(angle) * w * 0.6, math.sin(angle) * w * 0.6);
      canvas.drawLine(p1, p2, thornPaint);
    }
  }

  void _drawPredatorBird(Canvas canvas, double w, double h, Color color, double timeAlive) {
    final wingFlap = math.sin(timeAlive * 12.0) * h * 0.35;
    final birdPath = Path()
      ..moveTo(0, -h * 0.2)
      ..lineTo(w * 0.5, wingFlap)
      ..lineTo(w * 0.2, h * 0.3)
      ..lineTo(0, h * 0.1)
      ..lineTo(-w * 0.2, h * 0.3)
      ..lineTo(-w * 0.5, wingFlap)
      ..close();
    final birdPaint = Paint()..color = color;
    canvas.drawPath(birdPath, birdPaint);
  }

  void _drawCollectible(Canvas canvas, CollectibleEntity col, ProjectedPoint proj) {
    final r = col.radius * proj.scale * 22.0;

    canvas.save();
    canvas.translate(proj.x, proj.y);

    if (col.type == CollectibleType.water) {
      // 3D Water Droplet with glow aura and specular shine
      final auraPaint = Paint()
        ..color = const Color(0xFF29B6F6).withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(Offset.zero, r * 1.5, auraPaint);

      final waterShader = Paint()
        ..shader = ui.Gradient.radial(
          Offset(-r * 0.3, -r * 0.3),
          r * 1.2,
          [Colors.white, const Color(0xFF4FC3F7), const Color(0xFF0288D1)],
        );
      canvas.drawCircle(Offset.zero, r, waterShader);

      // Droplet top tip
      final tipPath = Path()
        ..moveTo(-r * 0.5, -r * 0.2)
        ..quadraticBezierTo(0, -r * 1.6, r * 0.5, -r * 0.2)
        ..close();
      canvas.drawPath(tipPath, waterShader);
    } else {
      // 3D Golden Seed / Grain with shine
      final glowPaint = Paint()
        ..color = const Color(0xFFFFD54F).withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(Offset.zero, r * 1.4, glowPaint);

      final seedRect = Rect.fromCenter(center: Offset.zero, width: r * 1.6, height: r * 2.3);
      final seedShader = Paint()
        ..shader = ui.Gradient.radial(
          Offset(-r * 0.2, -r * 0.4),
          r * 1.5,
          [const Color(0xFFFFF9C4), const Color(0xFFFFCA28), const Color(0xFFF57F17)],
        );
      canvas.drawOval(seedRect, seedShader);
    }

    canvas.restore();
  }

  void _drawParticle(Canvas canvas, Particle3D part, ProjectedPoint proj) {
    final size = part.size * proj.scale * 4.0;
    final color = part.color.withValues(alpha: (part.life * part.color.a).clamp(0.0, 1.0));

    canvas.save();
    canvas.translate(proj.x, proj.y);
    canvas.rotate(part.rotation);

    if (part.type == ParticleType.feather) {
      final featherPaint = Paint()..color = color;
      final path = Path()
        ..moveTo(0, -size)
        ..quadraticBezierTo(size * 0.6, 0, 0, size)
        ..quadraticBezierTo(-size * 0.6, 0, 0, -size);
      canvas.drawPath(path, featherPaint);
    } else {
      final pPaint = Paint()..color = color;
      canvas.drawCircle(Offset.zero, size * 0.7, pPaint);
    }

    canvas.restore();
  }

  void _drawSparrowShadow(Canvas canvas, Size size, ProjectedPoint proj) {
    // Ground shadow follows sparrow with perspective scale
    final shadowY = size.height * 0.88;
    final shadowScale = (1.0 - ((proj.y - shadowY) / size.height).abs()).clamp(0.2, 1.0);
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25 * shadowScale)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final shadowWidth = 65.0 * sparrow.scale * shadowScale;
    final shadowHeight = 22.0 * sparrow.scale * shadowScale;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(proj.x, shadowY), width: shadowWidth, height: shadowHeight),
      shadowPaint,
    );
  }

  void _drawSparrow(Canvas canvas, ProjectedPoint proj) {
    final sprite = sparrow.isWounded
        ? sparrowWoundedImage
        : (sparrow.isFlapping ? sparrowFlyingImage : sparrowRestingImage);

    canvas.save();
    canvas.translate(proj.x, proj.y);

    // Natural 3D roll and pitch banking
    canvas.rotate(sparrow.roll);

    // Growth scale multiplier (grows larger with water & seeds)
    final renderScale = sparrow.scale;
    final birdWidth = 110.0 * renderScale;
    final birdHeight = 110.0 * renderScale;

    // Golden Growth Aura when recently fed
    if (sparrow.seedsEaten > 0 || sparrow.waterDrunk > 0) {
      final auraPaint = Paint()
        ..color = const Color(0xFFFFD54F).withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
      canvas.drawCircle(Offset.zero, birdWidth * 0.65, auraPaint);
    }

    if (sprite != null) {
      final src = Rect.fromLTWH(0, 0, sprite.width.toDouble(), sprite.height.toDouble());
      final dst = Rect.fromCenter(
        center: Offset.zero,
        width: birdWidth,
        height: birdHeight,
      );

      final p = Paint()..filterQuality = FilterQuality.medium;

      // If wounded, flash red pulsation
      if (sparrow.isWounded) {
        final flashAlpha = (math.sin(sparrow.woundDuration * 25.0) * 0.5 + 0.5);
        p.colorFilter = ColorFilter.mode(
          Colors.red.withValues(alpha: 0.6 * flashAlpha),
          BlendMode.srcATop,
        );
      }

      canvas.drawImageRect(sprite, src, dst, p);
    } else {
      // Fallback procedural sparrow
      final fallbackPaint = Paint()
        ..color = sparrow.isWounded ? Colors.red : const Color(0xFF8D5524);
      canvas.drawCircle(Offset.zero, birdWidth * 0.35, fallbackPaint);
    }

    canvas.restore();
  }

  void _drawAtmosphericVignette(Canvas canvas, Size size) {
    // Subtle vignette around borders to give depth focus
    final vignettePaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width / 2, size.height / 2),
        size.longestSide * 0.75,
        [Colors.transparent, Colors.black.withValues(alpha: 0.45)],
        [0.7, 1.0],
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), vignettePaint);
  }

  @override
  bool shouldRepaint(covariant World3DRenderer oldDelegate) => true;
}

class _RenderItem {
  final double depth;
  final VoidCallback draw;

  _RenderItem({required this.depth, required this.draw});
}
