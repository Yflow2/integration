

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

    on<ToggleListening>((event, emit) {
      if(state is SpeechListening){
        _onStartListening(emit);
      } else {
        _onStopListening(emit);
      }
    },);

    on<StartListening>((event, emit) {
      _onStartListening(emit);
    },);

    on<StopListening>((event, emit) {
      _onStopListening(emit);
    },);

  }

  Future<void> _onStartListening(Emitter<SttState> emit ) async {
    bool available = await speechToText.initialize(
      onStatus: (status) {
        return dev.log("Status $status");
      },
      onError: (errorNotification) {
        return dev.log("Status $errorNotification");
      },
    );

    if(available) {
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

  void _onStopListening(Emitter<SttState> emit){
    speechToText.stop();
    emit(SpeechNotListening());
  }

  @override
  Future<void> close() {
    speechToText.stop();
    return super.close();
  }
}