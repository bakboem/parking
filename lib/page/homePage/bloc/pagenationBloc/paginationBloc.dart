import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/api/paginationApi.dart';
import 'package:parking/api/parkingApi.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationEvent.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationState.dart';

class PaginationBloc<T> extends Bloc<PaginationEvent<T>, PaginationState<T>> {
  bool isFetching = false;
  bool isFirstCall = true;
  final PaginationApi? api;
  PaginationBloc({required this.api}) : super(PageInitState<T>());

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
    await ParkingApi().resetPage();
    await ParkingApi().resetCache();
    yield PageInitState<T>();
  }

  Stream<PaginationState<T>> addPageEventEventHandle() async* {
    yield PageInitState<T>();
  }

  Stream<PaginationState<T>> requestDataEventHandle(String search) async* {
    yield LoadingState<T>(message: 'Loading ...');

    if (search != await ParkingApi().getSearchKey()) {
      isFirstCall = true;
      await ParkingApi().resetCearchKeyWord(keyword: search);
      await ParkingApi().resetCache();
      await ParkingApi().resetPage();

      print('firestcall');
      print('firestcall');
      print('firestcall');
    } else {
      print('相同');
    }

    if (isFirstCall) {
      final Response response = await ParkingApi().requestData();
      if (response.statusCode == 200 &&
          response.data['${T.runtimeType.toString()}'] != null) {
        var cacheData = await ParkingApi().updateData(newData: response.data);
        yield SuccessState<T>(
          data: cacheData as T,
        );
      } else {
        yield ErrorState<T>(error: 'data is null');
      }

      if (response != null) {
        print('response!=nulll');
        print('response!=nulll');
        print('response!=nulll');
        print('response!=nulll');

        print(response);
        var cacheData = await ParkingApi().updateData(newData: response);

        yield SuccessState<T>(
          data: cacheData as T,
        );
      } else {
        yield ErrorState<T>(error: 'data is null');
      }
    } else {
      //openAPI 특정 맟춰
      var hasmore = await ParkingApi().hasMore();

      if (hasmore) {
        await ParkingApi().updatePage();
        final response = await ParkingApi().requestData();

        if (response != null) {
          var cacheData = await ParkingApi().updateData(newData: response);

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
