part of 'encoder_bloc.dart';

abstract class EncoderState extends Equatable {
  const EncoderState();  

  @override
  List<Object> get props => [];
}
class EncoderInitial extends EncoderState {}
