import 'package:flutter/material.dart';

class AllWorkerScreen extends StatefulWidget {
  const AllWorkerScreen({super.key});

  @override
  State<AllWorkerScreen> createState() => _AllWorkerScreenState();
}

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
        title: const Center(
          child: Text('All workers screen',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ),
      backgroundColor: const Color(0xFFECE5B6),
    );
  }
}
