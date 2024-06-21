import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:locationfinder/screens/emergencies/FirePage.dart';
import 'package:locationfinder/screens/emergencies/DisastersPage.dart';
import 'package:locationfinder/screens/emergencies/SecurityPage.dart';
import 'package:locationfinder/util/database_util.dart';
import 'package:locationfinder/util/snackbar_util.dart';
import 'package:telephony/telephony.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallEmergency extends StatefulWidget {
  const CallEmergency({super.key});

  @override
  State<CallEmergency> createState() => _CallEmergencyState();
}

class _CallEmergencyState extends State<CallEmergency> {
  final myBox = Hive.box('myBox');
  String address = "Loading...";
  String tempaddress = "Loading...";
  Telephony telephony = Telephony.instance;
  LocalDatabase db = LocalDatabase();
  bool isAddress = false;
  FirebaseDB ref = FirebaseDB();
  bool isbulbOff = true;
  int isClicked = 0;
  String gender = "";
  bool isDefault = false;
  bool isInternetOn = false;
  late Position currentPosition;

  //Check internet variables
  late StreamSubscription subscription;
  String message = 'Checking...';
  Color statuscolor = Colors.transparent;

  @override
  void initState() {
    checkConnectivity();
    //_getCurrentLocation();
    getCurrentLocation();
    db.loadInfoData();
    //db.loadCurrentLoc();
    db.loadCurrentAddress();

    print("address value: $address");

    if (address != "Loading...") {
      setState(() {
        print("Now address is not null");
        getCurrentLocation();
        isAddress = true;
      });
    }

    if (db.info[5] == "Male") {
      gender = "assets/man.png";
    } else if (db.info[5] == "Female") {
      gender = "assets/girl.png";
    }

    ref.dbref.child("${db.info[1]}/ledControl").onValue.listen((event) {
      var data = event.snapshot.value;
      setState(() {
        if (data == 0) {
          print("Bulb is turned off");
          isbulbOff = true;
          isClicked = 0;
        } else if (data == 1) {
          isClicked = 1;
          isbulbOff = false;
          print("isClicked: $isClicked");
        } else if (data == 2) {
          isClicked = 2;
          isbulbOff = false;
          print("isClicked: $isClicked");
        } else if (data == 3) {
          isClicked = 3;
          isbulbOff = false;
          print("isClicked: $isClicked");
        }
      });
    });

    subscription =
        Connectivity().onConnectivityChanged.listen((checkInternetStatus) {
      checkConnectivity();
      getCurrentLocation();
    });

    super.initState();
  }

  void checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    for (var result in results) {
      setState(() {
        checkInternetStatus(result);
      });
    }
  }

  void checkInternetStatus(ConnectivityResult result) {
    setState(() => message);

    switch (result) {
      case ConnectivityResult.bluetooth:
      // TODO: Handle this case.
      case ConnectivityResult.wifi:
        setState(() {
          print("Connected to WiFi network");
          statuscolor = Colors.green;
        });
      case ConnectivityResult.ethernet:
      // TODO: Handle this case.
      case ConnectivityResult.mobile:
        setState(() {
          print("Connected to mobile network");
          statuscolor = Colors.orange;
        });
      case ConnectivityResult.none:
        setState(() {
          SnackbarUtil.showSnackbar(
              context, 'Not connected to the internet', 1);
          print("Not connected to the internet");
          statuscolor = Colors.transparent;
        });
      case ConnectivityResult.vpn:
      // TODO: Handle this case.
      case ConnectivityResult.other:
      // TODO: Handle this case.
      default:
        message;
    }
  }

  Widget defaultDash() {
    return const Column(
      children: [FireEmergency(), RobberyEmergency(), FloodEmergency()],
    );
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = placemarks[0];
      String addresss =
          '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
      setState(() {
        currentPosition = position;
        address = addresss;
        db.setCurrentAddress(address);
        db.setCurrentLoc(position.latitude, position.longitude);
        print("New address: $address");
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  void dispose() {
    print("Disposed");
    subscription.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        shadowColor: Colors.red.shade400,
        toolbarHeight: 100,
        backgroundColor: Colors.red.shade400,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, ${db.info[0]}",
              style: const TextStyle(
                  fontFamily: 'Spotify',
                  fontSize: 25,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () {
                    getCurrentLocation();
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Expanded(
                    child: Text(
                  address,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                      fontFamily: 'Spotify',
                      fontSize: 13,
                      fontWeight: FontWeight.w100,
                      color: Colors.white),
                ))
              ],
            ),
          ],
        ),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              height: 8,
              width: 8,
              color: statuscolor,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              height: 60,
              width: 60,
              color: Colors.white,
              child: FittedBox(fit: BoxFit.fill, child: Image.asset(gender)),
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        height: screenHeight * 0.80,
        padding: const EdgeInsets.all(20),
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 10,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isClicked == 1
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (mounted) {
                                SnackbarUtil.showSnackbar(
                                    context, "Please turn off alarm first", 2);
                              }
                            },
                            child: const AbsorbPointer(
                              child: FireEmergency(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          stopButton(),
                        ],
                      )
                    : isClicked == 2
                        ? Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                    SnackbarUtil.showSnackbar(context,
                                        "Please turn off alarm first", 2);
                                  }
                                },
                                child: const AbsorbPointer(
                                  child: RobberyEmergency(),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              stopButton(),
                            ],
                          )
                        : isClicked == 3
                            ? Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (mounted) {
                                        SnackbarUtil.showSnackbar(context,
                                            "Please turn off alarm first", 2);
                                      }
                                    },
                                    child: const AbsorbPointer(
                                      child: FloodEmergency(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  stopButton(),
                                ],
                              )
                            : isbulbOff
                                ? defaultDash()
                                : Container(
                                    child: Center(
                                      child: Text("NO DATA"),
                                    ),
                                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget stopButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 60,
        width: 60,
        color: Colors.red.shade400,
        child: GestureDetector(
            onLongPress: () {},
            onTap: () {
              if (isbulbOff == false) {
                setState(() {
                  ref.updateBulb(0, db.info[1]);
                  print("Device info: ${db.info[1]}");
                  isbulbOff = true;
                  isClicked = 0;
                });
                SnackbarUtil.showSnackbar(context, "Emergency now stopped.", 1);
              } else {
                print("Currently bulb is turned off");
              }
            },
            child: Icon(isbulbOff ? Icons.play_arrow : Icons.stop,
                color: Colors.white, size: 45)),
      ),
    );
  }
}
