abstract class PaginationEvent<T> {
  const PaginationEvent();
}

class FetchEvent<T> extends PaginationEvent<T> {
  String? search;
  FetchEvent({required this.search});
}

class InitEvent<T> extends PaginationEvent<T> {
  const InitEvent();
}
