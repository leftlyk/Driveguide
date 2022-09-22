
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
  String title = "No entry";
  String description = "No entry";
  String imageString = "'PC018007.jpg'";

  Record(double l,double t, String te, String d, String i) {
    latitude = l;
    longitude = t;
    title = te;
    description = d;
    imageString = i;
  }

}

class _HomePageState extends State<HomePage> {


  List locationList = [];

  double accuracyNum = 0.0005; ///50 metres

  /// decimal places  degrees	    distance
  ///       0	          1.0	       111 km
  ///       1	          0.1	       11.1 km
  ///       2	          0.01	     1.11 km
  ///       3	          0.001	     111 m
  ///       4	          0.0001	   11.1 m
  ///       5	          0.00001	   1.11 m

  Position? _currentPosition;
  String lat = "Press 'get location'", ltd = "Press 'get location'";
  //String inputLat = "", inputLtd = "";
  String messageOutput = "";
  String titleString = "CBHS Tour";
  String buttonText = "Get Location";
  String imageLink = "StartingImg.jpg";

  void BuildRecords() {
    //tempLocation.latitude = 50;
    Record temp = Record(-43,272, "title", "Sample", "ShrineImg.jpeg");
    locationList.add(temp);
    /// space for test records

    ///temp = Record(0,0, "string", "image")

    temp = Record(-43.5242, 172.6011, "Cbhs Straven Block","Christchurch Boys' Straven"
        "block is the home of language and digital technologies, as well as the senior"
        "management team.", "StravenBlockImg.jpeg");
    locationList.add(temp);

    temp = Record(-43.5241, 172.6003, "Cbhs Main Building", "Looking ahead, you might miss the "
        "main building, which is currently under construction and its former glory partly "
        "concealed.", "MainBuildingImg.jpeg");
    locationList.add(temp);

    temp = Record(-43.5227, 172.6002, "Cbhs Shrine", "Erected in 1920, the shrine comemorates"
        "the CBHS Old Boys lost in World War One, forever remembering their service.", "ShrineImg.jpeg");
    locationList.add(temp);


    /// end of space for test records
  }

  Record findLocation(double latNum, double ltdNum) {
      Record r = Record(0,0, "TITLE", "UNKNOWN", "");

      /// Go through the list of records and find one that lat and long match

      for (Record value in locationList) {
        if((latNum >= (value.latitude - accuracyNum) && latNum <= (value.latitude + accuracyNum))
            && (ltdNum >= (value.longitude - accuracyNum) && ltdNum <= (value.longitude + accuracyNum))
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
        title: Text('Driveguide',
            style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 30)
        ),
        backgroundColor: Colors.white,

      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/$imageLink' //imageLink
            ),
            SizedBox(height: 20.0),
        Container(
          margin: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          child: Text(
                "LAT: ${lat} \nLONG: ${ltd}",
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 30)
              ),
        ),

            SizedBox(height: 20.0),


            Container(
              margin: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                ),
                child: Text(buttonText,
                    style: TextStyle(
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)
                ),
                onPressed: () {
                  buttonText = "What's Near Me?";
                  _getCurrentLocation();
                  _getLocationProximity();
                },

              ),
            ),

            SizedBox(height: 20.0),

            Container(
              margin: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
              //color: Colors.red,
              child: Text(titleString, style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),

            SizedBox(height: 20.0),

            Expanded(
              flex: 1,
              child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,//.horizontal
                padding: EdgeInsets.fromLTRB(5, 5, 0, 10),
              child: new Text(messageOutput,
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)
              ),
            ),
            ),
          ],
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
          //lat = position.latitude.toString();
          //ltd = position.longitude.toString();

          lat = position.latitude.toStringAsFixed(4);
          ltd = position.longitude.toStringAsFixed(4);

        }

      });
    }).catchError((e) {
      print(e);
    });
  }

  _getLocationProximity() {
    var latNum = double.parse(lat), ltdNum = double.parse(ltd);
    /// converts strings to floats and then rounds them to 4 dp
    //var userLat = double.parse(inputLat), userLtd = double.parse(inputLtd);

    Record location = findLocation(latNum, ltdNum);

    messageOutput = location.description;
    imageLink = location.imageString;
    titleString = location.title;


  }

}


