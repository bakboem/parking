import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking/api/parkingApi.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/model/parkingModel/parkingData.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/exportPaginationBloc.dart';
import 'package:parking/page/homePage/screen/loadingScreen.dart';
import 'package:parking/page/homePage/screen/parkingDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ParkingBody extends StatelessWidget {
  GetParkingInfo? parkingInfo;

  double? lat;

  double? lon;

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

  getLatLonData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lat = prefs.getDouble('lat');
    lon = prefs.getDouble('lon');
  }

  distance(double targetLat, double targetLon) {
    double distanceInMeters = GeolocatorPlatform.instance
        .distanceBetween(lat ??= 0, lon ??= 0, targetLat, targetLon);

    return (distanceInMeters / 1000).toStringAsFixed(1);
  }

  Widget parkingType() {
    return Container();
  }

  Widget cardItem(BuildContext context, ParkingData data, int index) {
    return Column(
      children: [
        index == 0 ? parkingType() : Container(),
        Container(
          child: ListTile(
            leading: Text(subStr(data.parkingName!)),
            title: Center(
              child: ListTile(
                title: Text('${data.parkingName}$index'),
                subtitle: Text('${distance(data.lat!, data.lng!)}'),
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
    getLatLonData();

    return Center(
      child: BlocConsumer<PaginationBloc<GetParkingInfo>,
          PaginationState<GetParkingInfo>>(
        listener: (context, state) {
          if (state is PageInitState<GetParkingInfo>) {
            context
                .read<PaginationBloc<GetParkingInfo>>()
                .add(RequestDataEvent<GetParkingInfo>(search: ''));
          }

          if (state is ErrorState<GetParkingInfo>) {
            Future.delayed(
                Duration.zero, () => showMyDialog(context, '마지막입니다.'));
          }

          return;
        },
        builder: (context, state) {
          if (state is PageInitState<GetParkingInfo> ||
              state is LoadingState<GetParkingInfo> && parkingInfo == null) {
            return LoadingListPage();
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
                itemBuilder: (context, index) =>
                    cardItem(context, parkingInfo!.dataList![index], index),
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
