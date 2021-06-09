import 'package:dio/dio.dart';
import 'package:parking/api/baseApi.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';

import '../service/httpService.dart';

class ParkingApi extends BaseApi {
  factory ParkingApi() => _getInstance();
  static ParkingApi? _instance;
  static ParkingApi _getInstance() {
    if (_instance == null) {
      _instance = ParkingApi._();
    }
    return _instance!;
  }

  ParkingApi._();

  HttpService httpService = HttpService();
  GetParkingInfo? _parkingInfo;
  static const baseUrl = 'http://openapi.seoul.go.kr:8088';
  static const apiKey = '54744f4462636e62353146794f4649';
  static const dataType = 'json';
  static const keyWord = 'GetParkInfo';
  static const parkingUrl = '$baseUrl/$apiKey/$dataType/$keyWord';
  Future<GetParkingInfo> data(String search,
      {required int startRange, required int endRange}) async {
    Response response = await httpService.getData(
      url: '$parkingUrl/$startRange/$endRange/$search',
    );
    _parkingInfo = GetParkingInfo.fromJson(response.data['GetParkInfo']);
    print('-------${_parkingInfo!.dataList![1].addr!.trim()}');

    return _parkingInfo!;
  }
}
