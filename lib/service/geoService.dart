import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GoogleGeoService {
  factory GoogleGeoService() => _sharedInstance();

  static GoogleGeoService? _instance;

  GoogleGeoService._() {}
  LocationPermission? permission;
  static GoogleGeoService _sharedInstance() {
    if (_instance == null) {
      _instance = GoogleGeoService._();
    }
    return _instance!;
  }

  Future<void> checkPermisson() async {
    bool enable = await Geolocator.isLocationServiceEnabled();
    if (!enable) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }
    }
  }

  Future<Position> getLocation() async {
    await checkPermisson();
    Position position = await Geolocator.getCurrentPosition().catchError((e) {
      throw Exception('GeoLocation location load fail');
    });
    return position;
  }

  Future<Placemark> getPlacMark(Position position) async {
    List<Placemark> placemark = await GeocodingPlatform.instance
        .placemarkFromCoordinates(position.latitude, position.longitude)
        .catchError((e) {
      throw Exception('local addr load fail');
    });
    return placemark.first;
  }

  Future<Position> getLastPosition() async {
    Position? position =
        await Geolocator.getLastKnownPosition().catchError((e) {
      throw Exception('GeoLocation last position load fail.');
    });
    return position!;
  }

  Future<Stream<Position>> getPositonStream() async {
    return GeolocatorPlatform.instance.getPositionStream();
  }

  Future<String> distance(double localLat, double localLon, double targetLat,
      double targetLon) async {
    double distanceInMeters = GeolocatorPlatform.instance
        .distanceBetween(localLat, localLon, targetLat, targetLon);

    return (distanceInMeters / 1000).toStringAsFixed(1);
  }
}
