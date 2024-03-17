import 'package:JOBHUB/profilescreens/userprofile.dart';

import 'package:JOBHUB/workerscreen/workerswidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllWorkerScreen extends StatefulWidget {
  const AllWorkerScreen({Key? key}) : super(key: key);

  @override
  _AllWorkerScreenState createState() => _AllWorkerScreenState();
}

class _AllWorkerScreenState extends State<AllWorkerScreen> {
  late String? userId;

  late String feedbackname;
  late String feedbackemail;

  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _showFeedbackDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Provide Feedback'),
          content: TextField(
            controller: _feedbackController,
            decoration: const InputDecoration(hintText: 'Enter your feedback'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                String feedback = _feedbackController.text.trim();
                if (feedback.isNotEmpty) {
                  _submitFeedback(feedback);
                  _feedbackController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getWorkerData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getWorkerData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final uid = user!.uid;

    setState(() {
      userId = uid;
    });

    // Assuming 'workersanduser' is the collection name in Firestore
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('workersanduser')
        .doc(uid)
        .get();

    if (userSnapshot.exists) {
      // Assuming 'name' and 'email' are fields in the document
      String name = userSnapshot['name'];
      String email = userSnapshot['email'];
      setState(() {
        feedbackname = name;
        feedbackemail = email;
      });
    } else {
      print('User not found in database');
    }
  }

  Future<void> _submitFeedback(String feedback) async {
    try {
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'feedback': feedback,
        'createdAt': Timestamp.now(),
      });

      print('Feedback submitted successfully');
    } catch (e) {
      print('Error submitting feedback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => userProfile(
                  userId: FirebaseAuth
                      .instance.currentUser!.uid, // Placeholder for userId
                  isWorker: false,
                ),
              ),
            );
          },
          icon: const Icon(Icons.person),
        ),
        actions: [
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: const Icon(Icons.feedback),
              onPressed: _showFeedbackDialog,
            ),
          )
        ],
        automaticallyImplyLeading: false,
        title: const Text('Workers'),
      ),
      body: const AllWorkerScreenView(),
    );
  }
}

class AllWorkerScreenView extends StatefulWidget {
  const AllWorkerScreenView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllWorkerScreenViewState createState() => _AllWorkerScreenViewState();
}

class _AllWorkerScreenViewState extends State<AllWorkerScreenView> {
  late String uid;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final uid = user!.uid;

    setState(() {
      this.uid = uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5B6),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('acceptedworkers')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Error fetching data: ${snapshot.error}');
            return const Center(child: Text('Error fetching data'));
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No workers found'));
          }

          print('Data count: ${snapshot.data!.docs.length}');

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final userDoc = snapshot.data!.docs[index];
              final phone = userDoc['phoneNumber'];
              final email = userDoc['email'];
              final createdAt = userDoc['createdAt'];
              final userId = userDoc['id'];
              final name = userDoc['name'];
              final profession = userDoc['profession'];
              final userImage = userDoc['imageUrl'];
              final idimg = userDoc['myId'];
              final isWorker = userDoc['isWorker'];
              final id = userDoc['id'];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: workersWidget(
                  id: id,
                  isWorker: isWorker,
                  createdAt: createdAt,
                  check: false,
                  img: idimg,
                  phoneNumber: phone,
                  email: email,
                  uid: userId,
                  userName: name,
                  prof: profession,
                  userImage: userImage,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
