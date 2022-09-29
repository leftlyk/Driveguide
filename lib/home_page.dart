
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:geolocator/geolocator.dart';


Future<Position> _determinePosition() async {
  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  bool serviceEnabled;
  LocationPermission permission;

  /// Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    /// Location services are not enabled don't continue
    /// accessing the position and request users of the
    /// App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      /// Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      /// Permissions are denied, next time you could try
      /// requesting permissions again (this is also where
      /// Android's shouldShowRequestPermissionRationale
      /// returned true)
      return Future.error(
          'Location permissions are denied');
    }
  }

  /// When we reach here, permissions are granted and we can
  /// continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
  /// returns the current user position
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class Record{
  /// takes in user data and processes it to be added to the list
  double latitude = 0;
  double longitude = 0;
  String title = "No entry";
  String description = "No entry";
  String imageString = "'PC018007.jpg'";

  Record(double l,double t, String te, String d, String i) {
    /// defining the order of class variables to be
    /// inputted into the records
    latitude = l;
    longitude = t;
    title = te;
    description = d;
    imageString = i;
  }

}

class _HomePageState extends State<HomePage> {


  List locationList = [];
  ///list for storing records

  double accuracyNum = 0.0005; /// accuracy number, currently at 50 m

  /// decimal places  degrees	    distance
  ///       0	          1.0	       111 km
  ///       1	          0.1	       11.1 km
  ///       2	          0.01	     1.11 km
  ///       3	          0.001	     111 m
  ///       4	          0.0001	   11.1 m
  ///       5	          0.00001	   1.11 m

  /// Variables for app on start
  Position? _currentPosition;
  String lat = "Press 'get location'", ltd = "Press 'get location'";
  String messageOutput = "";
  String titleString = "CBHS Tour";
  String buttonText = "Get Location";
  String imageLink = "StartingImg.jpg";

  void BuildRecords() {
    ///making the records

    /// space for test records

    Record temp = Record(-43,272, "title", "Sample", "ShrineImg.jpeg");
    locationList.add(temp);

    temp = Record(-43.5232, 172.5983, "title", "in a hole in the ground there lived", "StartingImg.jpg");
    locationList.add(temp);

    /// end of space for test records



    ///temp = Record(lat, long, "title", "string", "image")

    temp = Record(-43.5242, 172.6011, "Cbhs Straven Block","Christchurch Boys' Straven "
        "block is the home of language and digital technologies, as well as the senior "
        "management team. Whilst the main block is under construction, the Straven Block "
        "serves as a semi-temporary classroom block at the forefront of the school.",
        "StravenBlockImg.jpeg");
    locationList.add(temp);

    temp = Record(-43.5241, 172.6003, "Cbhs Main Building", "Looking ahead, you might miss the "
        "main building, which is currently under construction and its former glory partly "
        "concealed. It's expected to finish construction next year, the process involving"
        " removing the roof and strengthening the supports.", "MainBuildingImg.jpeg");
    locationList.add(temp);

    temp = Record(-43.5227, 172.6002, "Cbhs Shrine", "Erected in 1920, the shrine comemorates "
        "the CBHS Old Boys lost in World War One, forever remembering their service. "
        " Each year the shrine is visited and wreaths are placed upon its steps for "
        "the ANZAC service.", "ShrineImg.jpeg");
    locationList.add(temp);


  }

  Record findLocation(double latNum, double ltdNum) {
      Record r = Record(0,0, "No Location Found", "We couldn't find a "
          "location here. Keep checking what's near!", "LocationNotFound.png");

      /// Go through the list of records and find one that lat and long match
      /// For a match, the lat and long must both be within +/- accuracynum of
      /// the recorded location.

      for (Record value in locationList) {
        if((latNum >= (value.latitude - accuracyNum) && latNum <= (value.latitude + accuracyNum))
            && (ltdNum >= (value.longitude - accuracyNum) && ltdNum <= (value.longitude + accuracyNum))
        ) {
          return value;

          /// returns the entire locationList entry if match is found.

        }

      }

      return r;
  }

  @override
  Widget build(BuildContext context) {

  BuildRecords();
  /// runs buildrecords

    return Scaffold(
      /// front end widgetry
      appBar: AppBar(
      backgroundColor: Colors.white,
        title:
        RichText(
          text: TextSpan(
            text: 'Drive',
            style: TextStyle(color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 30),
            children: const <TextSpan>[
              TextSpan(text: 'guide', style: TextStyle(color: Colors.orange)),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Center(
          child: Text(
              "LAT: ${lat} \n LONG: ${ltd}",
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 13
                )
          ),
          ),
          ),
      ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/$imageLink' //imageLink
            ),
            /// images are formatted so that they can be used in the
            /// image.asset widget on the home page

            SizedBox(height: 20.0),

            Container(
              /// function button
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
                  _determinePosition();
                  /// checks permissions
                  _getCurrentLocation();
                  /// gets the current user lat and long
                  _getLocationProximity();
                  /// compares these with locationList entries
                },

              ),
            ),

            SizedBox(height: 20.0),

            Container(
              /// Title text
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
              /// Scrollable text box
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
    /// Gets the user's current latitude and longitude
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {


        print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');

        if(position == null) {
          lat = "UNKNOWN";
          ltd = "UNKNOWN";

        } else {


          lat = position.latitude.toStringAsFixed(4);
          ltd = position.longitude.toStringAsFixed(4);
          /// returns lat and long as strings

        }

      });
    }).catchError((e) {
      print(e);
    });
  }

  _getLocationProximity() {
    /// gets location proximity to points of interest in locationList
    var latNum = double.parse(lat), ltdNum = double.parse(ltd);
    /// converts strings to floats
    //var userLat = double.parse(inputLat), userLtd = double.parse(inputLtd);

    Record location = findLocation(latNum, ltdNum);

    messageOutput = location.description;
    imageLink = location.imageString;
    titleString = location.title;
    /// outputs from function


  }

}


