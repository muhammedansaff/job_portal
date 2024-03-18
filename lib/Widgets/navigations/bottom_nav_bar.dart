import 'package:JOBHUB/Jobs/jobs_screen.dart';

import 'package:JOBHUB/Jobs/upload_job.dart';

import 'package:JOBHUB/logout/logout.dart';
import 'package:JOBHUB/profilescreens/userprofile.dart';

import 'package:JOBHUB/workerscreen/allWorkers.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class UserNav extends StatefulWidget {
  final bool isworker;
  const UserNav({super.key, required this.isworker});

  @override
  State<UserNav> createState() => _UserNavState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
String? myid;

// ignore: camel_case_types
class _UserNavState extends State<UserNav> {
  void getuid() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String uid = user!.uid;
    setState(() {
      myid = uid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuid();
  }

  int indexnum = 0;

  Color getBackgroundColor() {
    if (indexnum == 3) {
      return const Color(0xFFECE5B6); // Set background to black when index is 4
    } else if (indexnum == 2) {
      return const Color(0xFF716A76);
    } else if (indexnum == 0) {
      return const Color(0xFFECE5B6);
    } else {
      return const Color(0xFFECE5B6);
    }
  }

  List screens = [
    const JobScreen(
      isworker: false,
    ),
    const AllWorkerScreen(),
    const UploadJobNow(),
    userProfile(
        userId: FirebaseAuth.instance.currentUser!.uid, isWorker: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 200),
        animationCurve: Curves.easeInCubic,
        color: Colors.white,
        backgroundColor:
            getBackgroundColor(), // Use getBackgroundColor function
        buttonBackgroundColor: Colors.white,
        height: 60,
        index: indexnum,
        items: const [
          Icon(
            Icons.list,
            size: 20,
            color: Colors.black,
          ),
          Icon(
            Icons.search,
            size: 20,
            color: Colors.black,
          ),
          Icon(
            Icons.add,
            size: 20,
            color: Colors.black,
          ),
          Icon(
            Icons.person,
            size: 20,
            color: Colors.black,
          ),
        ],
        onTap: (index) {
          setState(() {
            indexnum = index;
          });
        },
      ),
      body: screens[indexnum],
    );
  }
}
