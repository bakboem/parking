import 'package:dio/dio.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';

import '../service/httpService.dart';

class ParkingApi {
  HttpService httpService = HttpService.init();
  static const baseUrl = 'http://openapi.seoul.go.kr:8088';
  static const apiKey = '54744f4462636e62353146794f4649';
  static const dataType = 'json';
  static const keyWord = 'GetParkInfo';
  static const parkingUrl = '$baseUrl/$apiKey/$dataType/$keyWord';

  Future<GetParkingInfo> data(
      {required int startRange, required int endRange}) async {
    Response response = await httpService.getData(
      url: '$parkingUrl/$startRange/$endRange/',
    );
    GetParkingInfo parkingInfo =
        GetParkingInfo.fromJson(response.data['GetParkInfo']);
    print('-------${parkingInfo.dataList![1].addr!.trim()}');

    return parkingInfo;
  }
}
