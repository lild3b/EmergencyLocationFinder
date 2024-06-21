import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locationfinder/util/currentlocation_util.dart';
import 'package:locationfinder/util/database_util.dart';
import 'package:telephony/telephony.dart';

class SendSMS extends StatefulWidget {
  final String emergencyType;
  const SendSMS({super.key, required this.emergencyType});

  @override
  State<SendSMS> createState() => _SendSMSState();
}

class _SendSMSState extends State<SendSMS> {
  final Telephony telephony = Telephony.instance;
  String message = "This is a test message!";
  late String hotline = "";
  double stationLocationLatitude = 0.0;
  double stationLocationLongitude = 0.0;
  LocalDatabase db = LocalDatabase();
  bool isLoading = false;
  int bulbValue = 0;
  bool sent = true;
  late bool isGranted;
  FirebaseDB firebaseDB = FirebaseDB();

  @override
  void initState() {
    super.initState();
    //_getCurrentLocation();
    db.loadInfoData();
    db.loadCurrentAddress();
    //db.loadCurrentLoc();
    isGranted = false;
    if (widget.emergencyType == "Fire") {
      stationLocationLatitude = LocationUtil.fireStationLatitude;
      stationLocationLongitude = LocationUtil.fireStationLongitude;
      hotline = db.info[3];
      bulbValue = 1;
      print(hotline);
      print("$stationLocationLatitude, $stationLocationLongitude");
    } else if (widget.emergencyType == "Security") {
      stationLocationLatitude = LocationUtil.policeStationLatitude;
      stationLocationLongitude = LocationUtil.policeStationLongitude;
      hotline = db.info[2];
      bulbValue = 2;
      print(hotline);
      print("$stationLocationLatitude, $stationLocationLongitude");
    } else if (widget.emergencyType == "Disaster") {
      stationLocationLatitude = LocationUtil.MDRRMO_StationLatitude;
      stationLocationLongitude = LocationUtil.MDRRMO_StationLongitude;
      hotline = db.info[4];
      bulbValue = 3;
      print(hotline);
      print("$stationLocationLatitude, $stationLocationLongitude");
    } else {
      stationLocationLatitude = 0.0;
      stationLocationLongitude = 0.0;
      bulbValue = 0;
      print("Bulb turned off: $bulbValue");
    }

    SMSpermission();

    firebaseDB.checkConnection();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await LocationUtil.getCurrentLocation();
      setState(() {
        db.setCurrentLoc(position.latitude, position.longitude);
        //sent = true;
      });
    } catch (e) {
      setState(() {
        print('Error: $e');
      });
    }
  }

  void SMSpermission() async {
    var stat = await SMS.smsPermission();

    if (stat != null) {
      print("Permission granted");
      isGranted = true;
    } else {
      print("Permission denied");
      isGranted = false;
    }
    return stat;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> sendCall() async {
    var res = await SMS.smsPermission();
    try {
      if (res != false) {
        await telephony.dialPhoneNumber(hotline);
      } else {
        print("Please accept permission to call.");
        /*SnackbarUtil.showSnackbar(
          context, "Permission is denied or no coordinates fetched.", 1); */
      }
    } catch (e) {
      print("Catched in sendCall func: ");
      print(e);
    }
  }

  Future<void> sendSMS() async {
    //_getCurrentLocation();
    bool? canSendSms = await telephony.isSmsCapable;
    double distance = await LocationUtil.getDistanceToStation(
        stationLocationLatitude, stationLocationLongitude);
    var res = await SMS.smsPermission();
    print(hotline);
    try {
      if (res != false && db.currAddress.isNotEmpty) {
        await telephony.sendSms(
          to: hotline,
          message:
              "${widget.emergencyType.toUpperCase()} EMERGENCY HELP!\n\nLocation: ${db.currAddress} \n\nDistance from ${widget.emergencyType.toLowerCase()} station: ${distance.toStringAsFixed(2)} km",
        );
        firebaseDB.updateBulb(bulbValue, db.info[1]);
      } else {
        print("Error: CANT SEND SMS");
        /*SnackbarUtil.showSnackbar(
          context, "Permission is denied or no coordinates fetched.", 1); */
      }
    } catch (e) {
      print("Catched in sendSMS func: ");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;
    double screenWeight = MediaQuery.of(context).size.width;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${widget.emergencyType.toUpperCase()} EMERGENCY'),
            const SizedBox(height: 15),
            const Text('Send SMS and call for emergency?'),
            const SizedBox(height: 15),
            sent
                ? Wrap(
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: screenWeight * 0.35,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.green.shade400)),
                          onPressed: () => {
                            setState(() {
                              sendSMS();
                              Navigator.pop(context);
                            })
                          },
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.message,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Send SMS",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: screenWeight * 0.35,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue.shade700),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.cancel,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : CircularProgressIndicator(
                    color: Colors.red.shade400,
                  ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  sendCall();
                  Navigator.pop(context);
                  sendSMS();
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  height: 80,
                  width: 80,
                  color: Colors.red.shade700,
                  child: const Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "CALL",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      FaIcon(
                        FontAwesomeIcons.phone,
                        color: Colors.white,
                      )
                    ],
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
