
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

class Record{
  double latitude = 0;
  double longitude = 0;
  String description = "No entry";

  Record(double l,double t, String d) {
    latitude = l;
    longitude = t;
    description = d;
  }

}

class _HomePageState extends State<HomePage> {


  List locationList = [];
  //var locationList = new List.generate(0, (index) => null);



 /* Record tempLocation1 = Record(-43,172,"Hi");
  Record tempLocation[2] = Record(-43,172,"Hi");
  Record tempLocation[3] = Record(-43,172,"Hi");
*/

  Position? _currentPosition;
  String lat = "X2", ltd = "Y2";
  //String inputLat = "", inputLtd = "";
  String messageOutput = "";

  void BuildRecords() {
    //tempLocation.latitude = 50;
    Record temp = Record(-43,272,"Hi");
    locationList.add(temp);

    temp = Record(-43,172,"Option 2");
    locationList.add(temp);
  }

  Record findLocation(double latNum, double ltdNum) {
      Record r = Record(0,0, "UNKNOWN");

      for (Record value in locationList) {
        if((latNum >= (value.latitude - 1) && latNum <= (value.latitude + 1))
            && (ltdNum >= (value.longitude - 1) && ltdNum <= (value.longitude + 1))
        ) {
          return value;

        }

      }

      return r;
  }

  @override
  Widget build(BuildContext context) {

  BuildRecords();

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
            /*
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
            SizedBox(
              height: 20,
            ),

             */
            Text(messageOutput),
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
    //var userLat = double.parse(inputLat), userLtd = double.parse(inputLtd);

    Record location = findLocation(latNum, ltdNum);

    messageOutput = location.description;

    // Go through the list of records and find one that lat and long match
    //var userLat = location.latitude, userLtd = location.longitude;

    /*
    if((latNum >= (userLat - 1) && latNum <= (userLat + 1))
    && (ltdNum >= (userLtd - 1) && ltdNum <= (userLtd + 1))
    ) {
      messageOutput = location.description;

    } else {
      messageOutput = "You're not within proximity of CBHS.";
    }

     */
  }

}


