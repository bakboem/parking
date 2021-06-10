abstract class PaginationEvent<T> {
  const PaginationEvent();
}

class ResetPageEvent<T> extends PaginationEvent<T> {
  const ResetPageEvent();
}

class RequestDataEvent<T> extends PaginationEvent<T> {
  String? search;
  RequestDataEvent({required this.search});
}
