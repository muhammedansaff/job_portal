import 'package:JOBHUB/Widgets/bottom_nav_bar.dart';
import 'package:JOBHUB/refractor/materialbutton.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  String phoneNumber = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isloading = true;
  bool _isSameUser = false;

  @override
  void initState() {
    super.initState();
    getUserDataProfile();
  }

  void getUserDataProfile() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });

        setState(() {
          _isloading = false; // Update loading state after data fetch
        });
      } else {
        // Document doesn't exist
        setState(() {
          _isloading = false; // Update loading state after data fetch
        });
      }
    } catch (error) {
      // Handle error
      setState(() {
        User? user = auth.currentUser;
        final _uid = user!.uid;
        _isloading = false; // Update loading state after error
        print(_isSameUser);
        _isSameUser = _uid == widget.userId;
        print(name);
      });
    }
  }

  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.black,
        ),
        Text(
          content,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSameUser
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomNav()));
                },
                icon: const Icon(Icons.close),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: const Padding(
                padding: EdgeInsets.only(left: 70),
                child: Text('My Profile'),
              ),
            )
          : AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomNav()));
                },
                icon: const Icon(Icons.close),
              ),
              backgroundColor: Colors.white,
            ),
      backgroundColor: const Color(0xFFECE5B6),
      body: Center(
        child: _isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Stack(
                    children: [
                      Card(
                        color: Colors.white10,
                        margin: const EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                name.toString(),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 24),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Account Information',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 24),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child:
                                  userInfo(icon: Icons.email, content: email),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: userInfo(
                                  icon: Icons.phone, content: phoneNumber),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            !_isSameUser
                                ? Container()
                                : Center(
                                    child: Padding(
                                        padding: EdgeInsets.only(bottom: 30),
                                        child: Bottun(
                                            onPressed: () {},
                                            child: const Text(
                                              'logout',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ))),
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
