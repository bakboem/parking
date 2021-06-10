import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/api/baseApi.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationEvent.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationState.dart';

class PaginationBloc<T> extends Bloc<PaginationEvent<T>, PaginationState<T>> {
  BaseApi? baseApi;
  bool isFetching = false;

  PaginationBloc({required this.baseApi}) : super(PageInitState<T>());

  @override
  Stream<PaginationState<T>> mapEventToState(PaginationEvent<T> event) async* {
    if (event is ResetPageEvent<T>) {
      yield* resetEventHandle();
    }
    if (event is RequestDataEvent<T>) {
      yield* requestDataEventHandle(event.search!);
    }

    if (event is AppendDataEvent<T>) {
      yield* appendDataEventHandle(event.data);
    }
  }

  Stream<PaginationState<T>> resetEventHandle() async* {
    baseApi!.resetPage();
    yield PageInitState<T>();
  }

  Stream<PaginationState<T>> requestDataEventHandle(String search) async* {
    yield LoadingState<T>(message: 'Loading ...');
    final response = await baseApi!.requestData(search);
    if (response != null) {
      yield ProcessDataState<T>(
        data: response as T,
      );
    } else {
      yield ErrorState<T>(error: 'data is null');
    }
  }

  Stream<PaginationState<T>> appendDataEventHandle(T data) async* {
    await baseApi!.updatePage();
    var _data = await baseApi!.updateData(data: data);
    yield SuccessState<T>(data: _data);
  }
}
