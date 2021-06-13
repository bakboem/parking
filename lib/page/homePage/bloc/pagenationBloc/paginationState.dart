import 'package:equatable/equatable.dart';

abstract class PaginationState<T> extends Equatable {
  const PaginationState();
}

class PageInitState<T> extends PaginationState<T> {
  const PageInitState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoadingState<T> extends PaginationState<T> {
  final String message;

  const LoadingState({
    required this.message,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}

class SuccessState<T> extends PaginationState<T> {
  final T data;
  const SuccessState({
    required this.data,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ErrorState<T> extends PaginationState<T> {
  final String error;

  const ErrorState({
    required this.error,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}
