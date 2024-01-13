import 'dart:io';

import 'package:JOBHUB/Services/global_methods.dart';
import 'package:JOBHUB/Services/global_variables.dart';
import 'package:JOBHUB/login/login_screen.dart';
import 'package:JOBHUB/refractor/cachedimage.dart';
import 'package:JOBHUB/refractor/container.dart';
import 'package:JOBHUB/refractor/materialbutton.dart';
import 'package:JOBHUB/refractor/textform.dart';
import 'package:JOBHUB/refractor/textformfieldstyle.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:JOBHUB/SignUpPage/my_slide_show.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

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

  final _signupFormKey = GlobalKey<FormState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _positionFocusNode = FocusNode();

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
    super.initState();
  } //animation background

  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isloading = false;
  bool _obscureText = true;
  String? imageUrl;

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
                      padding: EdgeInsets.all(4.10),
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
                      padding: EdgeInsets.all(4.10),
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
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedimage != null) {
      setState(() {
        imageFile = File(croppedimage.path);
      });
    }
  } //gallery image function

  void _submitFormssOnignup() async {
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
        // ignore: use_build_context_synchronously
        Navigator.canPop(context)
            // ignore: use_build_context_synchronously
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              )
            : null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Refimagecached(animation: _animation, imgurl: signupimageurl),
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
                            padding: const EdgeInsets.only(top: 1),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: ClipOval(
                                child: imageFile == null
                                    ? Image.asset(
                                        'assets/images/ansaf.png',
                                        scale: 10,
                                      )
                                    : Image.file(
                                        imageFile!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Refcontt(
                          childd: Reftxtfield(
                              deccc: deco('Full Name/Company Name', 12,
                                  const SizedBox()),
                              typee: 'name',
                              inpp: TextInputType.name,
                              fnode: _emailFocusNode,
                              txtcontroller: _fullNameConroller),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Refcontt(
                          childd: Reftxtfield(
                            deccc: deco(
                              'Email',
                              12,
                              const SizedBox(),
                            ),
                            typee: 'email',
                            inpp: TextInputType.emailAddress,
                            fnode: _passwordFocusNode,
                            txtcontroller: _emailtexttConroller,
                            tonode: _emailFocusNode,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Refcontt(
                          childd: Reftxtfield(
                            deccc: deco(
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
                                  color: Colors.white,
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
                          height: 10,
                        ),
                        //passwordtextbox
                        Refcontt(
                            childd: Reftxtfield(
                          deccc: deco('Phone No', 12, const SizedBox()),
                          typee: 'number',
                          inpp: TextInputType.phone,
                          fnode: _positionFocusNode,
                          txtcontroller: _phoneNumberConroller,
                          tonode: _phoneFocusNode,
                        )),
                        //phonenumber
                        const SizedBox(
                          height: 10,
                        ),
                        Refcontt(
                          childd: Reftxtfield(
                              deccc:
                                  deco('Adress/Company', 12, const SizedBox()),
                              typee: 'adress',
                              inpp: TextInputType.streetAddress,
                              tonode: _positionFocusNode,
                              txtcontroller: _locationConroller),
                        ), //adress),
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
                                onPressed: _submitFormssOnignup,
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
                                const TextSpan(text: "    "),
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.canPop(context)
                                          ? Navigator.pop(context)
                                          : null,
                                    text: "Login",
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
