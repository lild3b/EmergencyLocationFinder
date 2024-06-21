import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locationfinder/screens/tabs/mainwindow.dart';
import 'package:locationfinder/util/database_util.dart';
import 'package:locationfinder/util/snackbar_util.dart';

class InformationDialog extends StatefulWidget {
  const InformationDialog({super.key});

  @override
  State<InformationDialog> createState() => _InformationDialogState();
}

List<String> list = <String>['Male', 'Female'];

class _InformationDialogState extends State<InformationDialog> {
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _policecontroller = TextEditingController();
  TextEditingController _firecontroller = TextEditingController();
  TextEditingController _mdrrmocontroller = TextEditingController();
  TextEditingController _deviceidcontroller = TextEditingController();
  String dropdown = list.first;
  LocalDatabase db = LocalDatabase();

  @override
  void initState() {
    // TODO: implement initState
    checkPermission();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    return permission;
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _policecontroller.dispose();
    _firecontroller.dispose();
    _mdrrmocontroller.dispose();
    _deviceidcontroller.dispose();
    super.dispose();
  }

  void dropDown(String? value) {
    if (value is String) {
      setState(() {
        dropdown = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              width: screenWidth * 1,
              height: screenHeight * 1,
              alignment: Alignment.center,
              child: Column(children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Add info to start",
                  style: TextStyle(fontFamily: 'Spotify', fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
                Form(
                  //width: screenWidth * 0.8,
                  child: TextField(
                    // NAME
                    decoration: InputDecoration(
                      labelText: 'Enter name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    controller: _namecontroller,
                    maxLength: 10,
                  ),
                ),
                Wrap(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.4,
                      child: DropdownButton(
                        borderRadius: BorderRadius.circular(12),
                        iconSize: 20,
                        //menuMaxHeight: 50,
                        isExpanded: true,
                        value: dropdown,
                        items: [
                          DropdownMenuItem<String>(
                            child: Text(
                              "Male",
                            ),
                            value: "Male",
                            onTap: () {},
                          ),
                          DropdownMenuItem<String>(
                            child: Text(
                              "Female",
                            ),
                            value: "Female",
                            onTap: () {},
                          )
                        ],
                        onChanged: dropDown,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: screenWidth * 0.45,
                        child: TextField(
                          // POLICE HOTLINE
                          decoration: InputDecoration(
                            labelText: 'Enter Device ID',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          controller: _deviceidcontroller,
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  //width: screenWidth * 0.8,
                  child: TextField(
                    // POLICE HOTLINE
                    decoration: InputDecoration(
                      labelText: 'Police Hotline',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    controller: _policecontroller,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                  ),
                ),
                Form(
                  //width: screenWidth * 0.8,
                  child: TextField(
                    // FIRE HOTLINE
                    decoration: InputDecoration(
                      labelText: 'Fire Hotline',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    controller: _firecontroller,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                  ),
                ),
                Form(
                  //width: screenWidth * 0.8,
                  child: TextField(
                    // DISASTER HOTLINE
                    decoration: InputDecoration(
                      labelText: 'MDRRMO Hotline',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    controller: _mdrrmocontroller,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                  ),
                ),
                Wrap(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          alignment: Alignment.center,
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.red.shade400),
                        ),
                        onPressed: () {
                          String name = _namecontroller.text;
                          String deviceinfo = _deviceidcontroller.text;
                          String police = _policecontroller.text;
                          String fire = _firecontroller.text;
                          String disaster = _mdrrmocontroller.text;
                          String gender = dropdown.toString();

                          if (name.isNotEmpty &&
                              police.isNotEmpty &&
                              fire.isNotEmpty &&
                              disaster.isNotEmpty &&
                              gender.isNotEmpty) {
                            print(name);
                            print(deviceinfo);
                            print(police);
                            print(fire);
                            print(disaster);
                            db.updateInfo(name, deviceinfo, police, fire,
                                disaster, gender);
                            _namecontroller.clear();
                            _deviceidcontroller.clear();
                            _policecontroller.clear();
                            _firecontroller.clear();
                            _mdrrmocontroller.clear();
                            dropdown = list.first;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainWindow()),
                            );
                            //Navigator.pop(context);
                          } else {
                            SnackbarUtil.showSnackbar(context,
                                "Fill all required fields to start", 1);
                          }
                        },
                        child: Text(
                          "Start",
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Spotify'),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.grey.shade300)),
                        onPressed: () {
                          setState(() {
                            _namecontroller.clear();
                            _policecontroller.clear();
                            _firecontroller.clear();
                            _mdrrmocontroller.clear();
                            dropdown = list.first;
                          });
                        },
                        child: Text(
                          "Clear",
                          style: TextStyle(
                              color: Colors.red.shade400,
                              fontFamily: 'Spotify'),
                        )),
                  ],
                )
              ])),
        ),
      ),
    );
  }
}
