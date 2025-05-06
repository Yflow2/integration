

part of 'stt_bloc.dart';


abstract class SttEvent {}

class InitStt extends SttEvent{}

class StartListening extends SttEvent{}

class ToggleListening extends SttEvent{}

class StopListening extends SttEvent{}