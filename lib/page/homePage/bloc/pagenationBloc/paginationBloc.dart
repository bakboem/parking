import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/api/paginationApi.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationEvent.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationState.dart';

class PaginationBloc<T> extends Bloc<PaginationEvent<T>, PaginationState<T>> {
  final PaginationApi? api;
  bool isCallData = false;
  bool isNewCache = false;
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

// reset 페이지 초기화.
// reset cache 초기화.
// initState 로 돌려 빈값 키워드로 서버통신.
  Stream<PaginationState<T>> resetEventHandle() async* {
    await api!.resetPage();
    await api!.resetCache();
    yield PageInitState<T>();
  }

// 페이지 더 있는지 확인.
// 더 있으면 success로 전환후 cache 파싱.
// 더 없으면 success로 전환후 cache 파싱. 및 last 상태로 전환.
  Stream<PaginationState<T>> addPageEventEventHandle() async* {
    bool hasMore = await api!.hasMore();
    print(' hasMore ？？？？$hasMore');
    var cache = await api!.getCache();
    if (hasMore) {
      await api!.updatePage();
      yield SuccessState<T>(data: cache);
    } else {
      yield SuccessState<T>(data: cache);
      yield LastPageState<T>();
    }
  }

// 공공 api 특정상 무조건 key가 있어야 검생됨. 때문에 event에 키값을 강제로 넣에 주기로 함.
//
  Stream<PaginationState<T>> requestDataEventHandle(String search) async* {
    yield LoadingState<T>(message: 'Loading ...');
    if (search != await api!.getSearchKey()) {
      isNewCache = true;
      print('change searchKey ===> $search');
      await api!.resetCearchKeyWord(keyword: search);
      await api!.resetCache();
      await api!.resetPage();
    }
    final Response response = await api!.requestData();
    if (response.statusCode == 200 &&
        response.data['${T.toString()}'] != null) {
      await api!.updateData(newData: response.data);
      yield CheckHasMorePageState<T>();
    } else {
      yield ErrorState<T>(error: 'nodata');
    }
  }
}
