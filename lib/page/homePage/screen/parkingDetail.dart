import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parking/model/parkingModel/parkingData.dart';
import 'package:parking/page/homePage/bloc/mapCameraBloc/exportMapCameraBloc.dart';
import 'package:parking/page/homePage/screen/parkingMap.dart';

// ignore: must_be_immutable
class ParkingDetail extends StatelessWidget {
  ParkingDetail({Key? key, required this.parkingData}) : super(key: key);
  ParkingData parkingData;
  @override
  Widget build(BuildContext context) {
    print('data 传值！！ ${parkingData.lat} ${parkingData.lng}');
   
    return Scaffold(
      appBar: AppBar(
        title: Text('주차장 상세정보'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('${parkingData.addr}'),
            ),
            ParkingMap()
          ],
        ),
      ),
    );
  }
}
