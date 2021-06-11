import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/api/parkingApi.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/exportPaginationBloc.dart';
import 'package:parking/page/homePage/screen/parkingDetail.dart';

// ignore: must_be_immutable
class ParkingBody extends StatelessWidget {
  GetParkingInfo? parkingInfo;

  final ScrollController _scrollController = ScrollController();

  void showMyDialog(BuildContext context, String text) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            '$text',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<PaginationBloc<GetParkingInfo>,
          PaginationState<GetParkingInfo>>(
        listener: (context, state) {
          if (state is PageInitState<GetParkingInfo>) {
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
            // ignore: unnecessary_null_comparison
            if (state.data != null) {
              parkingInfo = state.data;
            }
            if (parkingInfo!.dataList!.length == 0) {
              Future.delayed(
                  Duration.zero, () => showMyDialog(context, '결과없습니다.'));
            }
            // if (ParkingApi().hasMore()) {
            //   Future.delayed(
            //       Duration.zero, () => showMyDialog(context, '결과없습니다.'));
            // }
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
                        ..add(RequestDataEvent<GetParkingInfo>(
                            search: ParkingApi().searchKeyWords));
                    }
                  }),
                itemBuilder: (context, index) => ListTile(
                  leading: Text(
                      '${parkingInfo!.dataList![index].parkingName!.substring(parkingInfo!.dataList![index].parkingName!.length - 2, parkingInfo!.dataList![index].parkingName!.length - 1)}'),
                  title: Center(
                    child: ListTile(
                      title: Text(
                          '${parkingInfo!.dataList![index].parkingName}$index'),
                      subtitle: Text('data'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParkingDetail(
                                    parkingData: parkingInfo!.dataList![index],
                                  )),
                        );
                      },
                    ),
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
