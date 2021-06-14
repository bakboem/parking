import 'package:dio/dio.dart';
import 'package:parking/api/paginationApi.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import '../service/httpService.dart';

class ParkingApi extends PaginationApi {
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
  int? a;

  ///
  ///
  ///
  ///
  int? pageSize = 30;
  String searchKeyWord = '';
  GetParkInfo? cache;
  //지정 값만 넣어주면 data 호출.
  Future<Response> requestdata() async {
    Response? response;
    try {
      response = await httpService.getData(
        url: '$parkingUrl/$startRange/$endRange/$searchKeyWord',
      );
    } catch (e) {
      print(e);
    }
    return response!;
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
    print('update data');
    GetParkInfo data = GetParkInfo.fromJson(newData['GetParkInfo']);
    if (data.dataList!.length != 0) {
      if (cache == null) {
        cache = data;
        print('====new data');
      } else {
        cache!.dataList!.addAll(data.dataList!);
      }
    }
  }

  hasmore() {
    return (cache!.total)! > endRange!;
  }

  resetCearchKeyword(String keyword) => this.searchKeyWord = keyword;
  resetcache() async {
    cache = null;
  }

  resetpage() => initPage();
  getcache() => this.cache;
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

  @override
  getCache() {
    return this.getcache();
  }
}
