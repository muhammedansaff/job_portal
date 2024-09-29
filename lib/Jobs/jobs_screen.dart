import 'package:JOBHUB/Jobs/job_widget.dart';
import 'package:JOBHUB/Persistent/Persistent.dart';

import 'package:JOBHUB/Search/search_job.dart';
import 'package:JOBHUB/Services/global_variables.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
//my name is ansaf
class JobScreen extends StatefulWidget {
  final bool isworker;
  const JobScreen({super.key, required this.isworker});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  
  Timestamp current = Timestamp.now();
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
    Persistent persistentObject = Persistent();
    persistentObject.getMyData();
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
          leading: widget.isworker
              ? IconButton(
                  onPressed: () {
                    showTaskCategoriesDialog(size: size);
                  },
                  icon: const Icon(
                    Icons.filter_list_rounded,
                    color: Colors.black,
                  ),
                )
              : null,
          actions: widget.isworker
              ? [
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
                ]
              : null,
        ),
        body: widget.isworker
            ? jobcategoryFilter != null
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('jobs')
                        .where('jobCategory', isEqualTo: jobcategoryFilter)
                        .where('recruitment', isEqualTo: true)
                        .orderBy('createdat', descending: true)
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
                        .orderBy('createdat', descending: true)
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
                  )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('jobs')
                    .where('uploadBy',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
              ));
  }
}
