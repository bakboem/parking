abstract class PaginationState {
  const PaginationState();
}

class PageInitState extends PaginationState {
  const PageInitState();
}

class PageLoadingState extends PaginationState {
  final String message;

  const PageLoadingState({
    required this.message,
  });
}

class SuccessState<T> extends PaginationState {
  final T data;

  const SuccessState({
    required this.data,
  });
}

class ErrorState extends PaginationState {
  final String error;

  const ErrorState({
    required this.error,
  });
}
