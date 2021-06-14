import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parking/page/homePage/screen/addressWidget.dart';
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
}
