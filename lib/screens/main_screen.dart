// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tweetz/google_sign_in.dart';
import 'package:tweetz/screens/tweet_page.dart';
import 'package:tweetz/components/tweet_card.dart';

final _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TweetPage(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: Drawer(
        child: DrawerWidget(),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: CircleAvatar(
                      radius: 13.00,
                      backgroundImage: NetworkImage(user.photoURL!),
                    ));
              },
            ),
            Icon(
              FontAwesomeIcons.twitter,
              color: Colors.blue,
            ),
            IconButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSign>(context, listen: false);
                provider.logout();
              },
              icon: Icon(
                Icons.logout_rounded,
                color: Colors.black87,
                size: 20.00,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.00),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(
                image: AssetImage('images/home.png'),
                width: 45.00,
                height: 45.00,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 60.00),
                child: Image(
                  image: AssetImage('images/search.png'),
                  width: 42.00,
                  height: 42.00,
                ),
              ),
              Image(
                image: AssetImage('images/bell.png'),
                width: 40.00,
                height: 40.00,
              ),
              Image(
                image: AssetImage('images/mail.png'),
                width: 41.00,
                height: 41.00,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStream(),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  int getLikeCount(Map like) {
    if (like == null) {
      return 0;
    }
    int count = 0;
    like.values.forEach((element) {
      if (element == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        final messages = snapshot.data?.docs.reversed;
        List<TweetCards> tweetBubbles = [];
        for (var message in messages!) {
          var data = message.data() as Map;
          final messageText = data['text'];
          final messageSender = data['sender'];
          final messagePhoto = data['photo'];
          final imageUrl = data['fileUrl'];
          final like = data['likes'];
          final messageId = message.id;
          final likecount = getLikeCount(like);
          try {
            final time = data['time'];
            final tweet = TweetCards(
              message: messageText,
              name: messageSender,
              photo: messagePhoto,
              image: imageUrl,
              time: time,
              likes: like,
              isLiked: like[user.displayName!] ?? false,
              messageId: messageId,
              likeCount: likecount,
              user: user,
            );
            tweetBubbles.add(tweet);
          } catch (e) {
            print(e);
          }
        }
        return Expanded(
          child: ListView(
            children: tweetBubbles,
          ),
        );
      },
    );
  }
}
