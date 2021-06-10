import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationEvent.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationState.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/reposytory.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  final PaginationReposytory paginationReposytory;
  int page = 1;
  bool isFetching = false;

  PaginationBloc({
    required this.paginationReposytory,
  }) : super(PageInitState());

  @override
  Stream<PaginationState> mapEventToState(PaginationEvent event) async* {
    if (event is FetchEvent) {
      yield PageLoadingState(message: 'Loading ...');
      final response = await paginationReposytory.getData(page: page);
      if (response != null) {
        yield SuccessState<GetParkingInfo>(
          data: response as GetParkingInfo,
        );
      } else {
        yield ErrorState(error: 'data is null');
      }
    }
  }
}
