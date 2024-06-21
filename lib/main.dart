import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:locationfinder/screens/InformationDialog.dart';
import 'package:locationfinder/screens/tabs/mainwindow.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(Duration(seconds: 1));
  FlutterNativeSplash.remove();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyCsfA2O8SQTwvGKcomXkdVlIROzuqVup7U',
    appId: '1059127081872',
    messagingSenderId: '1:1059127081872:android:bbf7a2c20c2cad7c5e1115',
    projectId: 'emergency-location-finde-a8887',
    storageBucket: 'emergency-location-finde-a8887.appspot.com',
  ));
  await Hive.initFlutter();

  // open a box
  var box = await Hive.openBox("myBox");
  final myBox = Hive.box('myBox');
  bool status = false;

  if (myBox.get("INFO") != null) {
    status = true;
    print(status);
  } else {
    status = false;
    print(status);
  }

  runApp(MyApp(status: status));
}

class MyApp extends StatelessWidget {
  final bool status;
  const MyApp({Key? key, required this.status}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: status ? const MainWindow() : const InformationDialog(),
    );
  }
}
