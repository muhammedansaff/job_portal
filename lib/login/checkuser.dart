import 'package:JOBHUB/Widgets/navigations/workersnav.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:JOBHUB/Widgets/navigations/bottom_nav_bar.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  _CheckUserState createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  bool _isLoading = true;
  bool? _isWorker; // Default value assuming user is not a worker

  @override
  void initState() {
    super.initState();
    _checkUserIsWorker();
  }

  void _checkUserIsWorker() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not logged in.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final uid = user.uid;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('workeranduser')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;

        if (data?['isWorker'] != null) {
          setState(() {
            _isWorker = data!['isWorker'];
          });
        } else {
          print('isWorker field is not set.');
        }
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5B6),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isWorker == true
              ? const WorkersNav(
                  isworker: true,
                )
              : const UserNav(
                  isworker: false,
                ), // Assuming ForgetPasswordScreen is the non-worker page
    );
  }
}
