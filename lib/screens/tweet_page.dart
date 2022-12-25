// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tweetz/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;

class TweetPage extends StatefulWidget {
  const TweetPage({Key? key}) : super(key: key);

  @override
  State<TweetPage> createState() => _TweetPageState();
}

class _TweetPageState extends State<TweetPage> {
  String message = '';
  String imageUrl = '';
  bool spinner = false;
  Map<String, bool> likes = {};

  PlatformFile? pickedfile = null;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    setState(() {
      pickedfile = result?.files.first;
    });
    setState(() {
      spinner = true;
    });
    if (pickedfile == null) {
      setState(() {
        spinner = false;
      });
      return;
    }
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'images/$uniqueName';
    final file = File(pickedfile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    imageUrl = url.toString();
    setState(() {
      spinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.00),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 30.00,
                            ),
                          ),
                          Material(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(80.00),
                            elevation: 5.00,
                            child: MaterialButton(
                              onPressed: () {
                                _firestore.collection('messages').add({
                                  'text': message,
                                  'sender': user.displayName!,
                                  'photo': user.photoURL!.toString(),
                                  'time': FieldValue.serverTimestamp(),
                                  'fileUrl': imageUrl,
                                  'id': user.email!,
                                  'likes': likes,
                                });
                                Navigator.pop(context);
                              },
                              height: 20.00,
                              minWidth: 100.00,
                              child: Text(
                                'Tweet',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.00,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.00,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.00),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20.00,
                            backgroundImage: NetworkImage(user.photoURL!),
                          ),
                          Image(
                            image: AssetImage('images/public.png'),
                            height: 50.00,
                            width: 100.00,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.00),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 220),
                        child: TextField(
                          scrollController: ScrollController(),
                          onChanged: (value) {
                            message = value;
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.00,
                          ),
                          decoration: kTextFieldDecorations,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          autofocus: true,
                          autocorrect: true,
                        ),
                      ),
                    ),
                    if (pickedfile != null)
                      Container(
                        child: Image.file(
                          File(pickedfile!.path!),
                          width: double.infinity,
                          height: 150,
                        ),
                      ),
                  ],
                ),
                Container(
                  height: 80.00,
                  width: double.infinity,
                  decoration: kBoxDecorations,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: selectFile,
                          icon: Icon(
                            FontAwesomeIcons.image,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                          onPressed: selectFile,
                          icon: Image(
                            image: AssetImage('images/gif.png'),
                            height: 25.00,
                            width: 25.00,
                          ),
                        ),
                        Image(
                          image: AssetImage('images/poll.png'),
                          height: 25.00,
                          width: 25.00,
                        ),
                        Image(
                          image: AssetImage('images/location.png'),
                          height: 25.00,
                          width: 25.00,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
