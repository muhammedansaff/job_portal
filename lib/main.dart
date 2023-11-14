import 'package:JOBHUB/user_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:JOBHUB/login/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(JobApp());
}

class JobApp extends StatelessWidget {
  JobApp({super.key});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("successful");
          return const MaterialApp(
            home: Scaffold(
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
                    color: Colors.red,
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
