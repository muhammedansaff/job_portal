import 'package:JOBHUB/Jobs/jobs_screen.dart';
import 'package:JOBHUB/Persistent/Persistent.dart';
import 'package:JOBHUB/Widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:JOBHUB/refractor/container.dart';

class UploadJobNow extends StatefulWidget {
  const UploadJobNow({super.key});

  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  final _formkey = GlobalKey<FormState>();
  final bool _isloading = false;
  DateTime? picked;
  Timestamp? deadLineTimeStamp;
  final TextEditingController _jobCategoryController =
      TextEditingController(text: 'Select Job Category');
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDiscriptionController =
      TextEditingController();
  final TextEditingController _jobDeadlineController =
      TextEditingController(text: 'Job Deadline Date');

  String selectedCategory = Persistent.jobCategoryList[0];

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
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
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
              return 'value is missing';
            }
            return null;
          },
          controller: refcontroller,
          enabled: enabled,
          key: ValueKey(valuekey),
          style: const TextStyle(
            color: Colors.black,
          ),
          maxLines: valuekey == 'jobDiscription' ? 3 : 1,
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
              '${picked!.year} - ${picked!.month} - ${picked!.day}';
          deadLineTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
              picked!.microsecondsSinceEpoch);
        },
      );
    }
  } //dialog box to select the date

  void _uploadTask() async {
    final joId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = FirebaseAuth.instance.currentUser!.uid;
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      if (_jobDeadlineController.text == 'choose job DeadLine date' ||
          _jobCategoryController.text == 'Choose job category') {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const FlowingWaterBackground(),
        Scaffold(
          bottomNavigationBar: BottomNavigationbarforapp(indexNum: 2),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 2,
            toolbarHeight: 40,
            shadowColor: const Color(0xFFF5F5DC),
            backgroundColor: const Color(0xFFF5F5DC), // Beige
// Light Beige,
            title: const Center(
              child: Text('upload job ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Please fill all fields',
                        style: TextStyle(color: Colors.black, fontSize: 30),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 240, bottom: 10),
                            child: reftextstyles(label: 'Job Category:'),
                          ),
                          uplcontt(
                            childd: Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: DropdownButton<String>(
                                value: selectedCategory,
                                hint: const Text(
                                  'select a job category',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                elevation: 16,
                                style: const TextStyle(
                                  color: Colors.black, // Change text color
                                  fontSize: 18,
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(
                                      () {
                                        selectedCategory = newValue;
                                        _jobCategoryController.text = newValue;
                                      },
                                    );
                                  }
                                },
                                items: Persistent.jobCategoryList
                                    .map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(
                                      category,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors
                                            .black, // Change item text color
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ), //selectbox for job
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 280, bottom: 0),
                            child: reftextstyles(label: 'Job title:'),
                          ),
                          uplcontt(
                            childd: reftextformfield(
                                valuekey: 'JobTitle',
                                refcontroller: _jobTitleController,
                                enabled: true,
                                fct: () {},
                                maxLength: 100),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 220),
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
                            padding: const EdgeInsets.only(right: 240),
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
                                padding:
                                    const EdgeInsets.only(left: 320, top: 8),
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
                              onPressed: () {},
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
        )
      ],
    );
  }
}//main ui code
