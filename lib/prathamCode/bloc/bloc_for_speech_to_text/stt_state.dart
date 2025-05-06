part of 'stt_bloc.dart';

abstract class SttState {}

class SpeechInitial extends SttState {}

class SpeechReady extends SttState {}

class SpeechListening extends SttState {}

class SpeechNotListening extends SttState {}

class SpeechPartial extends SttState {
  final String partialText;
  SpeechPartial(this.partialText);
}

class SpeechResult extends SttState {
  final String recognizedText;
  SpeechResult({required this.recognizedText});
}

class SpeechError extends SttState {
  final String message;
  SpeechError(this.message);
}