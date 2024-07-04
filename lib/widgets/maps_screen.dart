import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final Function(String) onLocationSelected;

  const MapScreen({super.key, required this.onLocationSelected});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? _lastMapPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return;
    }

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _lastMapPosition = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_lastMapPosition != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(_lastMapPosition!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              buildingsEnabled: true,
              trafficEnabled: true,
              zoomControlsEnabled: true,
              rotateGesturesEnabled: true,
              mapToolbarEnabled: true,
              compassEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _lastMapPosition ?? LatLng(0.0, 0.0),
                zoom: 20.0,
              ),
              markers: {
                if (_lastMapPosition != null)
                  Marker(
                    markerId: MarkerId('currentLocation'),
                    position: _lastMapPosition!,
                  )
              },
              onTap: (position) {
                setState(() {
                  _lastMapPosition = position;
                });
              },
            ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () async {
              if (_lastMapPosition != null) {
                List<Placemark> placemarks = await placemarkFromCoordinates(
                  _lastMapPosition!.latitude,
                  _lastMapPosition!.longitude,
                );
                if (placemarks.isNotEmpty) {
                  Placemark place = placemarks[0];
                  String fullAddress =
                      "${place.name}, ${place.subLocality},${place.locality},${place.postalCode}, ${place.country}";
                  widget.onLocationSelected(fullAddress);
                } else {
                  widget.onLocationSelected("No address found");
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }
}
