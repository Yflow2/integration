import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intern/prathamCode/bloc/bloc_for_more_wigdet/more_bloc.dart';
import 'package:intern/prathamCode/bottomApp.dart';

void main() {
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
        },)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BottomMenu(),
      ),
    );
  }
}
