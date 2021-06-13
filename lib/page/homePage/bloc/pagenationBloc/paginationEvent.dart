abstract class PaginationEvent<T> {
  const PaginationEvent();
}

class ResetEvent<T> extends PaginationEvent<T> {
  const ResetEvent();
}

class AddPageEvent<T> extends PaginationEvent<T> {
  const AddPageEvent();
}

class RequestDataEvent<T> extends PaginationEvent<T> {
  String? search;
  RequestDataEvent({required this.search});
}
