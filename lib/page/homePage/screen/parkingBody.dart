import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/model/parkingModel/parkingData.dart';
import 'package:parking/page/homePage/bloc/mapCameraBloc/exportMapCameraBloc.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/exportPaginationBloc.dart';
import 'package:parking/page/homePage/screen/loadingScreen.dart';
import 'package:parking/page/homePage/screen/parkingDetail.dart';
import 'package:parking/service/geoService.dart';
import 'package:parking/utile/textUtile.dart';

// ignore: must_be_immutable
class ParkingBody extends StatelessWidget {
  ParkingBody({required this.scrollController});
  GetParkInfo? parkingInfo;
  late ScrollController scrollController;

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

  Widget cardItem(BuildContext context, ParkingData data) {
    var dis = GoogleGeoService().distance(data.lat!, data.lng!);
    return GestureDetector(
      onTap: () {
        context
            .read<MapCameraBloc>()
            .add(InitCameraEvent(lat: data.lat, lon: data.lng));
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          return new ParkingDetail(parkingData: data);
        }));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Center(
              child: Column(
                children: [
                  Text(
                    data.payYnName!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        '거리:',
                      ),
                      Text(
                        '$dis',
                        style: TextStyle(color: Colors.amber, fontSize: 14),
                      ),
                      Text(
                        'km',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TextUtile().parkingNameParss(data.parkingName!),
                style: TextStyle(color: Colors.teal, fontSize: 16),
              ),
              Text('전화:${data.tel}'),
              Text('${data.operationRuleName}'),
              Text('주차가능면: ${data.capacity!.toInt()}면'),
              Text('야간개방여부: ${data.nightFreeOpenName}'),
              Text('평일운영시간${data.weekDayBeginTime}~${data.weekDayEndTime}'),
              Text('주말운영시간${data.weekEndBeginTime}~${data.weekEndEndTime}'),
              Text('공휴일운영시간${data.holidayBeginTime}~${data.holidayEndTime}'),
              Text(
                  '동기화 시간: ${TextUtile().parkingSyncTimeParss(data.syncTime!)}'),
              Text('월정액 금액:${data.fulltimeMonthly}'),
              Text('기본 주차 요금: ${data.ratest!.toInt()}원'),
              Text('${data.timeRate!.toInt()}분당'),
              Text('분당 추가요금 ${data.addRates!.toInt()}원'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocConsumer<PaginationBloc<GetParkInfo>, PaginationState<GetParkInfo>>(
          listener: (context, state) {
            var bloc = context.read<PaginationBloc<GetParkInfo>>();
            // init 상태시 빈 키워드로 request.
            if (state is PageInitState<GetParkInfo>) {
              bloc.add(RequestDataEvent<GetParkInfo>(search: ''));
            }
            //오류알림.
            if (state is ErrorState<GetParkInfo>) {
              Future.delayed(
                  Duration.zero, () => showMyDialog(context, '검색결과 없음.'));
            }
            // 마지막 페이지 알림.
            if (state is LastPageState<GetParkInfo>) {
              Future.delayed(
                  Duration.zero, () => showMyDialog(context, '마지막입니다.'));
            }
            // page가 더 있으면 page++
            if (state is CheckHasMorePageState<GetParkInfo>) {
              bloc.add(AddPageEvent<GetParkInfo>());
            }
            // success 시 state값 가져와 페이지에 넣기.
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
            // 로딩 빈값 시 simer 보여주기.
            if (state is PageInitState<GetParkInfo> ||
                state is LoadingState<GetParkInfo> && parkingInfo == null) {
              return LoadingListPage();
            }

            return RefreshIndicator(
                child: ListView.separated(
                  physics: Platform.isIOS
                      ? BouncingScrollPhysics()
                      : ClampingScrollPhysics(),
                  controller: scrollController
                    ..addListener(() async {
                      var offset = scrollController.offset;
                      var max = scrollController.position.maxScrollExtent;
                      // scroll positon이  마지막일때
                      // http 통신이 완료 했을때
                      // 마지막 페이지가 이닐때.
                      if (offset == max &&
                          !bloc.isCallData &&
                          bloc.state != LastPageState<GetParkInfo>()) {
                        // event에서 searchKey 값 가져와 서버통신 해준다.
                        bloc.isCallData = true;
                        bloc.add(RequestDataEvent<GetParkInfo>(
                            search: await bloc.api!.getSearchKey()));
                      }
                      if (bloc.isNewCache) {
                        // 새로운 cache가 생성 되면 scrollController 를 맨 위로 올려준다.
                        await scrollController
                            .animateTo(0,
                                duration: Duration(seconds: 1),
                                curve: Curves.bounceIn)
                            .then((value) => bloc.isNewCache = false);
                      }
                    }),
                  itemBuilder: (context, index) =>
                      cardItem(context, parkingInfo!.dataList![index]),
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
