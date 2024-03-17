import 'package:JOBHUB/profilescreens/workersprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

// ignore: camel_case_types
class commentsWidget extends StatefulWidget {
  final String commentid;
  final String commenterid;
  final String commentName;
  final String commentBody;
  final String commenterImageUrl;
  final String userid;
  const commentsWidget(
      {super.key,
      required this.userid,
      required this.commenterid,
      required this.commentid,
      required this.commentBody,
      required this.commentName,
      required this.commenterImageUrl});

  @override
  State<commentsWidget> createState() => _commentsWidgetState();
}

// ignore: camel_case_types
class _commentsWidgetState extends State<commentsWidget> {
  bool? profcheck = true;

  final List<Color> _colors = [
    Colors.amber,
    Colors.orange,
    Colors.pink.shade200,
    Colors.brown,
    Colors.cyan,
    Colors.blueAccent,
    Colors.deepOrange
  ];
  @override
  Widget build(BuildContext context) {
    void proilecheck() {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      final uid = user!.uid;
      if (uid == widget.userid) {
        setState(() {
          profcheck = true;
          print("profcheck:${profcheck}");
          print(uid);
          print(widget.userid);
        });
      } else {
        setState(() {
          profcheck = false;
        });
      }
    }

    _colors.shuffle();
    return InkWell(
      onTap: () {
        FirebaseAuth auth = FirebaseAuth.instance;
        User? user = auth.currentUser;
        final uid = user!.uid;
        if (uid != widget.userid) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                userId: widget.commenterid,
                isWorker: true,
              ),
            ),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: _colors[1]),
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(widget.commenterImageUrl),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.commentName,
                    style: const TextStyle(
                        fontStyle: FontStyle.normal,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    widget.commentBody,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 16),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
