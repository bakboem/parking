import 'package:dio/dio.dart';
import 'package:parking/api/baseApi.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/service/cacheFileService.dart';
import 'package:parking/service/cacheObjectService.dart';
import '../service/httpService.dart';

class ParkingApi extends BaseApi {
  // ---------- start singleton -------
  factory ParkingApi() => _getInstance();
  static ParkingApi? _instance;
  static ParkingApi _getInstance() {
    if (_instance == null) {
      _instance = ParkingApi._();
    }
    return _instance!;
  }

  ParkingApi._();
// ------------ end singleton ---------
  HttpService httpService = HttpService();
  // CacheService cacheService = CacheService();
  // CacheObjectService cacheObjectService = CacheObjectService();
  GetParkingInfo? _parkingInfo;
  static const baseUrl = 'http://openapi.seoul.go.kr:8088';
  static const apiKey = '54744f4462636e62353146794f4649';
  static const dataType = 'json';
  static const keyWord = 'GetParkInfo';
  static const parkingUrl = '$baseUrl/$apiKey/$dataType/$keyWord';

  int? startRange;
  int? endRange;
  int? pageSize = 30;
  GetParkingInfo? cache;
  //지정 값만 넣어주면 data 호출.
  Future<GetParkingInfo> requestdata(
    String search,
  ) async {
    try {
      Response response = await httpService.getData(
        url: '$parkingUrl/$startRange/$endRange/$search',
      );
      if (response.statusCode == 200) {
        if (response.data['GetParkInfo'] != null) {
          _parkingInfo = GetParkingInfo.fromJson(response.data['GetParkInfo']);
        }
      }
    } catch (e) {
      print(e);
    }
    return _parkingInfo!;
  }

  initpage() {
    startRange = 0;
    endRange = pageSize;
  }

  updatepage() {
    startRange = endRange! + 1;
    endRange = endRange! + pageSize!;
  }

  updatedata(newData) async {
    if (cache == null) {
      print('null??????');
      print('null??????');
      print('null??????');
      print('null??????');
      print('null??????');
      print('null??????');
      print('null??????');
      print('null??????');
      cache = newData;
    } else {
      print('not null');
      print('not null');
      print('not null');
      print('not null');
      print('not null');
      print('not null');
      cache as GetParkingInfo;
      newData as GetParkingInfo;
      cache!.dataList!.addAll(newData.dataList!);
    }
    return cache;
  }

  resetcache() async {
    cache = null;
  }

  resetpage() => initPage();

  @override
  requestData(String search) async {
    return await this.requestdata(search);
  }

  @override
  updateData({required dynamic newData}) async {
    return await this.updatedata(newData);
  }

  @override
  updatePage() {
    return this.updatepage();
  }

  @override
  initPage() {
    return this.initpage();
  }

  @override
  resetPage() {
    return this.resetpage();
  }

  @override
  resetCache() {
    return this.resetcache();
  }
}
