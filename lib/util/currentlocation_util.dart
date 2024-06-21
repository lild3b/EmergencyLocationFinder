import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geodesy/geodesy.dart';
import 'package:locationfinder/util/database_util.dart';
import 'package:telephony/telephony.dart';

class LocationUtil {
  static const double policeStationLatitude =
      7.364482272842179; //7.364482272842179, 125.85354413189678
  static const double policeStationLongitude = 125.85354413189678;
  static const double fireStationLatitude =
      7.364919002644807; //7.364919002644807, 125.85378415084095
  static const double fireStationLongitude = 125.85378415084095;
  static const double MDRRMO_StationLatitude =
      7.3654133702557925; //7.3654133702557925, 125.85411549566062
  static const double MDRRMO_StationLongitude = 125.85411549566062;
  static const String stationAddress =
      "Purok Ernand, Brgy. Binuangan, Maco, Davao de Oro";
  static String address = "";

  static Future<Position> getCurrentLocation() async {
    // Check if location services are enabled
    LocalDatabase db = new LocalDatabase();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    // Check if permissions are granted
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }
    Position pos = await Geolocator.getCurrentPosition();
    print("Current Position: $pos");
    db.setCurrentLoc(pos.latitude, pos.longitude);

    //db.setCurrentAddress(address);

    // Get current location
    return await Geolocator.getCurrentPosition();
  }

  static Future<List<String>> searchLocations(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      return locations.map((location) => location.toString()).toList();
    } catch (e) {
      return ['Error: $e'];
    }
  }

  static Future<double> getDistanceToStation(
      double stationLatitude, double stationLongitude) async {
    try {
      Position currentPosition = await getCurrentLocation();
      double currentLatitude = currentPosition.latitude;
      double currentLongitude = currentPosition.longitude;

      print(
          "offline currentLatitude = $currentLatitude, currentLongitude = $currentLongitude");

      // Calculate distance between current location and station
      final Distance distance = Distance();
      double meters = distance(LatLng(currentLatitude, currentLongitude),
          LatLng(stationLatitude, stationLongitude));

      // Convert meters to kilometers
      double kilometers = meters / 1000;

      return kilometers;
    } catch (e) {
      return -1; // Return a negative value to indicate an error
    }
  }
}

class SMS {
  static smsPermission() async {
    final Telephony telephony = Telephony.instance;
    return await telephony.requestPhoneAndSmsPermissions;
  }
}
