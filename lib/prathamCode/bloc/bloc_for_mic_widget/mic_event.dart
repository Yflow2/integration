
part of 'mic_bloc.dart';

abstract class MicEvent {}

class ToggleMicEvent extends MicEvent {}
class StartMicEvent extends MicEvent {}
class StopMicEvent extends MicEvent {}