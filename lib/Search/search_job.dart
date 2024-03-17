import 'package:JOBHUB/Jobs/job_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchQueryController = TextEditingController();
  String searchQuery = 'Search Query';

  Widget _buildSearchField() {
    return TextField(
      controller: searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
          hintFadeDuration: Durations.extralong1,
          hintText: 'click here to Search',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey)),
      style: const TextStyle(color: Colors.black, fontSize: 16),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  void clearSearchquery() {
    setState(() {
      searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  Widget _buildActions() {
    return IconButton(
        onPressed: () {
          clearSearchquery();
        },
        icon: const Icon(Icons.clear));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5B6),
      appBar: AppBar(
        title: _buildSearchField(),
        actions: [_buildActions()],
        elevation: 2,
        toolbarHeight: 40,
        shadowColor: const Color(0xFFF5F5DC),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('jobTitle', isGreaterThanOrEqualTo: searchQuery)
            .where('recruitment', isEqualTo: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.docs.isNotEmpty == true) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  final jobData = snapshot.data!.docs[index];
                  final jobTitle = jobData['jobTitle'];
                  final email = jobData['email'];
                  final jobid = jobData['jobid'];
                  final location = jobData['location'];
                  final recruitment = jobData['recruitment'];
                  final uploadby = jobData['uploadBy'];
                  final jobDiscription =
                      jobData['jobDiscription']; // corrected typo
                  final name = jobData['name'];
                  final userImage = jobData['userImage'];
                  return JobWidget(
                      uploadby: uploadby,
                      jobTitle: jobTitle,
                      email: email,
                      jobDiscription: jobDiscription,
                      jobid: jobid,
                      location: location,
                      name: name,
                      recruitment: recruitment,
                      userImage: userImage);
                },
                itemCount: snapshot.data?.docs.length,
              );
            } else {
              const Center(
                child: Text('no job found'),
              );
            }
          }
          return const Center(child: Text("no job found"));
        },
      ),
    );
  }
}
