import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintDialog extends StatefulWidget {
  final String jobTitle;
  final String jobID;
  final String username;
  final String email;
  final String userImage;
  final String userId;

  const ComplaintDialog({
    Key? key,
    required this.jobTitle,
    required this.jobID,
    required this.username,
    required this.email,
    required this.userImage,
    required this.userId,
  }) : super(key: key);

  @override
  _ComplaintDialogState createState() => _ComplaintDialogState();
}

class _ComplaintDialogState extends State<ComplaintDialog> {
  late String proffession;
  late double rating;
  late int nom;
  late String id;

  @override
  void initState() {
    super.initState();
    getJobData();
  }

  void getJobData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('acceptedworkers')
        .doc(widget.userId)
        .get();

    if (userDoc.exists) {
      setState(() {
        id = userDoc.get('id');

        if (id == widget.userId) {
          proffession = userDoc.get('profession');
          rating = userDoc.get('rating');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Report User'),
      content: const Text('Are you sure you want to report this user?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await _uploadComplaint(context);
          },
          child: const Text('Report'),
        ),
      ],
    );
  }

  int y =
      0; // Define y outside the function to keep its value between function calls

  Future<void> _uploadComplaint(BuildContext context) async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('complaints')
        .doc(widget.userId)
        .get();

    if (userDoc.exists) {
      setState(() {
        nom = userDoc.get('number of people complained');
        y = nom;
      });
    }

    try {
      // Add complaint to Firestore
      await FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.userId)
          .set({
        'complaining about': widget.username, // Corrected typo
        'email': widget.email,
        'profession': proffession,
        'rating': rating,
        'userImage': widget.userImage,
        'userId': widget.userId,
        'jobId': widget.jobID,

        'number of people complained': y + 1, // Increment y and then use it
      });

      setState(
          () {}); // Optional: if you want to update the UI after incrementing y

      // Close the dialog
      Navigator.of(context).pop(); // Close the dialog

      // Show confirmation dialog
      // ignore: use_build_context_synchronously
    } catch (error) {
      print('Error submitting complaint: $error');
      // Handle error as needed
    }
  }
}
