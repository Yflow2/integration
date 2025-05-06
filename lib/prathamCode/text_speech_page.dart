import 'dart:math';

import 'package:flutter/material.dart';
import 'custom_mic_widget.dart';
import 'bottm_sheet_widget.dart';

class FullScreenBottomSheet extends StatefulWidget {
  @override
  State<FullScreenBottomSheet> createState() => _FullScreenBottomSheetState();
}

class _FullScreenBottomSheetState extends State<FullScreenBottomSheet> with TickerProviderStateMixin{

  late AnimationController _rotationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rotationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 5))..repeat();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: _GradientBorderPainter(angle: _rotationController.value * 2 * pi),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(28),topRight: Radius.circular(28)),
              color: Colors.white,
            ),
            width: MediaQuery.sizeOf(context).width ,
            height: MediaQuery.sizeOf(context).height * 0.95, // Adjust as needed
            padding: EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.01),
            child: LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints) {
                return Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.6,
                      child: bottomsheetComponents(),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                              child: Icon(Icons.done,
                                  color: Colors.white, size: 30),
                              backgroundColor: Colors.green),
                          Hero(
                            tag: "pratham",
                            child: CustomMicWidget(
                              isListening: true,
                              height: 400,
                              width: 300,
                            ),
                          ),
                          CircleAvatar(
                            child: Icon(Icons.close,
                                color: Colors.white, size: 30),
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.1,
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double angle;

  _GradientBorderPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final borderRadius = BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)).toRRect(rect);

    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * pi,
      colors: const [
        Colors.purple,
        Colors.blue,
        Colors.cyan,
        Colors.purple,
      ],
      stops: const [0.0, 0.5, 0.9, 1.0],
      transform: GradientRotation(angle),
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawRRect(borderRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) =>
      oldDelegate.angle != angle;
}

