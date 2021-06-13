import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/page/homePage/bloc/geoCodingBloc/exportGeoCodingBloc.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/exportPaginationBloc.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationBloc.dart';
import 'common/baseBlocObserver.dart';
import 'page/homePage/homePage.dart';

void main() {
  Bloc.observer = BaseBlocObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<PaginationBloc<GetParkingInfo>>(
        create: (context) =>
            PaginationBloc<GetParkingInfo>()..add(ResetEvent()),
      ),
      BlocProvider<GeoCodingBloc>(
        create: (context) =>
            GeoCodingBloc(geoRepo: GeoRepo())..add(RequestAddrEvent()),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.teal),
        title: 'Material App',
        home: HomePage());
  }
}
