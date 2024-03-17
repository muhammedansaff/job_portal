import 'package:JOBHUB/refractor/container.dart';
import 'package:JOBHUB/user_state.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';

import 'package:url_launcher/url_launcher_string.dart';

class userProfile extends StatefulWidget {
  final String userId;
  final bool isWorker;
  const userProfile({super.key, required this.userId, required this.isWorker});

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  String phoneNumber = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isloading = true;
  // ignore: unused_field
  bool _isSameUser = false;

  @override
  void initState() {
    super.initState();
    widget.isWorker ? getworkerDataProfile() : getUserDataProfile();
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
          _isloading = false;
          print(imageUrl); // Update loading state after data fetch
        });
      }
    } catch (error) {
      // Handle error
      setState(() {
        User? user = auth.currentUser;
        final uid = user!.uid;
        _isloading = false; // Update loading state after error

        _isSameUser = uid == widget.userId;
        print(name);
      });
    }
  }

  void getworkerDataProfile() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('acceptedworkers')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('imageUrl');
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

        _isSameUser = uid == widget.userId;
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
      appBar: widget.isWorker
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
            )
          : AppBar(
              title: const Text('My Profile'),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
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
                        color: Colors.black26,
                        margin: const EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 150,
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
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: SizedBox(
                                width: 150,
                                child: MaterialButton(
                                  focusColor: Colors.white,
                                  onPressed: () {
                                    auth.signOut();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const UserState(),
                                      ),
                                    );
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesome
                                            .logout, // Use a FontAwesome icon for logout
                                        color: Colors.white,
                                        // Icon color
                                      ),
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              16, // Adjust the font size as needed
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
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
