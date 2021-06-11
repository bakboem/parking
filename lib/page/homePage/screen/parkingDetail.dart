import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parking/model/parkingModel/parkingData.dart';

// ignore: must_be_immutable
class ParkingDetail extends StatelessWidget {
  ParkingDetail({Key? key, required this.parkingData}) : super(key: key);
  ParkingData parkingData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('${parkingData.addr}')],
        ),
      ),
    );
  }
}
