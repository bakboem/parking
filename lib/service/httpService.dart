import 'package:dio/dio.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/model/tokenModel/token.dart';
import 'package:parking/service/cacheService.dart';

class HttpService {
  Dio _dio = Dio();
  factory HttpService() => _getInstance();
  static HttpService? _instance;

  static HttpService _getInstance() {
    if (_instance == null) {
      _instance = HttpService.init();
    }
    return _instance!;
  }

  HttpService.init() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (option, handle) async {
      handle.next(option);
    }, onResponse: (res, handle) async {
      handle.next(res);
    }, onError: (error, handle) async {
      handle.next(error);
    }));
  }

  Future setToken(String token) async =>
      CacheService().setToken(token: Token(token: token));
  Future<Token> getToken() async => await CacheService().getToken();
  Future<void> checkNetWork() async {}
  Future<void> handleErrorMassage() async {}

  Future<Response> getData({
    required String url,
  }) async {
    Response response = await _dio.get('$url');
    return response;
  }

  Future<Response> postData(
      {required String url,
      required Options options,
      required Map<String, dynamic> data}) async {
    Response response = await _dio.post('$url', options: options, data: data);
    return response;
  }
}
