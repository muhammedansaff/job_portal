import 'package:JOBHUB/Widgets/bottom_nav_bar.dart';
//import 'package:JOBHUB/user_state.dart';

import 'package:flutter/material.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          const FlowingWaterBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: BottomNavigationbarforapp(
              indexNum: 0,
            ),
            appBar: AppBar(
              elevation: 2,
              toolbarHeight: 40,
              shadowColor: const Color(0xFFF5F5DC),
              backgroundColor: const Color(0xFFF5F5DC),
              title: const Center(
                child: Text(
                  'Jobscreen',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FlowingWaterBackground extends StatefulWidget {
  const FlowingWaterBackground({super.key});

  @override
  State<FlowingWaterBackground> createState() => _FlowingWaterBackgroundState();
}

class _FlowingWaterBackgroundState extends State<FlowingWaterBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF5F5DC), // Beige
                Color(0xFFF3F2EA), // Cream
                Color(0xFFF0EAD6), // Pale Cream
                Color(0xFFECE5B6), // Light Beige // Deep Sky Blue
              ],
              stops: [
                0.0,
                0.3,
                0.7,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
