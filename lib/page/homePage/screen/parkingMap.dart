import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/page/homePage/bloc/mapCameraBloc/exportMapCameraBloc.dart';

// ignore: must_be_immutable
class ParkingMap extends StatelessWidget {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition? cameraPosition;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 300,
        child: BlocConsumer<MapCameraBloc, MapCameraState>(
          listener: (context, state) {
            if (state is InitSuccessState) {
              cameraPosition = state.cameraPosition;
              print('caonima!#!@#@!${state.cameraPosition.target}');
              print('caonima!#!@#@!${state.cameraPosition.target}');
              print('caonima!#!@#@!${state.cameraPosition.target}');
              print('caonima!#!@#@!${state.cameraPosition.target}');
            }
          },
          builder: (context, state) {
            if (state is InitSuccessState) {
              return GoogleMap(
                scrollGesturesEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                rotateGesturesEnabled: false,
                zoomGesturesEnabled: false,
                markers: <Marker>{
                  Marker(
                      markerId: MarkerId('mk'),
                      position: state.cameraPosition.target)
                },
                mapType: MapType.normal,
                initialCameraPosition: state.cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  print(state.cameraPosition.target);
                  print(state.cameraPosition.target);
                  _controller.complete(controller);
                },
              );
            }
            return Scaffold(
              appBar: AppBar(),
              body: Container(),
            );
          },
        ));
  }
}
