import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intern/prathamCode/bloc/bloc_for_more_wigdet/more_event.dart';
import 'package:intern/prathamCode/bloc/bloc_for_more_wigdet/more_state.dart';

class MoreBloc extends Bloc<MoreEvent, MoreState> {
  MoreBloc() : super(BottomSheetIsHidden()) {
    on<ToggleMenuEvent>((event, emit) {
      if (state is BottomSheetIsHidden) {
        emit(BottomSheetIsExpanded());
      } else {
        emit(BottomSheetIsHidden());
      }
    });
  }
}
