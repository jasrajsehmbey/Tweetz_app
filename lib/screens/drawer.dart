// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerWidget extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20.00),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 35.00,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                  Image(
                    image: AssetImage('images/menu.png'),
                    height: 30.00,
                    width: 30.00,
                  ),
                ],
              ),
              SizedBox(
                height: 10.00,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.00),
                child: Text(
                  '${user.displayName!}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.00,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.00),
                child: Text(
                  '@${user.displayName!.toLowerCase().replaceAll(' ', '')}',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 15.00,
                  ),
                ),
              ),
              SizedBox(
                height: 30.00,
              ),
              Divider(
                color: Colors.black45,
                thickness: 0.2,
              ),
              SizedBox(height: 10.00),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Image(
                  image: AssetImage(
                    'images/profile.png',
                  ),
                  height: 70.00,
                  width: 120.00,
                ),
              ),
              Image(
                image: AssetImage(
                  'images/drawercards.png',
                ),
                height: 220.00,
                width: 190.00,
              ),
              Divider(
                color: Colors.black45,
                thickness: 0.2,
              ),
              SizedBox(
                height: 10.00,
              ),
              Image(
                image: AssetImage('images/menucards.png'),
              ),
              SizedBox(
                height: 20.00,
              ),
              Image(
                image: AssetImage('images/last.png'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
