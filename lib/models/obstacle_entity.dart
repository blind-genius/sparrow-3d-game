import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../engine_3d/vector3d.dart';

enum ObstacleType {
  treeTrunk,    // Tall vertical tree trunk
  horizontalLog,// Thick horizontal branch/log
  rockPillar,   // Mossy jagged rock spire
  thornyBush,   // Sharp prickly briar patch
  predatorBird, // Distant hawk/falcon flying across
}

class ObstacleEntity {
  Vector3D position;
  ObstacleType type;
  double width;
  double height;
  double depth;
  Color baseColor;
  bool passed;
  
  // Dynamic movement
  double oscillationSpeed;
  double oscillationAmplitude;
  double initialX;
  double timeAlive;

  ObstacleEntity({
    required this.position,
    required this.type,
    required this.width,
    required this.height,
    this.depth = 1.8,
    required this.baseColor,
    this.oscillationSpeed = 0.0,
    this.oscillationAmplitude = 0.0,
  })  : passed = false,
        initialX = position.x,
        timeAlive = 0.0;

  void update(double dt, double flightSpeed) {
    position.z -= flightSpeed * dt;
    timeAlive += dt;

    if (oscillationSpeed > 0 && oscillationAmplitude > 0) {
      position.x = initialX + math.sin(timeAlive * oscillationSpeed) * oscillationAmplitude;
    }
  }

  // 3D Oriented Bounding Box / Cylinder collision check with sparrow
  bool checkCollision(Vector3D sparrowPos, double sparrowRadius) {
    // Check Z depth overlap
    if ((position.z - sparrowPos.z).abs() > (depth / 2.0 + sparrowRadius * 0.8)) {
      return false;
    }

    // Check X and Y bounds
    final halfW = width / 2.0;
    final halfH = height / 2.0;

    final dx = (sparrowPos.x - position.x).abs();
    final dy = (sparrowPos.y - position.y).abs();

    if (dx <= (halfW + sparrowRadius) && dy <= (halfH + sparrowRadius)) {
      return true;
    }

    return false;
  }
}
