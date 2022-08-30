
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:geolocator/geolocator.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error(
          'Location permissions are denied');
    }
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _currentPosition;
  String lat = "X2", ltd = "Y2";
  String inputLat = "", inputLtd = "";


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        Text(
              "LAT: ${lat} LONG: ${ltd}"

                //"VALUES"
            ),
            TextButton(
              child: Text('Get Location'),
              onPressed: () {
                _getCurrentLocation();
                _getLocationProximity();


              },
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter latitude"),
              onChanged: (text) => setState(() {
                inputLat = text;
              }),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter longitude"),
              onChanged: (text) => setState(() {
                inputLtd = text;
              }),
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {


        print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');

        if(position == null) {
          lat = "UNKNOWN";
          ltd = "UNKNOWN";
        //  print(_currentPosition.longitude.toString());
        //  print(_currentPosition.latitude.toString());
        } else {
          lat = position.latitude.toString();
          ltd = position.longitude.toString();
        }

      });
    }).catchError((e) {
      print(e);
    });
  }

  _getLocationProximity() {

    var latNum = double.parse(lat), ltdNum = double.parse(ltd);
    var userLat = double.parse(inputLat), userLtd = double.parse(inputLtd);

    if((latNum >= (userLat - 1) && latNum <= (userLat + 1))
    && (ltdNum >= (userLtd - 1) && ltdNum <= (userLtd + 1))
    ) {
      print("You're within proximity of CBHS!");

    } else {
      print("You're not within proximity of CBHS.");
    }
  }

}


