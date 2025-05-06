


part of 'stt_bloc.dart';

abstract class SttState {}

class SpeechInitial extends SttState{}

class SpeechListening extends SttState{}

class SpeechNotListening extends SttState{}

class SpeechResult extends SttState{
  final String text;

  SpeechResult(this.text);
}

class SpeechError extends SttState{
  final String text;

  SpeechError(this.text);
}