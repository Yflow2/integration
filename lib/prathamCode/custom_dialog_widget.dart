import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'border_gradient_widget.dart';



class AnimatedDialog extends StatefulWidget {
  final AnimationController controller;
  final List<IconData> icons;
  final List<String> labels;
  final List<VoidCallback> onTaps; // Add this line

  const AnimatedDialog({super.key,
    required this.controller,
    required this.icons,
    required this.labels,
    required this.onTaps, // Add this line
  });

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog> {



  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        // print("Progress: ${widget.controller.value}");
        return ClipOval(
          clipper:
          ProgressCircleClipper(currentProgress: widget.controller.value),
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFF1A1A3C),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  runSpacing: 10.0, // Adjust spacing between rows
                  spacing: 10.0, // Adjust spacing between items
                  children: List.generate(widget.icons.length, (index) {
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width) / 4, // Adjust width to fit 4 items per row
                      height: (MediaQuery.of(context).size.width ) / 4, // Adjust height to maintain aspect ratio and add space for text
                      child: Column(
                        children: [
                          GradientBorderContainer(
                            borderRadius: 20,
                            gradientColors: [Colors.blue, Colors.purple], // Set your desired gradient colors
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: IconButton(
                                onPressed: () {
                                  widget.onTaps[index]();
                                  widget.controller.reverse();
                                }, // Use the onTap callback here
                                icon: Icon(
                                  widget.icons[index],
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10), // Add some space between the icon and the text
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
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProgressCircleClipper extends CustomClipper<Rect> {
  final double currentProgress;

  ProgressCircleClipper({required this.currentProgress});

  @override
  Rect getClip(Size size) {
    //  getting point of origin for our angle
    final pointStart = Offset(size.width, size.height);
    // calculate our angle
    double theta = math.atan(pointStart.dy / pointStart.dx);
    //  radius
    final topmostEnd = pointStart.dy / math.sin(theta);
    //calculating radius with animation progress
    final radius = topmostEnd * (currentProgress.clamp(0.0,1.0+0.05));
    final diameter = 2 * radius;
    return Rect.fromLTWH(
        pointStart.dx - radius, pointStart.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
