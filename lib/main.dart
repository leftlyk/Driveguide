import 'package:flutter/material.dart';
import 'home_page.dart';
import 'dart:async';
import 'dart:io';

/// main file that runs the pages

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocator Demo',
      home: HomePage(),
      /// runs homepage.dart
    );
  }
}


