import 'package:JOBHUB/profilescreens/workersprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class workersWidget extends StatefulWidget {
  final String userName;
  final String email;
  final String uid;
  final String userImage;
  final String phoneNumber;
  final String prof;
  final String img;
  final bool check;
  final String id;

  final Timestamp createdAt;

  final bool isWorker;
  const workersWidget(
      {super.key,
      required this.id,
      required this.isWorker,
      required this.createdAt,
      required this.check,
      required this.img,
      required this.prof,
      required this.email,
      required this.uid,
      required this.userName,
      required this.userImage,
      required this.phoneNumber});

  @override
  State<workersWidget> createState() => _workersWidgetState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

// ignore: camel_case_types
class _workersWidgetState extends State<workersWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        color: Colors.blueGrey,
        shadowColor: const Color.fromARGB(25, 216, 230, 110),
        elevation: 15,
        child: ListTile(
          onLongPress: () {},
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                          isWorker: true,
                          userId: widget.id,
                        )));
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: const Color(0xFFECE5B6),
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(widget.userImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFECE5B6),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4), // Decreased vertical space here
                    Text(
                      widget.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Text(
            widget.prof,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
