import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class CustomMicWidget extends StatefulWidget {
  final double width;
  final double height;
  final double ringRadius;
  final double micButtonSize;
  final double glowSize;
  final double iconSize;
  final int bars;
  final double minBarLength;
  final double maxBarLength;
  final double blurRadius;
  final double spreadRadius;
  final bool disabled;
  final GestureTapCallback? onButtonPressed;
  final bool isListening;

  const CustomMicWidget({
    super.key,
    this.width = 200,
    this.height = 300,
    this.ringRadius = 0.23,
    this.micButtonSize = 0.2,
    this.glowSize = 0.28,
    this.iconSize =  0.4,
    this.bars = 50,
    this.blurRadius = 15,
    this.spreadRadius = 15,
    this.minBarLength = 10,
    this.maxBarLength = 40,
    this.disabled = false,
    this.onButtonPressed,
    this.isListening = false
  });

  @override
  State<CustomMicWidget> createState() => _CustomMicWidgetState();
}

class _CustomMicWidgetState extends State<CustomMicWidget>
    with TickerProviderStateMixin {
  late final int bars;
  late final double minBarLength;
  late final double maxBarLength;
  final Random random = Random();
  late double _blurRadius;
  late double _spreadRadius;

  late List<AnimationController> controllers;
  late List<Animation<double>> animations;

  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late bool isListening;

  @override
  void initState() {
    super.initState();
    isListening = widget.isListening;
    bars = widget.bars;
    minBarLength = widget.minBarLength;
    maxBarLength = widget.maxBarLength;
    _blurRadius = widget.blurRadius;
    _spreadRadius = widget.spreadRadius;

    controllers = List.generate(
      bars,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000 + random.nextInt(1000)),
      ),
    );

    animations = List.generate(bars, (index) {
      final randomLength =
          minBarLength + random.nextDouble() * (maxBarLength - minBarLength);
      final controller = controllers[index];

      final animation = Tween<double>(
        begin: minBarLength,
        end: randomLength,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));

      controller.repeat(reverse: true);
      return animation;
    });

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenSize = MediaQuery.of(context).size;
    final double lowerBoundPercentage =
        0.235; // 0.95 as a percentage of screen width
    final double upperBoundPercentage =
        0.3; // 1.2 as a percentage of screen width
    final double lowerBound = screenSize.width>400?screenSize.width * lowerBoundPercentage/190:screenSize.width * lowerBoundPercentage / 100;
    final double upperBound = screenSize.width>400?screenSize.width * lowerBoundPercentage/160:screenSize.width * upperBoundPercentage / 100;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: lowerBound,
      upperBound: upperBound,
    );
    if(isListening) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      isListening = !isListening;
      if (isListening) {
        _spreadRadius = 15;
        _blurRadius = 15;
        _pulseController.repeat(reverse: true);
        for (var controller in controllers) {
          controller.repeat(reverse: true);
        }
      } else {
        _spreadRadius = 0;
        _blurRadius = 0;
        _pulseController.stop();
        _rotationController.stop();
        _pulseController.value = 0; // Reset scale
        for (var controller in controllers) {
          controller.stop();
        }
      }
    });
  }

  late var screenSize;
  late double ringRadius; // Responsive ringRadius
  late double micButtonSize; // Responsive micButtonSize
  late double glowSize; // Responsive glowSize
  late double iconSize;

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.sizeOf(context).width ;

    screenSize = Size(widget.width, widget.height);

    double ringRadius = width > 400?screenSize.width * 0.19:screenSize.width * 0.23; // Responsive ringRadius
    double micButtonSize = width>400 ? screenSize.width * 0.15:  screenSize.width * 0.2; // Responsive micButtonSize
    double glowSize = screenSize.width > 400? screenSize.width * 0.05:screenSize.width * 0.28; // Responsive glowSize
    double iconSize =  micButtonSize * 0.4; // Responsive iconSize



    return Stack(
      alignment: Alignment.center,
      children: [
        if (isListening)
          Positioned.fill(
            child: CustomPaint(
              painter: CircleVisualizerPainter(animations, ringRadius),
              child: SizedBox(
                  width: screenSize.width,
                  height: screenSize.width), // Responsive size
            ),
          ),
        GestureDetector(
          onTap: widget.disabled ? widget.onButtonPressed : _toggleListening,
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (_, __) {
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  ScaleTransition(
                    scale: _pulseController,
                    child: Transform.rotate(
                      angle: _rotationController.value * 2 * pi,
                      child: Container(
                        width: glowSize,
                        height: glowSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              Colors.purple.withValues(alpha: 0.4),
                              Colors.blue.withValues(alpha: 0.4),
                              Colors.red.withValues(alpha: 0.4),
                              Colors.purple.withValues(alpha: 0.4),
                            ],
                            stops: const [0.0, 0.5, 0.9, 1.0],
                            transform: GradientRotation(pi / 4),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withValues(alpha: 1),
                              blurRadius: _blurRadius,
                              spreadRadius: _spreadRadius,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Mic Button
                  Container(
                    width: micButtonSize,
                    height: micButtonSize,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A1A3C),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child:
                          Icon(Icons.mic, color: Colors.white, size: iconSize),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class CircleVisualizerPainter extends CustomPainter {
  final List<Animation<double>> animations;
  final double ringRadius;

  CircleVisualizerPainter(this.animations, this.ringRadius);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..color = Colors.deepPurpleAccent
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final int bars = animations.length;
    for (int i = 0; i < bars; i++) {
      final angle = (2 * pi / bars) * i;
      final barLength = animations[i].value / 2;

      final start = Offset(
        center.dx + cos(angle) * ringRadius,
        center.dy + sin(angle) * ringRadius,
      );
      final end = Offset(
        center.dx + cos(angle) * (ringRadius + barLength),
        center.dy + sin(angle) * (ringRadius + barLength),
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
