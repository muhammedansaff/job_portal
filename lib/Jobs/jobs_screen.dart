import 'package:JOBHUB/Persistent/Persistent.dart';
import 'package:JOBHUB/Search/search_job.dart';
import 'package:JOBHUB/Services/global_variables.dart';
import 'package:JOBHUB/Widgets/job_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  String? jobcategoryFilter;
  showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900], // Dark background color
          title: const Text(
            'Job Category',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: size.width * 0.9,
            height:
                size.height * 0.4, // Set a fixed height for the content area
            child: ListView.builder(
              itemCount: Persistent.jobfilterList.length,
              itemBuilder: (ctxx, index) {
                return InkWell(
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        jobcategoryFilter = Persistent.jobfilterList[index];
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      print(
                          'jobcategorylist[index],${Persistent.jobfilterList[index]}');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          Persistent.jobfilterList[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  jobcategoryFilter = null;
                  print(jobcategoryFilter);
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                'cancel ',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        );
      },
    );
  } //code to filter the job

  void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      name = userDoc.get('name');
      userImage = userDoc.get('userImage');
      location = userDoc.get('location');
    });
  } // collect the user data ,name,image,location

  @override
  void initState() {
    super.initState();
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFECE5B6),
      appBar: AppBar(
        elevation: 2,
        toolbarHeight: 40,
        shadowColor: const Color(0xFFF5F5DC),
        backgroundColor: const Color(0xFFF5F5F5),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            showTaskCategoriesDialog(size: size);
          },
          icon: const Icon(
            Icons.filter_list_rounded,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const SearchScreen(),
                ),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: jobcategoryFilter != null
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('jobs')
                  .where('jobCategory', isEqualTo: jobcategoryFilter)
                  .where('recruitment', isEqualTo: true)
                  .orderBy('createdat', descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  // ignore: avoid_print
                  print('Error fetching data: ${snapshot.error}');
                  return const Center(child: Text('Error fetching data'));
                }

                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Jobs found'));
                }

                // ignore: avoid_print
                print('Data count: ${snapshot.data!.docs.length}');
                // ignore: avoid_print
                print(jobcategoryFilter);

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
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
                    print(name);
                    // Use the retrieved data to build your UI components
                    // ...

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4), // Add vertical spacing here
                      child: JobWidget(
                        uploadby: uploadby,
                        jobTitle: jobTitle,
                        email: email,
                        jobDiscription: jobDiscription,
                        jobid: jobid,
                        location: location,
                        name: name,
                        recruitment: recruitment,
                        userImage: userImage,
                      ),
                    );
                  },
                );
              },
            ) //code for filtered list builder
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('jobs')
                  .where('recruitment', isEqualTo: true)
                  .orderBy('createdat', descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  // ignore: avoid_print
                  print('Error fetching data: ${snapshot.error}');
                  return const Center(child: Text('Error fetching data'));
                }

                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Jobs found'));
                }

                // ignore: avoid_print
                print('Data count: ${snapshot.data!.docs.length}');
                // ignore: avoid_print
                print(jobcategoryFilter);

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
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
                    print(name);
                    // Use the retrieved data to build your UI components
                    // ...

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2), // Add vertical spacing here
                      child: JobWidget(
                        uploadby: uploadby,
                        jobTitle: jobTitle,
                        email: email,
                        jobDiscription: jobDiscription,
                        jobid: jobid,
                        location: location,
                        name: name,
                        recruitment: recruitment,
                        userImage: userImage,
                      ),
                    );
                  },
                );
              },
            ), // to show all jobs in one
    );
  }
}
