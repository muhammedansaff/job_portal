import 'package:JOBHUB/Jobs/jobs_screen.dart';
import 'package:JOBHUB/Jobs/upload_job.dart';
import 'package:JOBHUB/Search/profile_company.dart';
import 'package:JOBHUB/Search/search_companies.dart';
import 'package:JOBHUB/logout/logout.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _bottomnavState();
}

// ignore: camel_case_types
class _bottomnavState extends State<BottomNav> {
  List screens = [
    const JobScreen(),
    const AllWorkerScreen(),
    const UploadJobNow(),
    const ProfileScreen(),
    const LogoutDialog()
  ];
  int indexnum = 0;

  Color getBackgroundColor() {
    if (indexnum == 4) {
      return Colors.black; // Set background to black when index is 4
    } else if (indexnum == 2) {
      return const Color(0xFF716A76);
    } else {
      return const Color(0xFFECE5B6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Icons.person_pin,
            size: 20,
            color: Colors.black,
          ),
          Icon(
            Icons.exit_to_app,
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
