import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/exportPaginationBloc.dart';

// ignore: must_be_immutable
class ParkingBody extends StatefulWidget {
  @override
  _ParkingBodyState createState() => _ParkingBodyState();
}

class _ParkingBodyState extends State<ParkingBody> {
  GetParkingInfo? parkingInfo;

  final ScrollController _scrollController = ScrollController();

  showDialogs(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('검색결과 없습니다.'),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<PaginationBloc<GetParkingInfo>,
          PaginationState<GetParkingInfo>>(
        listener: (context, state) {
          if (state is PageInitState<GetParkingInfo>) {
            print('init State!@');
            print('init State!@');
            print('init State!@');
            print('init State!@');
            print('init State!@');
            print('init State!@');
            context
                .read<PaginationBloc<GetParkingInfo>>()
                .add(RequestDataEvent<GetParkingInfo>(search: ''));
          }

          if (state is SuccessState<GetParkingInfo>) {}

          return;
        },
        builder: (context, state) {
          if (state is PageInitState<GetParkingInfo> ||
              state is LoadingState<GetParkingInfo> && parkingInfo == null) {
            return CircularProgressIndicator();
          } else if (state is SuccessState<GetParkingInfo>) {
            context.read<PaginationBloc<GetParkingInfo>>().isFetching = false;
            parkingInfo = state.data;
            if (parkingInfo!.dataList!.length == 0) {
              showDialogs(context);
            }
          }

          return RefreshIndicator(
              child: ListView.separated(
                physics: ClampingScrollPhysics(),
                controller: _scrollController
                  ..addListener(() {
                    if (_scrollController.offset ==
                            _scrollController.position.maxScrollExtent &&
                        !context
                            .read<PaginationBloc<GetParkingInfo>>()
                            .isFetching) {
                      context.read<PaginationBloc<GetParkingInfo>>()
                        ..isFetching = true
                        ..add(RequestDataEvent<GetParkingInfo>(search: ''));
                    }
                  }),
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(Icons.ac_unit),
                  title: Center(
                    child: Text('$index'),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemCount: parkingInfo!.dataList!.length,
              ),
              onRefresh: () async => context
                  .read<PaginationBloc<GetParkingInfo>>()
                  .add(ResetEvent()));
        },
      ),
    );
  }
}
