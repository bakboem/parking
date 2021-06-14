import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCameraRepo {
  CameraPosition? cameraPosition;
  setCameraPosition(double lat, double lon) async {
    // ignore: unnecessary_statements
    this.cameraPosition = CameraPosition(target: LatLng(lat, lon), zoom: 17);
  }
}
