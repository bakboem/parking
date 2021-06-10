abstract class PaginationState<T> {
  const PaginationState();
}

class PageInitState<T> extends PaginationState<T> {
  const PageInitState();
}

class LoadingState<T> extends PaginationState<T> {
  final String message;

  const LoadingState({
    required this.message,
  });
}

class SuccessState<T> extends PaginationState<T> {
  final T data;
  SuccessState({
    required this.data,
  });
}

class ErrorState<T> extends PaginationState<T> {
  final String error;

  const ErrorState({
    required this.error,
  });
}
