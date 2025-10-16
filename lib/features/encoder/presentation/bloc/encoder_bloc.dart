import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'encoder_event.dart';
part 'encoder_state.dart';

class EncoderBloc extends Bloc<EncoderEvent, EncoderState> {
  EncoderBloc() : super(EncoderInitial()) {
    on<EncoderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
