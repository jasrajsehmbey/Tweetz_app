// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;

final _firestore = FirebaseFirestore.instance;

class TweetCards extends StatefulWidget {
  TweetCards({
    Key? key,
    required this.message,
    required this.name,
    required this.photo,
    required this.image,
    required this.time,
    required this.likes,
    required this.isLiked,
    required this.messageId,
    required this.likeCount,
    required this.user,
  }) : super(key: key);

  final String message;
  final String name;
  final String photo;
  final String image;
  final Timestamp time;
  final Map likes;
  final user;
  final String messageId;
  bool isLiked;
  int likeCount;

  @override
  State<TweetCards> createState() => _TweetCardsState();
}

class _TweetCardsState extends State<TweetCards> {
  handelLikeMessages() async {
    bool _isLiked = await widget.likes[widget.user.displayName!] == true;
    if (_isLiked) {
      setState(() {
        widget.likeCount -= 1;
        widget.isLiked = false;
        widget.likes[widget.user.displayName!] = false;
        _firestore
            .collection('messages')
            .doc(widget.messageId)
            .update({'likes.${widget.user.displayName!}': false});
      });
    } else if (!_isLiked) {
      setState(() {
        widget.likeCount += 1;
        widget.isLiked = true;
        widget.likes[widget.user.displayName!] = true;
        _firestore
            .collection('messages')
            .doc(widget.messageId)
            .update({'likes.${widget.user.displayName!}': true});
      });
    }
  }

  String getTimeAgo() =>
      timeago.format(DateTime.parse(widget.time.toDate().toString()));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26, width: .30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 23.00,
                      backgroundImage: NetworkImage(widget.photo),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.00),
                    child: Text(
                      '${widget.name} ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.00,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.00),
                    child: Text(
                      ' @${widget.name.toLowerCase().replaceAll(' ', '')}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 10.00,
                      ),
                    ),
                  ),
                  if (widget.time != null)
                    Padding(
                      padding: EdgeInsets.only(top: 10.00),
                      child: Text(
                        ' .  ${getTimeAgo()}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 10.00,
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.00, right: 10.00),
                child: Icon(
                  Icons.more_vert_outlined,
                  color: Colors.black,
                  size: 15.00,
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 50.00, bottom: 20.00, right: 15.00),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.00,
                  ),
                ),
                SizedBox(
                  height: 15.00,
                ),
                if (widget.image != '')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: NetworkImage(widget.image),
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.00),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(
                  image: AssetImage('images/comment.png'),
                  height: 22.00,
                  width: 22.00,
                ),
                Image(
                  image: AssetImage('images/save.png'),
                  height: 25.00,
                  width: 25.00,
                ),
                LikeButton(
                  size: 25.00,
                  isLiked: widget.isLiked,
                  likeCount: widget.likeCount,
                  onTap: (isLiked) async {
                    handelLikeMessages();
                    return !isLiked;
                  },
                  likeBuilder: (isLiked) {
                    if (widget.isLiked) {
                      return Icon(Icons.favorite,
                          color: Colors.pink, size: 23.00);
                    } else {
                      return Icon(Icons.favorite_border,
                          color: Colors.black54, size: 23.00);
                    }
                  },
                ),
                Image(
                  image: AssetImage('images/share.png'),
                  height: 20.00,
                  width: 20.00,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Row(
// crossAxisAlignment: CrossAxisAlignment.end,
// children: [
// GestureDetector(
// onTap: handelLikeMessages,
// child: Icon(
// widget.isLiked ? Icons.favorite : Icons.favorite_border,
// size: 22.00,
// color: widget.isLiked ? Colors.pink : Colors.black54,
// ),
// ),
// Text('${widget.likeCount}'),
// ],
// ),
// ${widget.time.toDate().day}-${widget.time.toDate().month}-${widget.time.toDate().year}   ${widget.time.toDate().hour}:${widget.time.toDate().minute}
