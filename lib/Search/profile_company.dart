import 'dart:ffi';

import 'package:JOBHUB/Services/global_variables.dart';
import 'package:JOBHUB/Widgets/bottom_nav_bar.dart';
import 'package:JOBHUB/refractor/materialbutton.dart';
import 'package:JOBHUB/user_state.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
        final uid = user!.uid;
        _isloading = false; // Update loading state after error
        print(_isSameUser);
        _isSameUser = uid == widget.userId;
        print(name);
      });
    }
  }

  void openWhatsappChat(String phoneNumber) async {
    var url = 'https://wa.me/+91$phoneNumber';
    await launchUrlString(url);
  }

  emailto(email) {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=Apllying for please&body=Hello,please attach Resume cv file',
    );
    final url = params.toString();
    launchUrlString(url);
  }

  void openPhone(String phoneNumber) async {
    var url = 'tel:$phoneNumber';
    await launchUrlString(url);
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
                  Navigator.pushReplacement(
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomNav()));
                },
                icon: const Icon(Icons.close),
              ),
              backgroundColor: Colors.white,
            ),
      backgroundColor: const Color(0xFFECE2B6),
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
                              height: 120,
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
                              height: 12,
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
                              height: 12,
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
                            const SizedBox(
                              height: 20,
                            ),
                            _isSameUser
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2, color: Colors.green)),
                                        child: IconButton(
                                            onPressed: () {
                                              openWhatsappChat(phoneNumber);
                                            },
                                            icon: const Icon(
                                              FontAwesome.whatsapp,
                                              color: Colors.green,
                                            )),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2, color: Colors.blue)),
                                        child: IconButton(
                                            onPressed: () {
                                              openPhone(phoneNumber);
                                            },
                                            icon: const Icon(
                                              FontAwesome.phone,
                                              color: Colors.blue,
                                            )),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2, color: Colors.red)),
                                        child: IconButton(
                                            onPressed: () {
                                              emailto(email);
                                            },
                                            icon: const Icon(
                                              FontAwesome.mail,
                                              color: Colors.red,
                                            )),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            !_isSameUser
                                ? Container()
                                : Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      child: Bottun(
                                        onPressed: () {
                                          auth.signOut();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const UserState()));
                                        },
                                        child: const Text(
                                          'logout',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: const Color(0xFFECE2B6),
                                ),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
