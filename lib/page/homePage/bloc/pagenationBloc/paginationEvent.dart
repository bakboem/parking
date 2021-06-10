abstract class PaginationEvent<T> {
  const PaginationEvent();
}

class ResetEvent<T> extends PaginationEvent<T> {
  const ResetEvent();
}

class RequestDataEvent<T> extends PaginationEvent<T> {
  String? search;
  RequestDataEvent({required this.search});
}
