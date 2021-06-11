import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        title: Text('서울 주차장검색'),
        actions: [SearchBar()],
      ),
      body: ParkingBody(),
    );
  }
}
