import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/api/parkingApi.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/model/tokenModel/token.dart';
import 'package:parking/service/cacheFileService.dart';
import 'package:parking/service/filePollingService.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/exportPaginationBloc.dart';
import 'screen/parkingBody.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getToken() async {
    await FilePollingService().watchDir(
        await CacheService().getLocalDirectory().then((value) => value.path));
    // await CacheService().deleteToken();
    await CacheService().saveToken(token: Token(token: 'baifan'));
    var a = await CacheService().getToken();
    print('token :${a.token}');
  }

  getParkingData() async {
    await ParkingApi().data('상', startRange: 1, endRange: 20);
  }

  @override
  void initState() {
    getToken();
    getParkingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaginationBloc<GetParkingInfo>(
        baseApi: ParkingApi(),
      )..add(FetchEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Beers \u{1F37A}'),
        ),
        body: ParkingBody(),
      ),
    );
  }
}
