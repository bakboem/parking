import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/api/baseApi.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationEvent.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationState.dart';

class PaginationBloc<T> extends Bloc<PaginationEvent<T>, PaginationState<T>> {
  BaseApi? baseApi;
  bool isFetching = false;
  bool isFirstCall = true;
  PaginationBloc({required this.baseApi}) : super(PageInitState<T>());

  @override
  Stream<PaginationState<T>> mapEventToState(PaginationEvent<T> event) async* {
    if (event is ResetEvent<T>) {
      yield* resetEventHandle();
    }
    if (event is RequestDataEvent<T>) {
      yield* requestDataEventHandle(event.search!);
    }
  }

  Stream<PaginationState<T>> resetEventHandle() async* {
    await baseApi!.resetPage();
    await baseApi!.resetCache();
    yield PageInitState<T>();
  }

  Stream<PaginationState<T>> requestDataEventHandle(String search) async* {
    yield LoadingState<T>(message: 'Loading ...');

    if (search != await baseApi!.getSearchKey()) {
      isFirstCall = true;
      await baseApi!.resetCearchKeyWord(keyword: search);
      await baseApi!.resetCache();
      await baseApi!.resetPage();
    } else {
      print('相同');
    }

    if (isFirstCall) {
      final response = await baseApi!.requestData();

      if (response != null) {
        var cacheData = await baseApi!.updateData(newData: response);
        cacheData as GetParkingInfo;

        yield SuccessState<T>(
          data: cacheData as T,
        );
      } else {
        yield ErrorState<T>(error: 'data is null');
      }
    } else {
      var hasmore = await baseApi!.hasMore();

      if (hasmore) {
        await baseApi!.updatePage();
        final response = await baseApi!.requestData();

        if (response != null) {
          var cacheData = await baseApi!.updateData(newData: response);
          cacheData as GetParkingInfo;

          yield SuccessState<T>(
            data: cacheData as T,
          );
        } else {
          yield ErrorState<T>(error: 'data is null');
        }
        print('hasMore');
      } else {
        print('no More');
        print('no More');
        yield ErrorState<T>(error: 'last data');
      }
    }

    isFirstCall = false;
  }
}
