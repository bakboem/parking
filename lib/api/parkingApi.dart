import 'package:dio/dio.dart';
import 'package:parking/api/baseApi.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
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

  static const baseUrl = 'http://openapi.seoul.go.kr:8088';
  static const apiKey = '54744f4462636e62353146794f4649';
  static const dataType = 'json';
  static const keyWord = 'GetParkInfo';
  static const parkingUrl = '$baseUrl/$apiKey/$dataType/$keyWord';

  int? startRange;
  int? endRange;

  ///
  ///
  ///
  ///
  int? pageSize = 30;
  String searchKeyWord = '';
  GetParkingInfo? cache;
  //지정 값만 넣어주면 data 호출.
  Future<GetParkingInfo> requestdata() async {
    GetParkingInfo? temp;
    try {
      Response response = await httpService.getData(
        url: '$parkingUrl/$startRange/$endRange/$searchKeyWord',
      );
      if (response.data['GetParkInfo'] != null) {
        temp = GetParkingInfo.fromJson(response.data['GetParkInfo']);
      } else {
        temp = GetParkingInfo(dataList: []);
      }
    } catch (e) {
      print(e);
    }
    return temp!;
  }

  get searchKeyWords => this.searchKeyWord;
  initpage() {
    startRange = 0;
    endRange = pageSize;
    print('initPage ==== startRange:  $startRange');
    print('initPage ==== endRange:  $endRange');
  }

  updatepage() {
    startRange = endRange! + 1;
    endRange = endRange! + pageSize!;
    print('updatePage ==== startRange:  $startRange');
    print('updatePage ==== endRange:  $endRange');
  }

  updatedata(newData) async {
    newData as GetParkingInfo;
    if (newData.dataList!.length != 0) {
      if (cache == null) {
        cache = newData;
        print('====new data');
      } else {
        cache!.dataList!.addAll(newData.dataList!);
        cache!.total = newData.total;
      }
    } else {
      cache = GetParkingInfo(total: 0, dataList: []);
    }
    return cache;
  }

  hasmore() {
    if (cache != null) {
      print(' cache total ${cache!.total!}');
      print(' cache total ${cache!.total!}');
      print(' end total $endRange');
      print(' end total $endRange');
      return cache!.total! > endRange!;
    } else {
      return true;
    }
  }

  resetCearchKeyword(String keyword) => this.searchKeyWord = keyword;
  resetcache() async {
    cache = null;
  }

  resetpage() => initPage();

  @override
  requestData() async {
    return await this.requestdata();
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

  @override
  resetCearchKeyWord({required String keyword}) {
    return this.resetCearchKeyword(keyword);
  }

  @override
  getSearchKey() {
    return this.searchKeyWord;
  }

  @override
  hasMore() {
    return this.hasmore();
  }
}
