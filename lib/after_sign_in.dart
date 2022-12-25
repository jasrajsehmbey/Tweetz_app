// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_screen.dart';

class AfterSignIn extends StatelessWidget {
  const AfterSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return MainScreen();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Something Went Wrong'),
            );
          } else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}
