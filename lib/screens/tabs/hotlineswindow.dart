import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:locationfinder/screens/EditInformationDialog.dart';
import 'package:locationfinder/util/database_util.dart';

class Hotlines extends StatefulWidget {
  const Hotlines({super.key});

  @override
  State<Hotlines> createState() => _HotlineState();
}

List<String> list = ['Flood', 'Fire', 'Robbery', 'Missing Person', 'Chemical'];

class _HotlineState extends State<Hotlines> {
  final myBox = Hive.openBox('myBox');
  final _myBox = Hive.box('myBox');
  LocalDatabase db = LocalDatabase();
  bool status = false;
  late TextEditingController _name;
  late TextEditingController _firecontroller;
  late TextEditingController _policecontroller;
  late TextEditingController _disastercontroller;

  @override
  void initState() {
    // TODO: implement initState
    db.loadInfoData();

    if (_myBox.get("INFO") != null) {
      status = true;
    }
    _name = TextEditingController(text: db.info[0]);
    _policecontroller = TextEditingController(text: db.info[2]);
    _firecontroller = TextEditingController(text: db.info[3]);
    _disastercontroller = TextEditingController(text: db.info[4]);

    print("db info: " + db.info[0]);

    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _firecontroller.dispose();
    _policecontroller.dispose();
    _disastercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //List<String> hotlineNumbers = HotlineNumberUtility.getHotlineNumbers();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 50,
          title: const Text(
            'Hotlines',
            style: TextStyle(
              fontFamily: 'Spotify',
              fontSize: 30,
            ),
          ),
          actions: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                alignment: Alignment.center,
                //height: 35,
                //width: 35,
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EditInformationDialog()));
                      /*showDialog(
                        context: context,
                        builder: (context) {
                          return dialog();
                        },
                      ); */
                    });
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.penToSquare,
                    size: 30,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(top: 15),
                  width: screenWidth,
                  height: screenHeight * 0.45,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red.shade400),
                        child: ListTile(
                          title: Text(
                            "Fire Hotline: ${_firecontroller.text}",
                            style: const TextStyle(
                                fontFamily: 'Spotify', color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red.shade400),
                        child: ListTile(
                          title: Text(
                            "Police Hotline: ${_policecontroller.text}",
                            style: const TextStyle(
                                fontFamily: 'Spotify', color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red.shade400),
                        child: ListTile(
                          title: Text(
                            "Disaster Hotline: ${_disastercontroller.text}",
                            style: const TextStyle(
                                fontFamily: 'Spotify', color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  dialog() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          width: screenWidth * 0.7,
          height: screenHeight * 0.81,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Update info",
                style: TextStyle(
                    fontFamily: 'Spotify', color: Colors.black, fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                // FIRE HOTLINE
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _name,
                maxLength: 10,
                onChanged: (value) {
                  value = _name.text;
                },
              ),
              TextFormField(
                // FIRE HOTLINE
                decoration: InputDecoration(
                  labelText: "Police Hotline",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _policecontroller,
                keyboardType: TextInputType.number,
                maxLength: 11,
                onChanged: (value) {
                  value = _policecontroller.text;
                },
              ),
              TextFormField(
                // FIRE HOTLINE
                decoration: InputDecoration(
                  labelText: "Fire Hotline",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _firecontroller,
                keyboardType: TextInputType.number,
                maxLength: 11,
                onChanged: (value) {
                  value = _firecontroller.text;
                },
              ),
              TextFormField(
                // FIRE HOTLINE
                decoration: InputDecoration(
                  labelText: "MDDRMO Hotline",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _disastercontroller,
                keyboardType: TextInputType.number,
                maxLength: 11,
                onChanged: (value) {
                  value = _disastercontroller.text;
                },
              ),
              Container(
                alignment: Alignment.center,
                child: Wrap(
                  runSpacing: 1,
                  direction: Axis.horizontal,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red.shade400)),
                        onPressed: () {
                          _myBox.clear();
                          String name = _name.text;
                          String police = _policecontroller.text;
                          String fire = _firecontroller.text;
                          String disaster = _disastercontroller.text;
                          setState(() {
                            //db.updateInfo(name, police, fire, disaster)
                            final val = InfoModel(
                                name: name,
                                police: police,
                                fire: fire,
                                disaster: disaster);

                            Hive.box('myBox').putAt(0, val);
                            _name.clear();
                            _policecontroller.clear();
                            _firecontroller.clear();
                            _disastercontroller.clear();
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          "Update",
                          style: TextStyle(
                              fontFamily: 'Spotify',
                              color: Colors.white,
                              fontSize: 12),
                        )),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red.shade400)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              fontFamily: 'Spotify',
                              color: Colors.white,
                              fontSize: 12),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
