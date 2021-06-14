import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/page/homePage/bloc/geoCodingBloc/exportGeoCodingBloc.dart';
import 'package:parking/page/homePage/screen/addressWidget.dart';
import 'package:parking/page/homePage/screen/loadingScreen.dart';
import 'package:parking/page/homePage/screen/searchBar.dart';
import 'screen/parkingBody.dart';

class HomePage extends StatelessWidget {
  ScrollController scrollController = ScrollController();
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
            body: Stack(
              children: [
                ParkingBody(
                  scrollController: scrollController,
                ),
                Positioned(
                    bottom: 30,
                    right: 30,
                    child: IconButton(
                        onPressed: () {
                          scrollController.animateTo(0,
                              duration: Duration(microseconds: 600),
                              curve: Curves.ease);
                        },
                        icon: Icon(
                          Icons.arrow_circle_up_outlined,
                          size: 40,
                          color: Colors.teal,
                        )))
              ],
            ),
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
