import 'dart:js';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_first_app/activities.dart';
import 'package:flutter_first_app/profile.dart';
import 'package:flutter_first_app/login.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIAGED',
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/activities': (context) => ActivitiesPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
