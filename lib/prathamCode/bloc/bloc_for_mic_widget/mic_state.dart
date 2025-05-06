

part of 'mic_bloc.dart';


abstract class MicState {}

final class InitialMicState extends MicState {}

final class MicListeningState extends MicState {}

final class MicNotListeningState extends MicState {}