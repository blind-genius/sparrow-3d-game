import 'dart:math' as math;

class Vector3D {
  double x;
  double y;
  double z;

  Vector3D(this.x, this.y, this.z);

  factory Vector3D.zero() => Vector3D(0.0, 0.0, 0.0);
  factory Vector3D.copy(Vector3D other) => Vector3D(other.x, other.y, other.z);

  Vector3D operator +(Vector3D other) => Vector3D(x + other.x, y + other.y, z + other.z);
  Vector3D operator -(Vector3D other) => Vector3D(x - other.x, y - other.y, z - other.z);
  Vector3D operator *(double scalar) => Vector3D(x * scalar, y * scalar, z * scalar);
  Vector3D operator /(double scalar) => Vector3D(x / scalar, y / scalar, z / scalar);

  double distanceTo(Vector3D other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    return math.sqrt(dx * dx + dy * dy + dz * dz);
  }

  double distance2D(Vector3D other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  double length() => math.sqrt(x * x + y * y + z * z);

  Vector3D normalize() {
    final len = length();
    if (len == 0) return Vector3D.zero();
    return Vector3D(x / len, y / len, z / len);
  }

  static Vector3D lerp(Vector3D a, Vector3D b, double t) {
    return Vector3D(
      a.x + (b.x - a.x) * t,
      a.y + (b.y - a.y) * t,
      a.z + (b.z - a.z) * t,
    );
  }

  @override
  String toString() => 'Vector3D(${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)}, ${z.toStringAsFixed(2)})';
}
