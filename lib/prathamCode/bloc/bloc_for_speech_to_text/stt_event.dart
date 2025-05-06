

part of 'stt_bloc.dart';


abstract class SttEvent {}

class StartListening extends SttEvent{}

class StopListening extends SttEvent{}