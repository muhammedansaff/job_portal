import 'package:JOBHUB/Jobs/jobs_screen.dart';
import 'package:JOBHUB/Persistent/Persistent.dart';
import 'package:JOBHUB/Widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          cursorColor: Colors.white,
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
          maxLines: valuekey == 'jobDiscription' ? 2 : 1,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.black54,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  } //refactored textformfield for uploadjob

  showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Job Category',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          content: SizedBox(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Persistent.jobCategoryList.length,
              itemBuilder: (ctxx, index) {
                return InkWell(
                  onTap: () {
                    if (mounted) {
                      setState(
                        () {
                          _jobCategoryController.text =
                              Persistent.jobCategoryList[index];
                        },
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_right_alt_outlined,
                        color: Colors.grey,
                      ),
                      Text(
                        Persistent.jobCategoryList[index],
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 17),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        );
      },
    );
  } //dialog box to select the job category

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const FlowingWaterBackground(),
        Scaffold(
          bottomNavigationBar: BottomNavigationbarforapp(indexNum: 2),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 10,
            toolbarHeight: 40,
            shadowColor: Colors.black,
            backgroundColor: Colors.blue,
            title: const Center(
              child: Text('upload job ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Card(
                color: Colors.white70,
                child: SingleChildScrollView(
                  child: Column(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 240, bottom: 0),
                                child: reftextstyles(label: 'Job Category:'),
                              ),
                              reftextformfield(
                                valuekey: 'jobCategory',
                                refcontroller: _jobCategoryController,
                                enabled: false,
                                fct: () {
                                  showTaskCategoriesDialog(size: size);
                                },
                                maxLength: 100,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 280),
                                child: reftextstyles(label: 'Job Title:'),
                              ),
                              reftextformfield(
                                  valuekey: 'JobTitle',
                                  refcontroller: _jobTitleController,
                                  enabled: true,
                                  fct: () {},
                                  maxLength: 100),
                              Padding(
                                padding: const EdgeInsets.only(right: 230),
                                child: reftextstyles(label: 'Job Discription:'),
                              ),
                              reftextformfield(
                                  valuekey: 'jobDiscription',
                                  refcontroller: _jobDiscriptionController,
                                  enabled: true,
                                  fct: () {},
                                  maxLength: 100),
                              Padding(
                                padding: const EdgeInsets.only(right: 250),
                                child: reftextstyles(label: 'Job Deadline:'),
                              ),
                              reftextformfield(
                                  valuekey: 'JobDeadline',
                                  refcontroller: _jobDeadlineController,
                                  enabled: false,
                                  fct: () {
                                    pickDataDialog();
                                  },
                                  maxLength: 100),
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
            ),
          ),
        )
      ],
    );
  }
}//main ui code
