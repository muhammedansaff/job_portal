import 'package:JOBHUB/Persistent/Persistent.dart';
import 'package:JOBHUB/Search/search_companies.dart';
import 'package:JOBHUB/Services/global_methods.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:JOBHUB/Services/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:JOBHUB/refractor/container.dart';

class UploadJobNow extends StatefulWidget {
  const UploadJobNow({super.key});

  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  final _formkey = GlobalKey<FormState>();
  bool _isloading = false;
  DateTime? picked;
  bool? isDeadLineAvailable;
  String? selectedJob;
  double k = 230;
  Timestamp? deadLineTimeStamp;
  DateTime? endingDate;
  String? phoneNumberr;
  final TextEditingController _jobCategoryController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDiscriptionController =
      TextEditingController();
  final TextEditingController _jobDeadlineController = TextEditingController(
    text: 'pick a Date',
  );
  final TextEditingController _jobtypeController = TextEditingController();

  String? selectedCategory = Persistent.jobCategoryList[0];
  static const Map<String, List<String>> categoryMap = {
    'General': [
      'Architecture',
      'Construction',
      'Education',
      'Development',
      'IT',
      'Human Resource',
      'Marketing',
      'Design',
      'Accounting'
    ],
    'Local': [
      'Painter',
      'Plumber',
      'Driver',
      'Maid',
      'Electrician',
      'Coolie',
      'Cook'
    ],
  };

//variables
//variables
//variables
//variables

  Widget reftextstyles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  } //refactored code for the text style of textfield

  Widget reftextformfield(
      {required String valuekey,
      required TextEditingController refcontroller,
      required bool enabled,
      required Function fct,
      required int maxLength}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          cursorColor: Colors.black,
          validator: (value) {
            if (value!.isEmpty) {
              return 'values are missing';
            }
            return null;
          },
          controller: refcontroller,
          enabled: enabled,
          key: ValueKey(valuekey),
          style: const TextStyle(
            color: Colors.black,
          ),
          maxLines: valuekey == 'jobDiscription' ? 2 : 1,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  } //refactored textformfield for uploadjob

  void pickDataDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(
        () {
          _jobDeadlineController.text =
              '${picked!.year}-${picked!.month}-${picked!.day}';
          deadLineTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
              picked!.microsecondsSinceEpoch);
          var date = deadLineTimeStamp!.toDate();
          isDeadLineAvailable = date.isAfter(DateTime.now());
          endingDate = date.add(const Duration(days: 3));
        },
      );
    }
  } //dialog box to select the date

  void _uploadTask() async {
    final jobid = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      if (_jobDeadlineController.text == 'pick a Date' ||
          _jobCategoryController.text == Persistent.jobCategoryList[0]) {
        GlobalMethod.showErrorDialog(
            error: 'please pick everything', ctx: context);
        return;
      }
      setState(
        () {
          _isloading = true;
        },
      );
      try {
        await FirebaseFirestore.instance.collection('jobs').doc(jobid).set({
          'jobid': jobid,
          'uploadBy': uid,
          'email': user?.email,
          'jobTitle': _jobTitleController.text,
          'jobDiscription': _jobDiscriptionController.text,
          'jobDeadlinedate': _jobDeadlineController.text,
          'deadLineTimeStamp': deadLineTimeStamp,
          'jobCategory': _jobCategoryController.text,
          'jobComments': [],
          'recruitment': true,
          'createdat': Timestamp.now(),
          'name': name,
          'userImage': userImage,
          'location': location,
          'jobtype': _jobtypeController.text,
          'apllications': 0,
          'isDeadLineAvailable': isDeadLineAvailable,
          'endingDate': endingDate,
          'phone': phoneNumberr,
          'appliedusers': FieldValue.arrayUnion([])
        });
        await Fluttertoast.showToast(
            msg: 'the task has been  uploaded',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.grey,
            fontSize: 20);
        _jobTitleController.clear();
        _jobDiscriptionController.clear();
        _jobtypeController.clear;
        setState(() {
          selectedCategory = Persistent.jobCategoryList[0];
          _jobDeadlineController.text = 'Pick a Date';
        });
      } catch (eror) {
        {
          setState(() {
            _isloading = false;
          });
          // ignore: use_build_context_synchronously
          GlobalMethod.showErrorDialog(
              error: 'error while uploading files', ctx: context);
        }
      } finally {
        setState(() {
          _isloading = false;
        });
      }
    } else {
      // ignore: avoid_print
      print('its not valid');
    }
  } //upload task function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF716A76),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 2,
        toolbarHeight: 40,
        shadowColor: const Color(0xFFF5F5DC),
        backgroundColor: const Color(0xFFF5F5F5), // Beige
// Light Beige,
        title: const Center(
          child: Text('upload job ',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: ListView(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Please fill all fields',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 33),
                            child: reftextstyles(label: 'Job Category:'),
                          ),
                          Radio(
                            value: 'General',
                            activeColor: Colors.green,
                            groupValue: selectedCategory,
                            onChanged: (String? value) {
                              setState(() {
                                selectedCategory = value.toString();

                                _jobtypeController.text =
                                    selectedCategory.toString();
                                selectedJob = null;

                                k = 190;
                              });
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Text(
                              'General',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Radio(
                            value: 'Local',
                            groupValue: selectedCategory,
                            activeColor: Colors.green,
                            onChanged: (String? value) {
                              setState(() {
                                selectedCategory = value.toString();
                                _jobtypeController.text =
                                    selectedCategory.toString();

                                k = 230;
                                selectedJob = null;
                              });
                            },
                          ),
                          const Text('Local',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      uplcontt(
                        childd: Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: DropdownButton<String>(
                            icon: Padding(
                              padding: EdgeInsets.only(left: k),
                              child: const Icon(Icons.expand_circle_down_sharp),
                            ),
                            value: selectedJob,
                            hint: const Text(
                              'Select a job',
                              style: TextStyle(color: Colors.black),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedJob = newValue;
                                _jobCategoryController.text =
                                    selectedJob.toString();
                              });
                            },
                            items: categoryMap[selectedCategory]
                                ?.map((String job) {
                              return DropdownMenuItem<String>(
                                value: job,
                                child: Text(job),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 270, bottom: 0),
                        child: reftextstyles(label: 'Job title:'),
                      ),
                      uplcontt(
                        childd: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: reftextformfield(
                              valuekey: 'JobTitle',
                              refcontroller: _jobTitleController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 207),
                        child: reftextstyles(label: 'Job Discription:'),
                      ),
                      uplcontt(
                        childd: reftextformfield(
                            valuekey: 'jobDiscription',
                            refcontroller: _jobDiscriptionController,
                            enabled: true,
                            fct: () {},
                            maxLength: 100),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 225),
                        child: reftextstyles(label: 'Job Deadline:'),
                      ),
                      Stack(
                        children: [
                          uplcontt(
                            childd: reftextformfield(
                                valuekey: 'JobDeadline',
                                refcontroller: _jobDeadlineController,
                                enabled: false,
                                fct: () {
                                  pickDataDialog();
                                },
                                maxLength: 100),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 320, top: 8),
                            child: IconButton(
                              onPressed: pickDataDialog,
                              icon: const Icon(
                                Icons.date_range,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: _isloading
                      ? const CircularProgressIndicator()
                      : MaterialButton(
                          onPressed: () {
                            _uploadTask();
                          },
                          color: Colors.black,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Post now',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              SizedBox(
                                width: 9,
                              ),
                              Icon(
                                Icons.upload_file,
                                color: Colors.white,
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
}//main ui code
