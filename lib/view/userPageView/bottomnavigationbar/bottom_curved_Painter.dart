import 'package:flutter/material.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/view/userPageView/bottomnavigationbar/centered_elasticIn_curve.dart';

class BackgroundCurvePainter extends CustomPainter {
  static const _radiusTop = 100.0;
  static const _radiusBottom = 90.0;
  static const _horizontalControlTop = 0.6;
  static const _horizontalControlBottom = 0.5;
  static const _pointControlTop = 0.35;
  static const _pointControlBottom = 0.85;
  static const _topY = -80.0;
  static const _bottomY = -70.0;
  static const _topDistance = 100.0;
  static const _bottomDistance = 100.0;

  final double _x;
  final double _normalizedY;

  BackgroundCurvePainter(double x, double normalizedY, Color color)
      : _x = x,
        _normalizedY = normalizedY;

  @override
  void paint(canvas, size) {
    // Paint two cubic bezier curves using various linear interpolations based off of the `_normalizedY` value
    final norm = LinearPointCurve(0.5, 2.0).transform(_normalizedY) / 3;

    final radius =
        Tween<double>(begin: _radiusTop, end: _radiusBottom).transform(norm);
    // Point colinear to the top edge of the background pane
    final anchorControlOffset = Tween<double>(
            begin: radius * _horizontalControlTop,
            end: radius * _horizontalControlBottom)
        .transform(LinearPointCurve(0.5, 0.75).transform(norm));
    // Point that slides up and down depending on distance for the target x position
    final dipControlOffset = Tween<double>(
            begin: radius * _pointControlTop, end: radius * _pointControlBottom)
        .transform(LinearPointCurve(0.5, 0.8).transform(norm));
    final y = Tween<double>(begin: _topY, end: _bottomY)
        .transform(LinearPointCurve(0.2, 0.7).transform(norm));
    final dist = Tween<double>(begin: _topDistance, end: _bottomDistance)
        .transform(LinearPointCurve(0.5, 0.0).transform(norm));
    final x0 = _x - dist / 30;
    final x1 = _x + dist / 30;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(x0 - radius, 0)
      ..cubicTo(
          x0 - radius + anchorControlOffset, 0, x0 - dipControlOffset, y, x0, y)
      ..lineTo(x1, y)
      ..cubicTo(x1 + dipControlOffset, y, x1 + radius - anchorControlOffset, 0,
          x1 + radius, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(-100, size.height);

    final paint = Paint()..color = AppColors.thirdColor;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BackgroundCurvePainter oldPainter) {
    return _x != oldPainter._x || _normalizedY != oldPainter._normalizedY;
  }
}
