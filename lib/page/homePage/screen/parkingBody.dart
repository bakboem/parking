import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/model/parkingModel/parkingData.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/exportPaginationBloc.dart';
import 'package:parking/page/homePage/screen/loadingScreen.dart';
import 'package:parking/page/homePage/screen/parkingDetail.dart';
import 'package:parking/utile/textUtile.dart';

// ignore: must_be_immutable
class ParkingBody extends StatelessWidget {
  ParkingBody();
  GetParkInfo? parkingInfo;
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
            leading: Text(data.payYnName!),
            title: Center(
              child: ListTile(
                title: Text(TextUtile().parkingNameParss(data.parkingName!)),
                subtitle: Column(
                  children: [
                    Text('${data.tel}'),
                    Text('${data.operationRuleName}'),
                    Text('주차가능면: ${data.capacity}면'),
                    Text('야간개방여부: ${data.nightFreeOpenName}'),
                    Text(
                        '평일운영시간${data.weekDayBeginTime}~${data.weekDayEndTime}'),
                    Text(
                        '주말운영시간${data.weekEndBeginTime}~${data.weekEndEndTime}'),
                    Text(
                        '공휴일운영시간${data.holidayBeginTime}~${data.holidayEndTime}'),
                    Text('최종데이터 동기화 시간:${data.syncTime}'),
                    Text('월정액 금액:${data.fulltimeMonthly}'),
                    Text('기본 주차 요금: ${data.ratest}'),
                    Text(' ${data.timeRate!.toInt()}분당'),
                    Text('분당 추가요금 ${data.addRates}'),
                  ],
                ),
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
    return Stack(
      children: [
        BlocConsumer<PaginationBloc<GetParkInfo>, PaginationState<GetParkInfo>>(
          listener: (context, state) {
            var bloc = context.read<PaginationBloc<GetParkInfo>>();

            if (state is PageInitState<GetParkInfo>) {
              bloc.add(RequestDataEvent<GetParkInfo>(search: ''));
            }

            if (state is ErrorState<GetParkInfo>) {
              Future.delayed(
                  Duration.zero, () => showMyDialog(context, '검색결과 없음.'));
            }
            if (state is LastPageState<GetParkInfo>) {
              Future.delayed(
                  Duration.zero, () => showMyDialog(context, '마지막입니다.'));
            }

            if (state is CheckHasMorePageState<GetParkInfo>) {
              bloc.add(AddPageEvent<GetParkInfo>());
            }
            if (state is SuccessState<GetParkInfo>) {
              bloc.isCallData = false;
              // ignore: unnecessary_null_comparison
              if (state.data != null) {
                parkingInfo = state.data;
              }
            }
            return;
          },
          builder: (context, state) {
            var bloc = context.read<PaginationBloc<GetParkInfo>>();
            if (state is PageInitState<GetParkInfo> ||
                state is LoadingState<GetParkInfo> && parkingInfo == null) {
              return LoadingListPage();
            }

            return RefreshIndicator(
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  controller: _scrollController
                    ..addListener(() async {
                      var offset = _scrollController.offset;
                      var max = _scrollController.position.maxScrollExtent;
                      if (offset == max &&
                              !bloc.isCallData &&
                              bloc.state != LastPageState<GetParkInfo>()
                          // &&offset > screenHeight
                          ) {
                        bloc.isCallData = true;
                        bloc.add(RequestDataEvent<GetParkInfo>(
                            search: await bloc.api!.getSearchKey()));
                      }
                      if (bloc.isNewCache) {
                        await _scrollController.animateTo(0,
                            duration: Duration(microseconds: 800),
                            curve: Curves.bounceIn);
                        bloc.isNewCache = false;
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
