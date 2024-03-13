import 'package:JOBHUB/Widgets/appliedWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppliedUsersList extends StatefulWidget {
  final String jobId;

  const AppliedUsersList({Key? key, required this.jobId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppliedUsersListState createState() => _AppliedUsersListState();
}

class _AppliedUsersListState extends State<AppliedUsersList> {
  List<Map<String, dynamic>> applicants = [];

  @override
  void initState() {
    super.initState();
    getApplicantsData();
  }

  Future<void> getApplicantsData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobId)
        .collection('appliedusers')
        .get();

    setState(() {
      applicants = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5B6),
      appBar: AppBar(
        title: const Text(
          'Apllied users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: true,
      ),
      body: applicants.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1,
                    color: Colors.black,
                  );
                },
                itemCount: applicants.length,
                itemBuilder: (context, index) {
                  var applicantData = applicants[index];
                  return ApplWidget(
                      jobID: applicantData['jobId'],
                      userId: applicantData['userId'],
                      jobTitle: applicantData['jobTitle'],
                      email: applicantData['email'],
                      userImage: applicantData['userImageURL'],
                      username: applicantData['name']);
                },
              ),
            ),
    );
  }
}
