import 'package:flutter/material.dart';
import 'home_page.dart';
//import 'homePageWireframe.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocator Demo',
      home: HomePage(),
    );
  }
}


