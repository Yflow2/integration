import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intern/prathamCode/bloc/bloc_for_speech_to_text/stt_bloc.dart';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:speech_to_text/speech_to_text.dart';

class bottomsheetComponents extends StatefulWidget {
  const bottomsheetComponents({super.key});

  @override
  State<bottomsheetComponents> createState() => _bottomsheetComponentsState();
}

class _bottomsheetComponentsState extends State<bottomsheetComponents>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  String _text = "Press the button to toggle";
  bool isListening = false;


  @override
  void initState() {
    super.initState();


    _rotationController =
    AnimationController(vsync: this, duration: Duration(seconds: 5))
      ..repeat();

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
                        child: BlocBuilder<SttBloc,SttState>(
                          builder: (context, state) {

                          //Empty text to add if available
                          String text = "Press the button to toggle";

                          if(state is SpeechListening){
                            text = "Listening...";
                          }
                          else if(state is SpeechPartial){
                            text = state.partialText;
                          }
                          else if(state is SpeechError){
                            text = 'Error: ${state.message}';
                          }
                          else if(state is SpeechResult){
                            dev.log("EMIT: ${state.recognizedText}");
                            text = state.recognizedText;
                            dev.log("$state");
                          }

                          return Text(
                            //Enter the text if captured by user
                            text.isNotEmpty ? text : _text,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          );
                        },)
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
}
