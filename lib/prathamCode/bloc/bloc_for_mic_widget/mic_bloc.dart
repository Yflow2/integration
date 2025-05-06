

import 'package:flutter_bloc/flutter_bloc.dart';

part 'mic_event.dart';

part 'mic_state.dart';

class MicBloc extends Bloc<MicEvent, MicState> {
  MicBloc() : super(InitialMicState()) {
    on<ToggleMicEvent>((event, emit) {
      if (state is MicListeningState) {
        emit(MicNotListeningState());
      } else {
        emit(MicListeningState());
      }
    });

    on<StartMicEvent>((event, emit) {
      emit(MicListeningState());
    },);

    on<StopMicEvent>((event, emit) {
      emit(MicNotListeningState());
    },);
  }
}
