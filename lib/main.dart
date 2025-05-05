import 'package:flutter/material.dart';
import 'package:intern/prathamCode/bottomApp.dart';

void main() {
  runApp(FinalAnimation());
}

class FinalAnimation extends StatelessWidget {
  const FinalAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomMenu(),
    );
  }
}
