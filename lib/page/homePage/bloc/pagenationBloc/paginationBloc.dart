import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/api/paginationApi.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationEvent.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationState.dart';

class PaginationBloc<T> extends Bloc<PaginationEvent<T>, PaginationState<T>> {
  PaginationApi? pageApi;
  bool isFetching = false;
  bool isFirstCall = true;
  PaginationBloc({required this.pageApi}) : super(PageInitState<T>());

  @override
  Stream<PaginationState<T>> mapEventToState(PaginationEvent<T> event) async* {
    if (event is ResetEvent<T>) {
      yield* resetEventHandle();
    }
    if (event is RequestDataEvent<T>) {
      yield* requestDataEventHandle(event.search!);
    }
    if (event is AddPageEvent<T>) {
      yield* addPageEventEventHandle();
    }
  }

  Stream<PaginationState<T>> resetEventHandle() async* {
    await pageApi!.resetPage();
    await pageApi!.resetCache();
    yield PageInitState<T>();
  }

  Stream<PaginationState<T>> addPageEventEventHandle() async* {
    yield PageInitState<T>();
  }

  Stream<PaginationState<T>> requestDataEventHandle(String search) async* {
    yield LoadingState<T>(message: 'Loading ...');

    if (search != await pageApi!.getSearchKey()) {
      isFirstCall = true;
      await pageApi!.resetCearchKeyWord(keyword: search);
      await pageApi!.resetCache();
      await pageApi!.resetPage();

      print('firestcall');
      print('firestcall');
      print('firestcall');
    } else {
      print('相同');
    }

    if (isFirstCall) {
      final response = await pageApi!.requestData();

      if (response != null) {
        print('response!=nulll');
        print('response!=nulll');
        print('response!=nulll');
        print('response!=nulll');

        print(response);
        var cacheData = await pageApi!.updateData(newData: response);
        cacheData as GetParkingInfo;

        yield SuccessState<T>(
          data: cacheData as T,
        );
      } else {
        yield ErrorState<T>(error: 'data is null');
      }
    } else {
      //openAPI 특정 맟춰
      var hasmore = await pageApi!.hasMore();

      if (hasmore) {
        await pageApi!.updatePage();
        final response = await pageApi!.requestData();

        if (response != null) {
          var cacheData = await pageApi!.updateData(newData: response);
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
