import 'package:equatable/equatable.dart';

abstract class PaginationEvent<T> extends Equatable {
  const PaginationEvent();
}

class ResetEvent<T> extends PaginationEvent<T> {
  const ResetEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class AddPageEvent<T> extends PaginationEvent<T> {
  const AddPageEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class RequestDataEvent<T> extends PaginationEvent<T> {
  final String? search;
  RequestDataEvent({required this.search});

  @override
  List<Object?> get props => throw UnimplementedError();
}
