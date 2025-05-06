

import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
part 'stt_event.dart';
part 'stt_state.dart';


class SttBloc extends Bloc<SttEvent,SttState>{

  final SpeechToText speechToText;

  SttBloc()
      : speechToText = SpeechToText(),
        super(SpeechInitial()){
    on<StartListening>((event, emit) {
      _onStartListening;
    },);

    on<StopListening>((event, emit) {
      _onStopListening;
    },);
  }

  Future<void> _onStartListening(StartListening event,Emitter<SttState> emit ) async {
    bool available = await speechToText.initialize(
      onStatus: (status) {
        return dev.log("Status $status");
      },
      onError: (errorNotification) {
        return dev.log("Status $errorNotification");
      },
    );

    if(available){
      emit(SpeechListening());
      speechToText.listen(
        onResult: (result) {
          emit(SpeechResult(result.recognizedWords));
        },
      );
    } else{
      emit(SpeechError("Speech Recognition not available"));
    }
  }

  void _onStopListening(StopListening event,Emitter<SttState> emit){
    speechToText.stop();
    emit(SpeechNotListening());
  }

  @override
  Future<void> close() {
    speechToText.stop();
    return super.close();
  }
}