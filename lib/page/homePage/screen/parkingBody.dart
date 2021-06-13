import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/api/parkingApi.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/model/parkingModel/parkingData.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/exportPaginationBloc.dart';
import 'package:parking/page/homePage/screen/loadingScreen.dart';
import 'package:parking/page/homePage/screen/parkingDetail.dart';
import 'package:parking/utile/textUtile.dart';

// ignore: must_be_immutable
class ParkingBody extends StatelessWidget {
  ParkingBody();
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

  String subStr(String str) {
    return str.substring(str.length - 2, str.length - 1);
  }

  Widget cardItem(BuildContext context, ParkingData data, int index) {
    return Column(
      children: [
        Container(
          child: ListTile(
            leading: Text(subStr(data.parkingName!)),
            title: Center(
              child: ListTile(
                title: Text('${data.parkingName}$index'),
                subtitle: Text('${data.tel}'),
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextUtile().parkingTypeParss('(ewrewrrewrew)');
    return Stack(
      children: [
        BlocConsumer<PaginationBloc<GetParkingInfo>,
            PaginationState<GetParkingInfo>>(
          listener: (context, state) {
            var bloc = context.read<PaginationBloc<GetParkingInfo>>();
            if (state is PageInitState<GetParkingInfo>) {
              bloc.add(RequestDataEvent<GetParkingInfo>(search: ''));
            }

            if (state is ErrorState<GetParkingInfo>) {
              Future.delayed(
                  Duration.zero, () => showMyDialog(context, '마지막입니다.'));
            }

            return;
          },
          builder: (context, state) {
            var bloc = context.read<PaginationBloc<GetParkingInfo>>();
            if (state is PageInitState<GetParkingInfo> ||
                state is LoadingState<GetParkingInfo> && parkingInfo == null) {
              return LoadingListPage();
            } else if (state is SuccessState<GetParkingInfo>) {
              bloc.isFetching = false;
              // ignore: unnecessary_null_comparison
              if (state.data != null) {
                parkingInfo = state.data;
              }
              if (parkingInfo!.dataList!.length == 0) {
                Future.delayed(
                    Duration.zero, () => showMyDialog(context, '결과없습니다.'));
              }
            }

            return RefreshIndicator(
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  controller: _scrollController
                    ..addListener(() {
                      var offset = _scrollController.offset;
                      var max = _scrollController.position.maxScrollExtent;
                      if (offset == max && !bloc.isFetching) {
                        var event = RequestDataEvent<GetParkingInfo>(
                            search: ParkingApi().searchKeyWords);
                        bloc.isFetching = true;
                        bloc.add(event);
                      }
                    }),
                  itemBuilder: (context, index) =>
                      cardItem(context, parkingInfo!.dataList![index], index),
                  separatorBuilder: (context, index) => Divider(
                    height: 6,
                    color: Colors.teal,
                  ),
                  itemCount: parkingInfo!.dataList!.length,
                ),
                onRefresh: () async => bloc.add(ResetEvent()));
          },
        ),
      ],
    );
  }
}
