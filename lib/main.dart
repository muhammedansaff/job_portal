import 'dart:async';

import 'package:JOBHUB/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const JobApp());
  Timer.periodic(const Duration(hours: 24), (timer) {
    deleteJobTitlesWithoutDeadline();
    deleteExpiredJobs();
  });
}

String? jobtitle;

Future<void> deleteJobTitlesWithoutDeadline() async {
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('jobs').doc('jobId').get();
  jobtitle = userDoc.get('jobTitle');

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(jobtitle.toString())
        .where('isDeadLineAvailable', isEqualTo: false)
        .get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    querySnapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });

    await batch.commit();

    print('Job titles without deadline deleted successfully');
  } catch (error) {
    print('Error deleting job titles without deadline: $error');
    // Handle error
  }
}

Future<void> deleteExpiredJobs() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .where('isDeadLineAvailable', isEqualTo: false)
        .get();

    // Delete each expired document
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
      print('Expired job deleted: ${doc.id}');
    }
  } catch (error) {
    print('Error deleting expired jobs: $error');
    // Handle error
  }
}

class JobApp extends StatefulWidget {
  const JobApp({super.key});

  @override
  State<JobApp> createState() => _JobAppState();
}

class _JobAppState extends State<JobApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  void initState() {
    super.initState();
    deleteJobTitlesWithoutDeadline();
    deleteExpiredJobs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print('succesful');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.blue),
            home: const Scaffold(
              body: Center(
                child: Text(
                  "jobportal app is being initialized",
                  style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ansaf'),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          print("not successful");
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  "An error has occured",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "JOBHUB",
            theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                primarySwatch: Colors.blue),
            home: const UserState());
      },
    );
  }
}
