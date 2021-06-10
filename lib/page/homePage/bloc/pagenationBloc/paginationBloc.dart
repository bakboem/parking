import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/api/baseApi.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationEvent.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationState.dart';

class PaginationBloc<T> extends Bloc<PaginationEvent<T>, PaginationState<T>> {
  BaseApi? baseApi;
  int page = 1;
  bool isFetching = false;

  PaginationBloc({required this.baseApi}) : super(PageInitState<T>());

  @override
  Stream<PaginationState<T>> mapEventToState(PaginationEvent<T> event) async* {
    if (event is FetchEvent<T>) {
      yield PageLoadingState<T>(message: 'Loading ...');
      await baseApi!.initPage();
      final response = await baseApi!.getData(event.search!);
      if (response != null) {
        yield SuccessState<T>(
          data: response as T,
        );
      } else {
        yield ErrorState(error: 'data is null');
      }
    }
    if (event is InitEvent<T>) {
      baseApi!.resetPage();
      yield PageInitState<T>();
    }
  }
}
