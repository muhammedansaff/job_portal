import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5B6),
      appBar: AppBar(
        title: const Text('SEARCH JOB'),
        elevation: 2,
        toolbarHeight: 40,
        shadowColor: const Color(0xFFF5F5DC),
        backgroundColor: const Color(0xFFF5F5DC),
      ),
    );
  }
}
