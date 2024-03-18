import 'package:JOBHUB/Jobs/job_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchQueryController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchQueryController.removeListener(_onSearchChanged);
    _searchQueryController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = _searchQueryController.text;
      });
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Search',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16),
    );
  }

  Widget _buildActions() {
    return IconButton(
      onPressed: _clearSearchQuery,
      icon: const Icon(Icons.clear),
    );
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5B6),
      appBar: AppBar(
        title: _buildSearchField(),
        actions: [_buildActions()],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('jobTitle', isGreaterThanOrEqualTo: _searchQuery)
            .where('recruitment', isEqualTo: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No jobs found'));
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 1,
                  color: Colors.grey,
                );
              },
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final jobData = snapshot.data!.docs[index];
                final jobTitle = jobData['jobTitle'];
                final email = jobData['email'];
                final jobid = jobData['jobid'];
                final location = jobData['location'];
                final recruitment = jobData['recruitment'];
                final uploadby = jobData['uploadBy'];
                final jobDescription = jobData['jobDiscription'];
                final name = jobData['name'];
                final userImage = jobData['userImage'];

                return JobWidget(
                  uploadby: uploadby,
                  jobTitle: jobTitle,
                  email: email,
                  jobDiscription: jobDescription,
                  jobid: jobid,
                  location: location,
                  name: name,
                  recruitment: recruitment,
                  userImage: userImage,
                );
              },
            );
          }
        },
      ),
    );
  }
}
