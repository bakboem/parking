import 'package:equatable/equatable.dart';

abstract class GeoCodingState extends Equatable {
  const GeoCodingState();
}

class SuccessState extends GeoCodingState {
  const SuccessState({required this.addr});
  final String addr;
  get address => addr;

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ErrorState extends GeoCodingState {
  const ErrorState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitState extends GeoCodingState {
  const InitState();

  @override
  List<Object?> get props => throw UnimplementedError();
}