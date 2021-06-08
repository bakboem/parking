class HttpService {
  String? baseURL;
  factory HttpService() => _getInstance();
  static HttpService? _instance;
  HttpService._() {
    // 具体初始化代码
  }
  static HttpService _getInstance() {
    if (_instance == null) {
      _instance = HttpService._();
    }
    return _instance!;
  }

  Future<void> setUrl(String url) async => this.baseURL = url;
  Future<Object> post() async {
    return '';
  }
}
