import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:developer' as dev ;

class RadialMenu extends StatefulWidget {
  final AnimationController controller;
  final List<IconData> icons;
  final List<String> labels;
  final List<VoidCallback> onTaps;

  const RadialMenu({
    super.key,
    required this.controller,
    required this.icons,
    required this.labels,
    required this.onTaps,
  });

  @override
  _RadialMenuState createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu> {
  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.width * 0.21;

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return ClipPath(
          clipper: RadialMenuClipper(progress: widget.controller.value),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFF1A1A3C),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: List.generate(widget.icons.length, (index) {
                // Angles: 0°, -90°, -180° → 0, -π/2, -π
                double angle = -index * (math.pi / (widget.icons.length - 1));
                double animatedRadius = radius * widget.controller.value;

                Offset offset = Offset(
                  animatedRadius * math.cos(angle),
                  -animatedRadius * math.sin(angle),
                );
                dev.log("Check: ${MediaQuery.of(context).size.width.toString()}");
                return Positioned(
                  left: (MediaQuery.of(context).size.width / 2) + offset.dx - 30,
                  bottom: offset.dy ,
                  child: Opacity(
                    opacity: widget.controller.value,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: IconButton(
                            onPressed: widget.onTaps[index],
                            icon: Icon(
                              widget.icons[index],
                              size: radius/2.5,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ),
                        Text(
                          widget.labels[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}


class RadialMenuClipper extends CustomClipper<Path> {
  final double progress;


  RadialMenuClipper({required this.progress});


  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width * 0.4;


    final startAngle = math.pi; // Start from left (180°)
    final sweepAngle = math.pi * progress; // Sweep from 0° to 180°


    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);


    final Path path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(arcRect, startAngle, sweepAngle, false)
      ..close();


    return path;
  }


  @override
  bool shouldReclip(covariant RadialMenuClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

