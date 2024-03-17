import 'package:flutter/material.dart';
import 'package:JOBHUB/Widgets/apllied/appliedWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppliedUsersList extends StatefulWidget {
  final String jobId;

  const AppliedUsersList({Key? key, required this.jobId}) : super(key: key);

  @override
  _AppliedUsersListState createState() => _AppliedUsersListState();
}

class _AppliedUsersListState extends State<AppliedUsersList> {
  List<Map<String, dynamic>> applicants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getApplicantsData();
  }

  Future<void> getApplicantsData() async {
    setState(() {
      isLoading = true;
    });

    final snapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobId)
        .collection('appliedusers')
        .get();

    setState(() {
      isLoading = false;
      applicants = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5B6),
      appBar: AppBar(
        title: const Text(
          'Applied users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : applicants.isEmpty
              ? Center(child: Text("No workers have applied for this job"))
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
                        rating: applicantData['rating'],
                        jobID: applicantData['jobId'],
                        userId: applicantData['userId'],
                        jobTitle: applicantData['jobTitle'],
                        email: applicantData['email'],
                        userImage: applicantData['userImageURL'],
                        username: applicantData['name'],
                      );
                    },
                  ),
                ),
    );
  }
}
