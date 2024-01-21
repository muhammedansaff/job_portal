import 'package:JOBHUB/Jobs/Upload_job.dart';
import 'package:JOBHUB/Jobs/jobs_screen.dart';
import 'package:JOBHUB/Search/profile_company.dart';
import 'package:JOBHUB/Search/search_companies.dart';

import 'package:JOBHUB/user_state.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomNavigationbarforapp extends StatelessWidget {
  int indexNum = 0;

  BottomNavigationbarforapp({super.key, required this.indexNum});

  void logout(context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: const Color(0xFFF3F2EA),
          title: const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.logout,
                  color: Colors.black,
                  size: 36,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Sign out',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UserState(),
                  ),
                );
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.decelerate,
        color: Colors.white,
        backgroundColor: const Color(0xFFECE5B6),
        buttonBackgroundColor: Colors.white,
        height: 50,
        index: indexNum,
        items: const [
          Icon(
            Icons.list,
            size: 19,
            color: Colors.black,
          ),
          Icon(
            Icons.search,
            size: 19,
            color: Colors.black,
          ),
          Icon(
            Icons.add,
            size: 19,
            color: Colors.black,
          ),
          Icon(
            Icons.person_pin,
            size: 19,
            color: Colors.black,
          ),
          Icon(
            Icons.exit_to_app,
            size: 19,
            color: Colors.black,
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const JobScreen(),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const AllWorkerScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const UploadJobNow(),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );
          } else if (index == 4) {
            logout(context);
          }
        });
  }
}
