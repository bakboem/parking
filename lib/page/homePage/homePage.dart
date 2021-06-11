import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking/page/homePage/screen/searchBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/parkingBody.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    checkLocation();
    super.initState();
  }

  checkLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.denied ||
        permission != LocationPermission.deniedForever) {
      Position positon = await Geolocator.getCurrentPosition();
      print(positon.latitude);
      print(positon.longitude);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('lat', positon.latitude);
      prefs.setDouble('lon', positon.longitude);
    }
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
