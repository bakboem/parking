import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/page/homePage/bloc/geoCodingBloc/exportGeoCodingBloc.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationState.dart';
import 'package:parking/page/homePage/screen/addressWidget.dart';
import 'package:parking/page/homePage/screen/loadingScreen.dart';
import 'package:parking/page/homePage/screen/searchBar.dart';
import 'screen/parkingBody.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeoCodingBloc, GeoCodingState>(
      builder: (context, state) {
        if (state is CodingSuccessState) {
          return Scaffold(
            appBar: AppBar(
              title: Column(
                children: [
                  Text('서울 주차장검색'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.greenAccent[400],
                      ),
                      AddressWidget()
                    ],
                  )
                ],
              ),
              actions: [SearchBar()],
            ),
            body: ParkingBody(),
          );
        }
        return Scaffold(
          appBar: AppBar(),
          body: LoadingListPage(),
        );
      },
    );
  }
}
