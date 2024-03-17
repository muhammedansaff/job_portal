import 'package:JOBHUB/Jobs/jobs_screen.dart';
import 'package:JOBHUB/Jobs/posts.dart';

import 'package:JOBHUB/logout/logout.dart';
import 'package:JOBHUB/profilescreens/userprofile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkersNav extends StatefulWidget {
  final bool isworker;
  const WorkersNav({Key? key, required this.isworker});

  @override
  _WorkersNavState createState() => _WorkersNavState();
}

class _WorkersNavState extends State<WorkersNav> {
  late String workerid; // Declare workerid as late

  @override
  void initState() {
    super.initState();
    getuid(); // Call getuid() in initState
  }

  void getuid() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String uid = user!.uid;
    setState(() {
      workerid = uid; // Initialize workerid here
    });
  }

  Color getBackgroundColor() {
    if (indexnum == 2) {
      return Colors.black;
    } else if (indexnum == 1) {
      return const Color(0xFF716A76);
    } else if (indexnum == 0) {
      return const Color(0xFFECE5B6);
    } else {
      return const Color(0xFFECE5B6);
    }
  }

  int indexnum = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> workerscreen = [
      const JobScreen(
        isworker: true,
      ),
      userProfile(
        userId: workerid, // Use workerid directly in the widget tree
        isWorker: true,
      ),
      const PostWidget(),
      const LogoutDialog()
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 200),
        animationCurve: Curves.easeInCubic,
        color: Colors.white,
        backgroundColor: const Color(0xFFECE5B6),
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
            Icons.person,
            size: 20,
            color: Colors.black,
          ),
          Icon(
            Icons.photo,
            size: 20,
            color: Colors.black,
          ),
          Icon(
            Icons.logout,
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
      body: workerscreen[indexnum],
    );
  }
}
