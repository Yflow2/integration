import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intern/prathamCode/bloc/bloc_for_mic_widget/mic_bloc.dart';
import 'package:intern/prathamCode/bloc/bloc_for_more_wigdet/more_bloc.dart';
import 'package:intern/prathamCode/bloc/bloc_for_speech_to_text/stt_bloc.dart';
import 'package:intern/prathamCode/bottomApp.dart';
import 'package:localblocobserver/localblocobserver.dart';

void main() {

  Bloc.observer = CustomizableBlocObserver(
    isDebugEnabled: true,
    debugShowEvent: true,
    debugShowState: true,
    debugShowTransition: true,
  );

  runApp(FinalAnimation());
}

class FinalAnimation extends StatelessWidget {
  const FinalAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          return MoreBloc();
        },),
        BlocProvider(create: (context) {
          return MicBloc();
        },),
        BlocProvider(create: (context) {
          return SttBloc()..add(InitStt());
        },)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BottomMenu(),
      ),
    );
  }
}
