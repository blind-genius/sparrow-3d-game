import 'dart:math' as math;
import '../engine_3d/vector3d.dart';

enum CollectibleType {
  water, // Blue refreshing water droplet
  seed,  // Golden nutrient grain / seed
}

class CollectibleEntity {
  Vector3D position;
  CollectibleType type;
  double radius;
  double hoverOffset;
  double rotation;
  bool isCollected;

  CollectibleEntity({
    required this.position,
    required this.type,
    this.radius = 1.0,
  })  : hoverOffset = 0.0,
        rotation = 0.0,
        isCollected = false;

  void update(double dt, double flightSpeed) {
    position.z -= flightSpeed * dt;
    rotation += dt * 3.0;
    hoverOffset = math.sin(rotation) * 0.3;
  }

  bool checkCollision(Vector3D sparrowPos, double sparrowRadius) {
    if (isCollected) return false;

    // Check distance in 3D
    final currentPos = Vector3D(position.x, position.y + hoverOffset, position.z);
    final dist = currentPos.distanceTo(sparrowPos);
    return dist <= (radius + sparrowRadius);
  }
}
