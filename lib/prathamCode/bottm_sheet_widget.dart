import 'package:flutter/material.dart';
import 'dart:math';

import 'package:speech_to_text/speech_to_text.dart';

class bottomsheetComponents extends StatefulWidget {
  const bottomsheetComponents({super.key});

  @override
  State<bottomsheetComponents> createState() => _bottomsheetComponentsState();
}

class _bottomsheetComponentsState extends State<bottomsheetComponents>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  late SpeechToText _speechToText;
  String _text = "Press the button to toggle";
  double _confidence = 1.0;
  bool isListening = false;


  @override
  void initState() {
    super.initState();

    _speechToText = SpeechToText();
    _initializeSpeechToText();

    _rotationController =
    AnimationController(vsync: this, duration: Duration(seconds: 5))
      ..repeat();
  }

  void _toggleListening() {
    setState(() {
      isListening = !isListening;
      if (isListening) {
        _startListening();
        // _pulseController.repeat(reverse: true);
      } else {
        _stopListening();
/*        _pulseController.stop();
        _pulseController.value = 1.0;*/ // Reset scale
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        return AnimatedBuilder(
          animation: _rotationController,
          builder: (_, __) {
            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                //It will have the speech to text content
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.cancel_outlined, color: Colors.black,
                            size: 25,)),
                    ),
                    SizedBox(height: 30,),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text(
                          _text,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
            );
          },
        );
      },
    );
  }

  void _startListening() async {
    bool available = await _speechToText.initialize(
/*      onStatus: (val) => dev.log("onStatus: $val"),
      onError: (val) => dev.log("onError: $val"),*/
    );
    if (available) {
      setState(() {
        isListening = true;
      });
      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
            if (result.hasConfidenceRating && result.confidence > 0) {
              _confidence = result.confidence;
              _stopListening();
            }
          });
        },
      );
    } else {
      // dev.log("SpeechToText initialization failed.");
    }
  }

  void _stopListening() {
    isListening = false;
    _speechToText.stop();
/*    _pulseController.stop();
    _pulseController.value = 1.0;*/
    setState(() {});
  }

  Future<void> _initializeSpeechToText() async {
    bool available = await _speechToText.initialize(
/*      onStatus: (val) => dev.log("onStatus: $val"),
      onError: (val) => dev.log("onError: $val"),*/
    );
    if (!available) {
      // dev.log("SpeechToText initialization failed.");
    }
  }
}
