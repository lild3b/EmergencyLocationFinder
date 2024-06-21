class InfoNumberUtility {
  static String _policehotline = "";
  static String _firehotline = "";
  static String _disasterhotline = "";
  static String _name = '';
  static double lat = 0.0;
  static double long = 0.0;

  static void addPoliceHotline(String number) {
    _policehotline = number;
  }

  static String getPoliceHotline() {
    return _policehotline;
  }

  static void addFireHotline(String number) {
    _firehotline = number;
  }

  static String getFireHotline() {
    return _firehotline;
  }

  static void addDisasterHotline(String number) {
    _disasterhotline = number;
  }

  static String getDisasterHotline() {
    return _disasterhotline;
  }

  static void setName(String name) {
    _name = name;
  }

  static String getName() {
    return _name;
  }

  static void setLat(double lat) {
    lat = lat;
  }

  static double getLat() {
    return lat;
  }

  static void setLong(double long) {
    long = long;
  }

  static double getLong() {
    return long;
  }
}

class Info {
  static bool infoCheck = false;

  static bool checkInfo() {
    if (InfoNumberUtility.getName().isNotEmpty) {
      infoCheck = true;
    } else {
      infoCheck = false;
    }
    return infoCheck;
  }
}
