import 'package:firebase_database/firebase_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabase {
  List info = [];
  double currLat = 0.0;
  double currLong = 0.0;
  String currAddress = '';

  final _myBox = Hive.box('myBox');

  void loadInfoData() {
    info = _myBox.get("INFO");
  }

  void loadCurrentAddress() {
    currAddress = _myBox.get("ADDRESS").toString();
    print("Current address is $currAddress");
  }

  void loadCurrentLoc() {
    currLat = _myBox.get("LAT");
    currLong = _myBox.get("LONG");

    //print("Current latitude is $currLat");
    //print("Current longitude is $currLong");
  }

  void updateInfo(String name, String deviceinfo, String policeNum,
      String fireNum, String disasNum, String gender) {
    info.add(name);
    info.add(deviceinfo);
    info.add(policeNum);
    info.add(fireNum);
    info.add(disasNum);
    info.add(gender);
    _myBox.put("INFO", info);
  }

  void setCurrentLoc(double lat, double long) {
    currLat = lat;
    currLong = long;

    _myBox.put("LAT", currLat);
    _myBox.put("LONG", currLong);
  }

  void setCurrentAddress(String address) {
    currAddress = address;

    _myBox.put("ADDRESS", currAddress);
  }

  void editFireHotline(String num) {
    Hive.box("INFO").putAt(info[2], num);
  }
}

class FirebaseDB {
  LocalDatabase local = LocalDatabase();

  DatabaseReference dbref = FirebaseDatabase(
          databaseURL:
              "https://emergency-location-finde-a8887-default-rtdb.firebaseio.com")
      .reference();

  void updateBulb(int ledControl, String deviceinfo) async {
    print("Light the bulb: $ledControl");
    await dbref.child("$deviceinfo/ledControl").set(ledControl);
  }

  void checkConnection() async {
    dbref.onValue.listen((event) {
      var data = event.snapshot.value;
      if (data != null) {
        print("send sms Connected to the database");
      } else {
        print("Not connected to the database");
      }
    });
  }
}

class InfoModel {
  String name;
  String police;
  String fire;
  String disaster;

  InfoModel(
      {required this.name,
      required this.police,
      required this.fire,
      required this.disaster});
}
