import 'package:JOBHUB/Widgets/bottom_nav_bar.dart';
import 'package:JOBHUB/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNav(),
              ),
            );
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
            auth.signOut();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const Login(),
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
  }
}
