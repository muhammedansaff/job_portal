import 'package:JOBHUB/Jobs/jobs_screen.dart';
import 'package:JOBHUB/Widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const FlowingWaterBackground(),
        Scaffold(
          bottomNavigationBar: BottomNavigationbarforapp(indexNum: 3),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            shadowColor: Colors.black,
            elevation: 10,
            toolbarHeight: 40,
            backgroundColor: Colors.blue,
            title: const Center(
              child: Text(
                'Profile ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
