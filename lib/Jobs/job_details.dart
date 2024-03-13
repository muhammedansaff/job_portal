import 'package:JOBHUB/Services/global_methods.dart';
import 'package:JOBHUB/Services/global_variables.dart';
import 'package:JOBHUB/Widgets/applieduser.dart';

import 'package:JOBHUB/Widgets/bottom_nav_bar.dart';
import 'package:JOBHUB/Widgets/comments_widget.dart';
import 'package:JOBHUB/refractor/materialbutton.dart';
import 'package:JOBHUB/refractor/opacity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

class JobDetailScreen extends StatefulWidget {
  final String uploadedBy;
  final String jobId;

  const JobDetailScreen({
    super.key,
    required this.uploadedBy,
    required this.jobId,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? authorname;
  String? jobid;
  String userImageUrl = '';
  String? jobCategory;
  String? jobDescription = "";
  String jobTitle = '';
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadLineTimeStamp;
  String? postedDate = "";
  String? deadLineDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int applicants = 0;
  bool isDeadLineAvailable = true;
  String? jobtype;
  bool? buttoncont = true;
  bool _isCommenting = false;
  bool showComment = false;
  String? phone;
  bool appbarbool = false;

  final TextEditingController _commentController = TextEditingController();

  void getJobData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();

    // ignore: unnecessary_null_comparison
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorname = userDoc.get('name');
        userImageUrl = userDoc.get('userImage');
        phone = userDoc.get('phoneNumber');
      });
    }
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobId)
        .get();
    // ignore: unnecessary_null_comparison
    if (jobDatabase == null) {
      return;
    } else {
      setState(() {
        jobtype = jobDatabase.get('jobtype');
        jobTitle = jobDatabase.get('jobTitle');
        jobDescription = jobDatabase.get('jobDiscription');
        emailCompany = jobDatabase.get('email');
        recruitment = jobDatabase.get('recruitment');
        locationCompany = jobDatabase.get('location');
        applicants = jobDatabase.get('apllications');
        postedDateTimeStamp = jobDatabase.get('createdat');
        deadLineTimeStamp = jobDatabase.get('deadLineTimeStamp');
        deadLineDate = jobDatabase.get('jobDeadlinedate');
        isDeadLineAvailable = jobDatabase.get('isDeadLineAvailable');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
        if (jobtype == "General") {
          buttoncont = true;
        } else {
          buttoncont = false;
        }
      });
      var date = deadLineTimeStamp!.toDate();
      isDeadLineAvailable = date.isAfter(DateTime.now());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobData();
    appbarcheck();
  }

  Widget dividerWidgewt() {
    return const Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  applyForJob() {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query:
          'subject=Apllying for $jobTitle&body=Hello,please attach Resume cv file',
    );
    final url = params.toString();
    launchUrlString(url);
    addNewApplicant();
  }

  void openPhone(String phoneNumber) async {
    var url = 'tel:$phoneNumber';
    addNewApplicant();
    await launchUrlString(url);
  }

  void addNewApplicant() async {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    String applemail = user.email.toString();

    final appliedId = const Uuid().v4();

    // Add the new applicant to the 'appliedusers' array
    await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobId)
        .collection('appliedusers')
        .doc(uid)
        .set({
      'userId': uid,
      'appliedid': appliedId,
      'name': name,
      'userImageURL': userImage,
      'jobTitle': jobTitle,
      'time': Timestamp.now(),
      'email': applemail,
      'jobId': widget.jobId
    });

    // After adding the applicant, update the 'applications' field with the count of applied users
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobId)
        .collection('appliedusers')
        .get();
    setState(() {
      var appliedIds = querySnapshot.docs.map((doc) => doc.id).toList();

      print(appliedIds); // Print the list of applied user IDs

      // Now you can set state or perform any other operations with the appliedIds list
    });

    final numberOfDocuments = querySnapshot.docs.length;

    await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobId)
        .update({
      'apllications': numberOfDocuments,
    });

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomNav(),
      ),
    );
  }

  void appbarcheck() {
    User? user = _auth.currentUser;
    final uid = user!.uid;
    if (uid == widget.uploadedBy) {
      setState(() {
        appbarbool = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5B6),
      appBar: AppBar(
        actions: [
          appbarbool
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AppliedUsersList(jobId: widget.jobId)));
                  },
                  icon: const Icon(Icons.person_4_outlined),
                )
              : const SizedBox()
        ],
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: IconButton(
            icon: const Icon(
              Icons.close,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNav(),
                ),
              );
            },
          ),
        ),
        automaticallyImplyLeading: false,
        shadowColor: Colors.black,
        elevation: 2,
        toolbarHeight: 40,
        backgroundColor: const Color(0xFFF5F5F5),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  shadowColor: const Color.fromARGB(25, 216, 230, 110),
                  elevation: 15,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            jobTitle.toString(),
                            maxLines: 3,
                            style: const TextStyle(
                                color: Color(0xFFECE5B6),
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 3, color: const Color(0xFFECE5B6)),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  // ignore: unnecessary_null_comparison
                                  image: NetworkImage(
                                    userImageUrl,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorname.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    locationCompany.toString(),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        dividerWidgewt(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              applicants.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            const Text(
                              'Apllicants',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.how_to_reg_sharp,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        FirebaseAuth.instance.currentUser!.uid !=
                                widget.uploadedBy
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dividerWidgewt(),
                                  const Text(
                                    'Recruitment',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            User? user = _auth.currentUser;
                                            final uid = user!.uid;
                                            if (uid == widget.uploadedBy) {
                                              try {
                                                FirebaseFirestore.instance
                                                    .collection('jobs')
                                                    .doc(widget.jobId)
                                                    .update(
                                                        {'recruitment': true});
                                              } catch (error) {
                                                GlobalMethod.showErrorDialog(
                                                    error:
                                                        'Action cannot be performed',
                                                    ctx: context);
                                              }
                                            } else {
                                              GlobalMethod.showErrorDialog(
                                                  error:
                                                      'You cannot perform this action',
                                                  ctx: context);
                                            }
                                            getJobData();
                                          },
                                          child: const Txt(txt: 'ON')),
                                      oppp(
                                        rec: recruitment == true ? 1 : 0,
                                        col: Colors.red,
                                      ),
                                      const SizedBox(
                                        width: 40,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          User? user = _auth.currentUser;
                                          final uid = user!.uid;
                                          if (uid == widget.uploadedBy) {
                                            try {
                                              FirebaseFirestore.instance
                                                  .collection('jobs')
                                                  .doc(widget.jobId)
                                                  .update(
                                                      {'recruitment': false});
                                            } catch (error) {
                                              GlobalMethod.showErrorDialog(
                                                  error:
                                                      'Action cannot be performed',
                                                  ctx: context);
                                            }
                                          } else {
                                            GlobalMethod.showErrorDialog(
                                                error:
                                                    'You cannot perform this action',
                                                ctx: context);
                                          }
                                          getJobData();
                                        },
                                        child: const Txt(
                                          txt: "OFF",
                                        ),
                                      ),
                                      oppp(
                                        rec: recruitment == true ? 1 : 0,
                                        col: Colors.green,
                                      )
                                    ],
                                  )
                                ],
                              ),
                        dividerWidgewt(),
                        const Text(
                          "Job Description",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          jobDescription.toString(),
                          textAlign: TextAlign.justify,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        dividerWidgewt(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            isDeadLineAvailable
                                ? 'Actively Recruiting, send cv/resume:'
                                : "Deadline Passes Away",
                            style: TextStyle(
                                color: isDeadLineAvailable
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        (FirebaseAuth.instance.currentUser!.uid !=
                                    widget.uploadedBy &&
                                isDeadLineAvailable)
                            ? Center(
                                child: buttoncont!
                                    ? Bottun(
                                        onPressed: () {
                                          applyForJob();
                                        },
                                        child: const Text(
                                          "apply now",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : Bottun(
                                        onPressed: () {
                                          openPhone(phone.toString());
                                        },
                                        child: const Text(
                                          "call now",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              )
                            : Container(),
                        dividerWidgewt(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Uploaded on:",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              postedDate.toString(),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Dead Line:",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              deadLineDate.toString(),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: _isCommenting
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: SizedBox(
                                        width: 250,
                                        child: TextField(
                                          controller: _commentController,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          maxLines: 4,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Bottun(
                                              onPressed: () async {
                                                if (_commentController
                                                        .text.length <
                                                    7) {
                                                  GlobalMethod.showErrorDialog(
                                                      error:
                                                          'comment cannot be less than 7',
                                                      ctx: context);
                                                } else {
                                                  final _generateId =
                                                      const Uuid().v4();
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('jobs')
                                                      .doc(widget.jobId)
                                                      .update(
                                                    {
                                                      'jobComments':
                                                          FieldValue.arrayUnion(
                                                        [
                                                          {
                                                            'userId':
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                            'commentId':
                                                                _generateId,
                                                            'name': name,
                                                            'userImageURL':
                                                                userImage,
                                                            'commentBody':
                                                                _commentController
                                                                    .text,
                                                            'time':
                                                                Timestamp.now()
                                                          },
                                                        ],
                                                      )
                                                    },
                                                  );
                                                  await Fluttertoast.showToast(
                                                      msg:
                                                          'your comment has been added',
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      fontSize: 18);
                                                  _commentController.clear();
                                                }
                                                setState(() {
                                                  showComment = true;
                                                });
                                              },
                                              child: const Text(
                                                "post",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isCommenting =
                                                        !_isCommenting;
                                                    showComment = false;
                                                  });
                                                },
                                                child: const Text("Cancel")),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isCommenting = !_isCommenting;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.add_comment,
                                        color: Colors.blueAccent,
                                        size: 40,
                                      ),
                                    ),
                                    const SizedBox(),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showComment = true;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: Colors.blueAccent,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        showComment == false
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(16),
                                child: FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('jobs')
                                      .doc(widget.jobId)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      if (snapshot.data == null) {
                                        const Center(
                                          child:
                                              Text('No Comments For This Job'),
                                        );
                                      }
                                    }
                                    return ListView.separated(
                                      itemBuilder: (context, index) {
                                        return commentsWidget(
                                            commentid:
                                                snapshot.data!['jobComments']
                                                    [index]['commentId'],
                                            commenterid:
                                                snapshot.data!['jobComments']
                                                    [index]['userId'],
                                            commentName:
                                                snapshot.data!['jobComments']
                                                    [index]['name'],
                                            commentBody:
                                                snapshot.data!['jobComments']
                                                    [index]['commentBody'],
                                            commenterImageUrl:
                                                snapshot.data!['jobComments']
                                                    [index]['userImageURL']);
                                      },
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          thickness: 1,
                                          color: Colors.grey,
                                        );
                                      },
                                      itemCount:
                                          snapshot.data!['jobComments'].length,
                                    );
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
