import 'package:flutter/material.dart';

class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final List<Color> gradientColors;

  const GradientBorderContainer({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.borderWidth = 2.0,
    this.gradientColors = const [
      Colors.purple,
      Colors.blue,
      Colors.cyan,
      Colors.purple,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BorderGradientWidget(
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        gradientColors: gradientColors,
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: child,
      ),
    );
  }
}

class BorderGradientWidget extends CustomPainter {
  final double borderRadius;
  final double borderWidth;
  final List<Color> gradientColors;

  BorderGradientWidget({
    required this.borderRadius,
    required this.borderWidth,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final gradient = LinearGradient(
      colors: gradientColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    paint.shader = gradient.createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ShapeBorderClipper extends CustomClipper<Path> {
  final ShapeBorder shape;

  ShapeBorderClipper({required this.shape});

  @override
  Path getClip(Size size) {
    return shape.getOuterPath(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
