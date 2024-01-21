import 'package:JOBHUB/Jobs/jobs_screen.dart';
import 'package:JOBHUB/Widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class AllWorkerScreen extends StatefulWidget {
  const AllWorkerScreen({super.key});

  @override
  State<AllWorkerScreen> createState() => _AllWorkerScreenState();
}

class _AllWorkerScreenState extends State<AllWorkerScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const FlowingWaterBackground(),
        Scaffold(
          bottomNavigationBar: BottomNavigationbarforapp(indexNum: 1),
          appBar: AppBar(
            shadowColor: Colors.black,
            elevation: 2,
            toolbarHeight: 40,
            backgroundColor: const Color(0xFFF5F5DC),
            title: const Center(
              child: Text('All workers screen',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
