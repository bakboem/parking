import 'package:equatable/equatable.dart';

abstract class PaginationState<T> extends Equatable {
  const PaginationState();
}

class PageInitState<T> extends PaginationState<T> {
  const PageInitState();

  @override
  List<Object?> get props => [];
}

class LoadingState<T> extends PaginationState<T> {
  final String message;

  const LoadingState({
    required this.message,
  });

  @override
  List<Object?> get props => [];
}

class CheckHasMorePageState<T> extends PaginationState<T> {
  const CheckHasMorePageState();

  @override
  List<Object?> get props => [];
}

class LastPageState<T> extends PaginationState<T> {
  const LastPageState();

  @override
  List<Object?> get props => [];
}

class SuccessState<T> extends PaginationState<T> {
  final T data;
  const SuccessState({
    required this.data,
  });

  @override
  List<Object?> get props => [];
}

class ErrorState<T> extends PaginationState<T> {
  final String error;

  const ErrorState({
    required this.error,
  });

  @override
  List<Object?> get props => [];
}
