import 'dart:math';
import 'package:flutter/material.dart';

class RadialMenu extends StatefulWidget {
  final bool isExpanded;

  const RadialMenu({super.key, this.isExpanded = false });

  @override
  State<RadialMenu> createState() => RadialMenuState();
}

class RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);

    isExpanded = widget.isExpanded;
  }

  void toggleMenu() {
    if (isExpanded) {
      controller.reverse();
    } else {
      controller.forward();
    }
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double size = screenSize.shortestSide * 0.7; // 70% of the shortest screen dimension

    return Container(
      alignment: Alignment.center, // Center the content within the Container
      color: Colors.red,
      height: size,
      width: size,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Center( // Wrap the Stack with a Center widget
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.sizeOf(context).height * 0.35,
                  left: MediaQuery.sizeOf(context).width  * 0.15,
                  bottom: 0,
                  child: CustomPaint(
                    size: Size(size, size),
                    painter: RadialMenuOptions(animation.value),
                  ),
                ),
                ..._buildSpeedometerIcons(animation.value, size),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildSpeedometerIcons(double progress, double size) {
    final double radius = size * 0.4; // 40% of the size
    final Offset center = Offset(size * 0.7, size * 1.0);

    final List<Map<String, dynamic>> iconData = [
      {'icon': Icons.settings, 'finalAngle': -pi * 0.95},
      {'icon': Icons.language, 'finalAngle': -pi / 2},
      {'icon': Icons.music_note, 'finalAngle': -pi * 0.05},
    ];

    return iconData.map((data) {
      final double angle = -pi + (data['finalAngle'] + pi) * progress;
      final double dx = center.dx + radius * cos(angle);
      final double dy = center.dy + radius * sin(angle);

      return Positioned(
        left: dx - 20,
        top: dy - 20,
        child: Opacity(
          opacity: progress.clamp(0.7, 1),
          child: Transform.scale(
            scale: progress,
            child: Icon(
              data['icon'],
              size: size * 0.13, // 13% of the size
              color: Colors.lightBlueAccent,
            ),
          ),
        ),
      );
    }).toList();
  }
}

class RadialMenuOptions extends CustomPainter {
  final double progress;

  RadialMenuOptions(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A3C)
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);
    final double startAngle = -pi;
    final double sweepAngle = pi * progress;

    canvas.drawArc(arcRect, startAngle, sweepAngle, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}