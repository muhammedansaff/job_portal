import 'package:JOBHUB/Search/profile_company.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllWorkerScreen extends StatefulWidget {
  const AllWorkerScreen({super.key});

  @override
  State<AllWorkerScreen> createState() => _AllWorkerScreenState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;
final uid = user!.uid;

class _AllWorkerScreenState extends State<AllWorkerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: Colors.black,
        elevation: 2,
        toolbarHeight: 40,
        backgroundColor: const Color(0xFFF5F5F5),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: uid.toString()),
                ),
              );
            },
            icon: const Icon(Icons.person)),
      ),
      backgroundColor: const Color(0xFFECE5B6),
    );
  }
}
