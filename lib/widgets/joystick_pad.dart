import 'package:flutter/material.dart';

class JoystickPad extends StatefulWidget {
  final void Function(double vx, double vy) onDirectionChanged;

  const JoystickPad({super.key, required this.onDirectionChanged});

  @override
  State<JoystickPad> createState() => _JoystickPadState();
}

class _JoystickPadState extends State<JoystickPad> {
  Offset _dragOffset = Offset.zero;
  final double _radius = 55.0;

  void _updateOffset(Offset localPos) {
    final center = Offset(_radius, _radius);
    final delta = localPos - center;
    final dist = delta.distance;

    if (dist <= _radius) {
      _dragOffset = delta;
    } else {
      _dragOffset = Offset(
        (delta.dx / dist) * _radius,
        (delta.dy / dist) * _radius,
      );
    }

    final vx = (_dragOffset.dx / _radius).clamp(-1.0, 1.0);
    // Invert dy: dragging UP produces positive Y in 3D world (flying up)
    final vy = (-_dragOffset.dy / _radius).clamp(-1.0, 1.0);
    widget.onDirectionChanged(vx, vy);
    setState(() {});
  }

  void _reset() {
    _dragOffset = Offset.zero;
    widget.onDirectionChanged(0.0, 0.0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => _updateOffset(details.localPosition),
      onPanUpdate: (details) => _updateOffset(details.localPosition),
      onPanEnd: (_) => _reset(),
      onPanCancel: () => _reset(),
      child: Container(
        width: _radius * 2,
        height: _radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.35),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Transform.translate(
            offset: _dragOffset,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFFFFB74D), Color(0xFFE65100)],
                ),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(Icons.navigation, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}
