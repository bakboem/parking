import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dio/dio.dart';
import 'package:parking/model/tokenModel/token.dart';
import 'package:parking/service/cacheFileService.dart';
import 'package:parking/service/httpService.dart';

class TokenApi {
  // ----------- start singleton --------------
  factory TokenApi() => _getInstance();
  static TokenApi? _instance;
  static TokenApi _getInstance() {
    if (_instance == null) {
      _instance = TokenApi._();
    }
    return _instance!;
  }

  TokenApi._();
  // ----------- end singleton --------------
  Token? _token;
  HttpService httpService = HttpService();
  CacheService cacheService = CacheService();
  static const String refreshUrl = 'refreshUrl';
  static const String requestUrl = 'requestUrl';
  get token => this._token;
  setToken(Token token) => this._token = token;
  Future<bool> checkTokenExpired() async {
    Token token = await cacheService.getToken();
    Duration tokenTime = JwtDecoder.getTokenTime(token.token!);
    return tokenTime.inDays > 1;
  }

  Future<Token> requestToken() async {
    Response response = await httpService.getData(url: requestUrl);
    if (response.statusCode == 200) {
      _token = Token();
      _token!.token = response.data['token'];
      return _token!;
    } else {
      return Token();
    }
  }

  Future<bool> refreshToken() async {
    _token = await cacheService.getToken();
    Response response = await httpService.postData(
        url: refreshUrl,
        options: Options(),
        data: {'refreshToken': token.token});
    if (response.statusCode == 200) {
      setToken(response.data['token']);
      return true;
    } else {
      return false;
    }
  }
}
