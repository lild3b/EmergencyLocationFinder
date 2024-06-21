import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationfinder/util/currentlocation_util.dart';

class SetLocation extends StatefulWidget {
  const SetLocation({super.key});

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  final double _zoom = 16.5;

  LatLng startAddress = const LatLng(7.447638219795291, 125.80952692699331);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _markers = {};
    _searchCurrentLocation();
  }

  void _searchCurrentLocation() async {
    try {
      Position position = await LocationUtil.getCurrentLocation();
      mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        16.5,
      ));
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId("current_location"),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: "Current Location"),
          ),
        );
      });
    } catch (e) {
      print("Error searching current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade400,
        title: const Text(
          "Google Maps Search",
          style: TextStyle(fontFamily: 'Spotify', color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(
                target: startAddress,
                zoom: _zoom,
              ),
              markers: _markers,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _searchCurrentLocation();
        },
        backgroundColor: Colors.red.shade400,
        child: const Icon(
          Icons.my_location,
          color: Colors.white,
        ),
      ),
    );
  }
}
