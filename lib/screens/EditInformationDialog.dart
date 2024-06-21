import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:locationfinder/util/database_util.dart';
import 'package:locationfinder/util/snackbar_util.dart';

class EditInformationDialog extends StatefulWidget {
  const EditInformationDialog({super.key});

  @override
  State<EditInformationDialog> createState() => _EditInformationDialogState();
}

List<String> list = <String>['Male', 'Female'];

class _EditInformationDialogState extends State<EditInformationDialog> {
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _policecontroller = TextEditingController();
  TextEditingController _firecontroller = TextEditingController();
  TextEditingController _mdrrmocontroller = TextEditingController();
  String dropdown = list.first;
  LocalDatabase db = LocalDatabase();
  final _myBox = Hive.box('myBox');
  final _box = Hive.openBox('myBox');

  @override
  void initState() {
    // TODO: implement initState
    checkPermission();
    db.loadInfoData();

    _namecontroller.text = db.info[0];
    _policecontroller.text = db.info[2];
    _firecontroller.text = db.info[3];
    _mdrrmocontroller.text = db.info[4];
    dropdown = db.info[5];

    checkKeys();

    super.initState();
  }

  Future checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    return permission;
  }

  void checkKeys() async {
    setState(() {
      var keys = _myBox.keys;
      for (var key in keys) {
        var item = _myBox.get(key);
        print("item: " + item.toString());
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _policecontroller.dispose();
    _firecontroller.dispose();
    _mdrrmocontroller.dispose();
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
                  "Update info",
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
                SizedBox(
                  width: screenWidth * 0.85,
                  child: DropdownButton(
                    borderRadius: BorderRadius.circular(12),
                    iconSize: 20,
                    menuMaxHeight: 120,
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
                          showAlertDialog(context);
                          //Navigator.pop(context);
                        },
                        child: Text(
                          "Update",
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

  showAlertDialog(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    // set up the buttons
    Widget cancelButton = SizedBox(
      width: screenWidth * 0.30,
      child: ElevatedButton(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    Widget continueButton = SizedBox(
      width: screenWidth * 0.30,
      child: ElevatedButton(
        child: const Text("Continue"),
        onPressed: () async {
          String name = _namecontroller.text;
          String police = _policecontroller.text;
          String fire = _firecontroller.text;
          String disaster = _mdrrmocontroller.text;
          String gender = dropdown.toString();
          var infodata = _myBox.get("INFO", defaultValue: []);
          List<String> info;

          print("Infodata: " + infodata.toString());

          if (name.isNotEmpty &&
              police.isNotEmpty &&
              fire.isNotEmpty &&
              disaster.isNotEmpty &&
              gender.isNotEmpty) {
            infodata.add(name, police, fire, disaster, gender);
            _myBox.put("INFO", infodata);
            setState(() {
              _namecontroller.clear();
              _policecontroller.clear();
              _firecontroller.clear();
              _mdrrmocontroller.clear();
              dropdown = list.first;
            });

            SnackbarUtil.showSnackbar(context, "Successfully submitted", 1);
            Navigator.pop(context);
            //Navigator.pop(context);
          } else {
            SnackbarUtil.showSnackbar(
                context, "Fill all required fields to start", 1);
          }
        },
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "AlertDialog",
        style: TextStyle(fontFamily: 'Spo tify'),
      ),
      content: Text(
        "Would you like to continue to update info? This will overwrite the existing data.",
        style: TextStyle(fontFamily: 'Spotify'),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
