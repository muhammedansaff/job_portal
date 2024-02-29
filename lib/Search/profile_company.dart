import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5B6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: Colors.black,
        elevation: 2,
        toolbarHeight: 40,
        backgroundColor: const Color(0xFFF5F5F5),
        title: const Center(
          child: Text(
            'Profile ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
