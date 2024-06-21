import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:locationfinder/screens/tabs/callemergencywindow.dart';
import 'package:locationfinder/screens/tabs/hotlineswindow.dart';
import 'package:locationfinder/util/database_util.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  bool? home;
  bool? details;
  int container = 1;
  bool home_icon = false;
  bool details_icon = false;
  final _myBox = Hive.box('myBox');
  LocalDatabase db = LocalDatabase();
  FirebaseDB dbref = FirebaseDB();

  @override
  void initState() {
    super.initState();
    home = true;
    home_icon = true;

    //check if info has data
    if (_myBox.get("INFO") == null) {
      print("NO DATA YET!!!!");
    }
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          height: screenHeight * 0.08,
          elevation: 5,
          color: Colors.white,
          shadowColor: Colors.black38,
          child: Wrap(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            home = true;
                            details = false;
                            container = 1;
                            print("home");
                            print(container);
                            home_icon = true;
                            details_icon = false;
                          });
                        },
                        child: home_icon
                            ? Icon(
                                Icons.home,
                                size: 30,
                                weight: 3,
                                color: Colors.red.shade400,
                              )
                            : const Icon(Icons.home_outlined,
                                size: 30, weight: 3, color: Colors.black38),
                      ),
                      Text(
                        'Home',
                        textScaler: const TextScaler.linear(0.7),
                        style: TextStyle(
                          color:
                              home_icon ? Colors.red.shade400 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    verticalDirection: VerticalDirection.down,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            home = false;
                            details = false;
                            container = 2;
                            print("set location");
                            print(container);
                            home_icon = false;
                            details_icon = true;
                          });
                        },
                        child: details_icon
                            ? Icon(
                                Icons.phone_callback_rounded,
                                size: 30,
                                weight: 3,
                                color: Colors.red.shade400,
                              )
                            : const Icon(Icons.phone_callback_outlined,
                                size: 30, weight: 3, color: Colors.black38),
                      ),
                      Text(
                        'Hotlines',
                        textScaler: const TextScaler.linear(0.7),
                        style: TextStyle(
                          color: details_icon
                              ? Colors.red.shade400
                              : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: container == 1
            ? const CallEmergency()
            : container == 2
                ? const Hotlines()
                : Container(),
      ),
    );
  }
}
