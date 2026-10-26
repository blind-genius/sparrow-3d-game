import 'dart:ui';
import 'vector3d.dart';

class ProjectedPoint {
  final double x;
  final double y;
  final double scale;
  final double depth; // Distance from camera
  final bool isVisible;

  ProjectedPoint({
    required this.x,
    required this.y,
    required this.scale,
    required this.depth,
    required this.isVisible,
  });
}

class Camera3D {
  Vector3D position;
  double focalLength;
  double nearClip;
  double farClip;

  Camera3D({
    Vector3D? position,
    this.focalLength = 360.0,
    this.nearClip = 2.0,
    this.farClip = 300.0,
  }) : position = position ?? Vector3D(0.0, 1.8, -14.0);

  ProjectedPoint project(Vector3D worldPos, Size viewportSize) {
    // Relative position to camera
    final relX = worldPos.x - position.x;
    final relY = worldPos.y - position.y;
    final relZ = worldPos.z - position.z;

    if (relZ <= nearClip || relZ >= farClip) {
      return ProjectedPoint(
        x: 0,
        y: 0,
        scale: 0,
        depth: relZ,
        isVisible: false,
      );
    }

    final perspective = focalLength / relZ;
    final centerX = viewportSize.width / 2.0;
    final centerY = viewportSize.height / 2.0;

    // Invert Y so positive Y goes upwards in 3D world
    final screenX = centerX + (relX * perspective);
    final screenY = centerY - (relY * perspective);

    return ProjectedPoint(
      x: screenX,
      y: screenY,
      scale: perspective / 20.0, // normalized scale multiplier
      depth: relZ,
      isVisible: true,
    );
  }
}
