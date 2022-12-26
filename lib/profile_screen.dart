import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import './model.dart';

class ProfileScreen extends StatefulWidget {
  final Model model;
  const ProfileScreen({super.key, required this.model});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> address = {};
  final Set<Marker> marker = {};
  late final GoogleMapController googleMapController;
  late Position position;

  Future<Position> onMapCreated() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location service diasbled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission denied forever');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  void locationFromAPI() {
    setState(() {
      marker.clear();
      marker.add(
        Marker(
          markerId: MarkerId(widget.model.id.toString()),
          position: LatLng(
            double.parse(address['geo']['lat']),
            double.parse(
              address['geo']['lng'],
            ),
          ),
          infoWindow: const InfoWindow(
            title: "Geolocation",
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    address.addAll(widget.model.address);
    // onMapCreated();
    locationFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    address.addAll(widget.model.address);
    print(address['geo']['lat']);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.name),
      ),
      body: GoogleMap(
        markers: marker,
        onMapCreated: (controller) => googleMapController = controller,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            double.parse(address['geo']['lat']),
            double.parse(
              address['geo']['lng'],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          position = await onMapCreated();

          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude))));

          setState(() {
            marker.add(Marker(
                markerId: MarkerId("current location"),
                position: LatLng(position.latitude, position.longitude)));
          });
        },
        label: const Text('Get Current location'),
      ),
    );
  }
}
