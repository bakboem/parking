import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/api/parkingApi.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/page/homePage/bloc/geoCodingBloc/exportGeoCodingBloc.dart';
import 'package:parking/page/homePage/bloc/mapCameraBloc/exportMapCameraBloc.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/exportPaginationBloc.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationBloc.dart';
import 'package:parking/service/dbService.dart';
import 'package:parking/service/encryptionService.dart';
import 'common/baseBlocObserver.dart';
import 'page/homePage/homePage.dart';

void main() {
  Bloc.observer = BaseBlocObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<PaginationBloc<GetParkInfo>>(
        create: (context) =>
            PaginationBloc<GetParkInfo>(api: ParkingApi())..add(ResetEvent()),
      ),
      BlocProvider<GeoCodingBloc>(
        create: (context) =>
            GeoCodingBloc(geoRepo: GeoRepo())..add(RequestAddrEvent()),
      ),
      BlocProvider<MapCameraBloc>(
          create: (context) => MapCameraBloc(cameraRepo: MapCameraRepo())),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var a = EncryptionService().encrypt('fan');
    print(a);
    var sql = DbService().makeSql({
      'Table': 'Tb',
      'PrimaryKey': 'userid',
      'ColumnTextNotNull': 'name',
      'ColumnInt': 'age',
      'ColumnText': 'row'
    });
    DbService().createDB('test', sql);
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.teal),
        title: 'Material App',
        home: HomePage());
  }
}
