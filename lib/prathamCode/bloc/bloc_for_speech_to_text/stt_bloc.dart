import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'stt_event.dart';
part 'stt_state.dart';

class SttBloc extends Bloc<SttEvent, SttState> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  SttBloc() : super(SpeechInitial()) {
    on<InitStt>(_onInitStt);
    on<ToggleListening>(_onToggleListening);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
  }

  Future<void> _onInitStt(InitStt event, Emitter<SttState> emit) async {
    try {
      _isInitialized = await _speechToText.initialize(
        onStatus: (status) => dev.log("Status: $status"),
        onError: (error) => dev.log("Error: $error"),
      );
      if (!_isInitialized) {
        emit(SpeechError("Speech recognition not available"));
      } else {
        emit(SpeechReady());
      }
    } catch (e) {
      emit(SpeechError("Initialization failed: $e"));
    }
  }

  void _onToggleListening(ToggleListening event, Emitter<SttState> emit) {
    if (state is SpeechListening) {
      add(StopListening());
    } else {
      add(StartListening());
    }
  }

  Future<void> _onStartListening(StartListening event, Emitter<SttState> emit) async {
    if (!_isInitialized) {
      emit(SpeechError("Speech not initialized"));
      dev.log("Speech engine not available");
      return;
    }
    var speechOptions = SpeechListenOptions(
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: true,
        enableHapticFeedback: true);
    emit(SpeechListening());

    await _speechToText.listen(
      onResult: (result) {
        dev.log("$result");
        dev.log("Recognized :: ${result.recognizedWords}");
        if(result.confidence <= 0.0){
          emit(SpeechResult(recognizedText: result.recognizedWords));
        }

        /*if(result.hasConfidenceRating){
          emit(SpeechResult(result.recognizedWords));
        }

        if (result.finalResult) {
          add(StopListening());
          emit(SpeechResult(result.recognizedWords));
        } else {
          emit(SpeechPartial(result.recognizedWords));
        }*/
      },
      listenOptions: speechOptions,
    );


  }

  void _onStopListening(StopListening event, Emitter<SttState> emit) {
    if (_speechToText.isListening) {
      _speechToText.stop();
    }
    emit(SpeechNotListening());
  }

  @override
  Future<void> close() {
    _speechToText.stop();
    return super.close();
  }
}
