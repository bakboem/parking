import 'package:dio/dio.dart';
import 'package:parking/api/tokenApi.dart';
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
      if (option.method == 'POST') {
        bool expired = await TokenApi().checkTokenExpired();
        if (expired) {
          await TokenApi().refreshToken().then((refreshSuccess) {
            if (refreshSuccess) {
              CacheService().setToken(token: TokenApi().token);
            }
          });
        }
      }
      handle.next(option);
    }, onResponse: (res, handle) async {
      if (res.headers.value('Authorization') != null) {
        String authToken = res.headers.value('Authorization')!;
        await TokenApi().setToken(Token(token: authToken));
        await setToken(TokenApi().token);
      }
      handle.next(res);
    }, onError: (error, handle) async {
      if (error.type == DioErrorType.sendTimeout ||
          error.type == DioErrorType.connectTimeout) {
        await checkNetWork();
      }
      if (error.type == DioErrorType.other ||
          error.type == DioErrorType.response) {
        await handleErrorMassage();
      }
      handle.next(error);
    }));
  }

  Future<void> setToken(String token) async =>
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
