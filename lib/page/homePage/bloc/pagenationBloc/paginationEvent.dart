abstract class PaginationEvent<T> {
  const PaginationEvent();
}

class FetchEvent<T> extends PaginationEvent<T> {
  const FetchEvent();
}
