import 'dart:io';

import 'package:JOBHUB/Services/global_methods.dart';
import 'package:JOBHUB/Services/global_variables.dart';
import 'package:JOBHUB/login/login_screen.dart';
import 'package:JOBHUB/refractor/cachedimage.dart';
import 'package:JOBHUB/refractor/container.dart';
import 'package:JOBHUB/refractor/materialbutton.dart';
import 'package:JOBHUB/refractor/textfield/secondtxtfield.dart';
import 'package:JOBHUB/refractor/textfield/textform.dart';
import 'package:JOBHUB/refractor/textformfieldstyle.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
//import 'package:JOBHUB/SignUpPage/my_slide_show.dart';

class SignUp extends StatefulWidget {
  final String check;
  const SignUp({super.key, required this.check});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  //variables
  late Animation<double> _animation;
  late AnimationController _animationController;
  final TextEditingController _fullNameConroller =
      TextEditingController(text: '');

  final TextEditingController _emailtexttConroller =
      TextEditingController(text: '');

  final TextEditingController _passwordtexttConroller =
      TextEditingController(text: '');

  final TextEditingController _phoneNumberConroller =
      TextEditingController(text: '');

  final TextEditingController _locationConroller =
      TextEditingController(text: '');
  final TextEditingController _imgcontroller = TextEditingController(text: '');
  final TextEditingController _proffesioncontroller =
      TextEditingController(text: '');

  final _signupFormKey = GlobalKey<FormState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _positionFocusNode = FocusNode();

  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isloading = false;
  bool _obscureText = true;
  String? imageUrl;
  bool? finder;
  String? idurl;

  //focus nodes and textediting controlls
  @override
  void dispose() {
    _fullNameConroller.dispose();
    _emailtexttConroller.dispose();
    _passwordtexttConroller.dispose();
    _phoneNumberConroller.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _positionFocusNode.dispose();
    _phoneFocusNode.dispose();
    _animationController.dispose();
    _imgcontroller.dispose();
    _proffesioncontroller.dispose();

    super.dispose();
  } //dispose function

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            // ignore: unrelated_type_equality_checks
            if (AnimationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    _animationController.repeat();
    checker();
    super.initState();
  } //animation background

//variables
  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('please choose an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  _getFromCamera();
                },
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.15),
                      child: Icon(
                        Icons.camera,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "camera",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _getFromGallery();
                },
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.15),
                      child: Icon(
                        Icons.image,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "gallery",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
  //camera function

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _cropimage(pickedFile.path);
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    _cropimage(pickedFile!.path);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _cropimage(filePath) async {
    CroppedFile? croppedimage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1580, maxWidth: 1580);
    if (croppedimage != null) {
      setState(
        () {
          imageFile = File(croppedimage.path);
        },
      );
    }
  } //gallery image function

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload a photo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a photo'),
                onTap: () {
                  _getid(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Choose from gallery'),
                onTap: () {
                  _getid(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void forWorker() async {
    final isValid = _signupFormKey.currentState!.validate();
    if (isValid) {
      if (imageFile == null && _image == null) {
        GlobalMethod.showErrorDialog(
            error: "please pick an image", ctx: context);
        return;
      }
      setState(() {
        _isloading = true;
      });

      try {
        final uid = const Uuid().v4();

        final fer = FirebaseStorage.instance
            .ref()
            .child('workersprofile')
            .child('$uid.jpg');
        await fer.putFile(imageFile!);
        imageUrl = await fer.getDownloadURL();
        final ref =
            FirebaseStorage.instance.ref().child('workers').child('$uid.jpg');
        if (_image != null) {
          await ref.putFile(_image!);
        } else {
          // Handle case where _image is null
          return;
        }
        final idurl = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('workers').doc(uid).set(
          {
            'id': uid,
            'password': _passwordtexttConroller.text,
            'name': _fullNameConroller.text,
            'email': _emailtexttConroller.text,
            'userImage': imageUrl,
            'phoneNumber': _phoneNumberConroller.text,
            'status': false,
            'createAt': Timestamp.now(),
            'myId': idurl,
            'profession': _proffesioncontroller.text,
            'isWorker': true, // Make sure to get text from controller
          },
        );

        // Navigate after successful upload
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      } catch (error) {
        setState(() {
          _isloading = false;
        }); // Stop loading indicator

        // Show error dialog
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    }
  }

  void forUser() async {
    final isValid = _signupFormKey.currentState!.validate();

    if (isValid) {
      if (imageFile == null) {
        GlobalMethod.showErrorDialog(
            error: "please pick an image", ctx: context);
        return;
      }

      setState(() {
        _isloading = true;
      });

      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailtexttConroller.text.trim().toLowerCase(),
            password: _passwordtexttConroller.text.trim());
        final User? user = _auth.currentUser;
        final uid = user!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child('$uid.jpg');
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(uid).set(
          {
            'id': uid,
            'name': _fullNameConroller.text,
            'email': _emailtexttConroller.text,
            'userImage': imageUrl,
            'phoneNumber': _phoneNumberConroller.text,
            'location': _locationConroller.text,
            'createAt': Timestamp.now(),
          },
        );
        FirebaseFirestore.instance.collection('workeranduser').doc(uid).set(
          {
            'id': uid,
            'name': _fullNameConroller.text,
            'email': _emailtexttConroller.text,
            'isWorker': false,
            'phoneNumber': _phoneNumberConroller.text,
            'userImage': imageUrl
          },
        );
        // ignore: use_build_context_synchronously

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      } catch (error) {
        setState(() {
          _isloading = false;
        }); //authentication

        // ignore: use_build_context_synchronously
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    }

    setState(() {
      _isloading = false;
    });
  } //submit function

  void checker() {
    if (widget.check == "user") {
      setState(() {
        finder = true;
        print(widget.check);
      });
    } else {
      setState(() {
        finder = false;
        print(widget.check);
      });
    }

    print(finder);
  }

  File? _image;
  Future<void> _getid(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        // Set the file name to the text field
        _imgcontroller.text = _image!.path.split('/').last;
        print(_image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Refimagecached(animation: _animation, imgurl: loginUrlImage),
          Container(
            color: Colors.black38,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 25, right: 25),
              child: ListView(
                children: [
                  Form(
                    key: _signupFormKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showImageDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: const Color(0xFFECE5B6),
                                      width: 2)),
                              child: ClipOval(
                                child: imageFile == null
                                    ? Image.asset(
                                        'assets/images/ansaf.png',
                                        scale: 11,
                                      )
                                    : Image.file(
                                        imageFile!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),

                        Refcontt(
                          check: finder,
                          childd: Reftxtfield(
                              deccc: deco(
                                'Full Name/Company Name',
                                4,
                              ),
                              typee: 'name',
                              inpp: TextInputType.name,
                              fnode: _emailFocusNode,
                              txtcontroller: _fullNameConroller),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Refcontt(
                          check: finder,
                          childd: Reftxtfield(
                            deccc: deco(
                              'Email',
                              2,
                            ),
                            typee: 'email',
                            inpp: TextInputType.emailAddress,
                            fnode: _passwordFocusNode,
                            txtcontroller: _emailtexttConroller,
                            tonode: _emailFocusNode,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Refcontt(
                          check: finder,
                          childd: Reftxtfield(
                            deccc: passdeco(
                              'Password',
                              12,
                              GestureDetector(
                                onTap: () {
                                  setState(
                                    () {
                                      _obscureText = !_obscureText;
                                    },
                                  );
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            obsc: _obscureText,
                            typee: 'password',
                            inpp: TextInputType.visiblePassword,
                            fnode: _phoneFocusNode,
                            txtcontroller: _passwordtexttConroller,
                            tonode: _passwordFocusNode,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //passwordtextbox
                        Refcontt(
                          check: finder,
                          childd: Reftxtfield(
                            deccc: deco(
                              'Phone No',
                              4,
                            ),
                            typee: 'number',
                            inpp: TextInputType.phone,
                            fnode: _positionFocusNode,
                            txtcontroller: _phoneNumberConroller,
                            tonode: _phoneFocusNode,
                          ),
                        ),
                        //phonenumber
                        const SizedBox(
                          height: 15,
                        ),
                        finder!
                            ? Refcontt(
                                check: finder,
                                childd: passtxtfield(
                                    deccc: deco(
                                      'Adress/Company',
                                      4,
                                    ),
                                    typee: 'adress',
                                    inpp: TextInputType.streetAddress,
                                    tonode: _positionFocusNode,
                                    txtcontroller: _locationConroller),
                              )
                            : Refcontt(
                                check: finder,
                                childd: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _showImagePickerDialog(context);
                                      },
                                      child: TextField(
                                        controller: _imgcontroller,
                                        enabled: false, // Disable editing
                                        decoration: const InputDecoration(
                                          hintText: ' Tap to upload your Id',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 13, right: 13),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(Icons.photo),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: !finder!,
                          child: Refcontt(
                            check: finder,
                            childd: Reftxtfield(
                              deccc: deco("profession", 0),
                              inpp: TextInputType.text,
                              typee: "prof",
                              txtcontroller: _proffesioncontroller,
                            ),
                          ),
                        ),

                        //adress),
                        const SizedBox(
                          height: 50,
                        ),

                        _isloading
                            ? const Center(
                                child: SizedBox(
                                  width: 35,
                                  height: 35,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              )
                            : Bottun(
                                onPressed: () {
                                  if (widget.check == "user") {
                                    forUser();
                                  } else {
                                    forWorker();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [buttontext('SignUp')],
                                ),
                              ),

                        const SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Already have an account?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const TextSpan(text: "  "),
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login(),
                                            ),
                                          ),
                                    text: "login",
                                    style: bottomtextstyle)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}//textfield design
