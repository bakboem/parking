import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  @override
  void initState() {
    super.initState();
    checkLocation();
  }

  Completer<GoogleMapController> _controller = Completer();
  checkLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.denied ||
        permission != LocationPermission.deniedForever) {
      Position positon = await Geolocator.getCurrentPosition();
      print(positon.latitude);
      print(positon.longitude);
      var a = distance(positon.latitude, positon.longitude, 36.8, -122.4164);
      print('거리! $a km');
    }
  }

  distance(double baseLat, double baseLon, double targetLat, double targetLon) {
    double distanceInMeters = GeolocatorPlatform.instance
        .distanceBetween(baseLat, baseLon, targetLat, targetLon);
    return (distanceInMeters / 1000).toStringAsFixed(1);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          child: GoogleMap(
            scrollGesturesEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            rotateGesturesEnabled: false,
            zoomGesturesEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
