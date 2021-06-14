import 'package:equatable/equatable.dart';

abstract class GeoCodingState extends Equatable {
  const GeoCodingState();
}

class CodingSuccessState extends GeoCodingState {
  const CodingSuccessState({required this.addr});
  final String addr;
  get address => addr;

  @override
  List<Object?> get props => [];
}

class ErrorState extends GeoCodingState {
  const ErrorState();

  @override
  List<Object?> get props => [];
}

class InitState extends GeoCodingState {
  const InitState();

  @override
  List<Object?> get props => [];
}
