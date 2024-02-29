import 'package:JOBHUB/Jobs/job_details.dart';
import 'package:JOBHUB/Services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JobWidget extends StatefulWidget {
  final String jobTitle;
  final String jobDiscription;
  final String jobid;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;
  final String uploadby;
  const JobWidget({
    super.key,
    required this.uploadby,
    required this.jobTitle,
    required this.email,
    required this.jobDiscription,
    required this.jobid,
    required this.location,
    required this.name,
    required this.recruitment,
    required this.userImage,
  });

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  _deleteDialog() {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Job'),
          content: const Text('Are you sure you want to delete this job?'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  if (widget.uploadby == _uid) {
                    await FirebaseFirestore.instance
                        .collection('jobs')
                        .doc(widget.jobid)
                        .delete();
                    await Fluttertoast.showToast(
                      msg: 'Job has been deleted',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.grey,
                      fontSize: 18,
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  } else {
                    GlobalMethod.showErrorDialog(
                      error: 'You cannot perform this action',
                      ctx: context,
                    );
                  }
                } catch (error) {
                  // ignore: use_build_context_synchronously
                  GlobalMethod.showErrorDialog(
                    error: 'This task cannot be deleted',
                    ctx: context,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  } //to delete a uploaded job

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        color: Colors.black54,
        shadowColor: const Color.fromARGB(25, 216, 230, 110),
        elevation: 15,
        child: ListTile(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetailScreen(
                    uploadedBy: widget.uploadby, jobId: widget.jobid),
              ),
            );
          },
          onLongPress: _deleteDialog,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: const Color(0xFFECE5B6),
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(widget.userImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.jobTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFECE5B6),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4), // Decreased vertical space here
              Text(
                widget.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          subtitle: Text(
            widget.jobDiscription,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
