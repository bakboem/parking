import 'package:flutter/widgets.dart';
import 'package:parking/api/parkingApi.dart';
import 'package:parking/model/tokenModel/token.dart';
import 'package:parking/service/cacheService.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getToken() async {
    await CacheService().deleteToken();
    await CacheService().setToken(token: Token(token: 'baifan'));
    var a = await CacheService().getToken();
    print('token :${a.token}');
  }

  getParkingData() async {
    await ParkingApi().data(startRange: 1, endRange: 20);
  }

  @override
  void initState() {
    getToken();
    getParkingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
