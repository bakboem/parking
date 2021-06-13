import 'package:geolocator/geolocator.dart';
import 'package:parking/service/geoService.dart';

class GeoRepo {
  GoogleGeoService geoService = GoogleGeoService();
  Position? _position;
  getAddr() async {
    var placeMark = await geoService
        .getPlacMark(_position != null ? _position! : await requestPosition());
    return '${placeMark.name}${placeMark.subAdministrativeArea}';
  }

  setPosition(Position position) async {
    this._position = position;
  }

  getPosition() => this._position;

  Future<Position> requestPosition() async {
    var position = await geoService.getLocation();
    await setPosition(position);
    return position;
  }
}
