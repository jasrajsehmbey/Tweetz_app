// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'main_screen.dart';
import 'package:provider/provider.dart';
import 'package:tweetz/google_sign_in.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Color color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 50.00),
            child: IconButton(
              onPressed: () {
                setState(() {
                  color = color == Colors.blue ? Colors.black54 : Colors.blue;
                });
              },
              icon: Icon(
                FontAwesomeIcons.twitter,
                size: 90.00,
                color: color,
              ),
            ),
          ),
          SizedBox(
            height: 70.00,
            width: double.infinity,
          ),
          SizedBox(
            height: 60.00,
            width: 250.00,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSign>(context, listen: false);
                provider.googleLogin();
              },
              icon: Icon(
                FontAwesomeIcons.google,
                color: Colors.white,
              ),
              label: Text(
                '   Sign in with Google',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.00,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
