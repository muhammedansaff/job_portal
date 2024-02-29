// ignore_for_file: unused_element

import 'package:JOBHUB/Services/global_methods.dart';
import 'package:JOBHUB/Services/global_variables.dart';
import 'package:JOBHUB/login/login_screen.dart';
import 'package:JOBHUB/refractor/materialbutton.dart';
import 'package:JOBHUB/refractor/textformfieldstyle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:JOBHUB/refractor/container.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _forgetPasswordController =
      TextEditingController(text: '');

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

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
  } //animation for forgot password

  void _forgetPasswordSubmitForm() async {
    try {
      await _auth.sendPasswordResetEmail(email: _forgetPasswordController.text);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Login()));
    } catch (error) {
      // ignore: use_build_context_synchronously
      GlobalMethod.showErrorDialog(error: "Email not found", ctx: context);
    } //error on email
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImage,
            placeholder: (context, url) => Image.asset(
              'assets/images/loading.gif',
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Forget Password',
                  style: TextStyle(
                      color: Color(0xFFF5F5DC),
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      fontFamily: 'newfont'),
                ),
                const SizedBox(
                  height: 50,
                ),
                Refcontt(
                  childd: TextField(
                    cursorColor: Colors.white,
                    style: newstyle,
                    controller: _forgetPasswordController,
                    decoration: deco(
                      'EmailAdress',
                      13,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Bottun(
                      onPressed: _forgetPasswordSubmitForm,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [buttontext('Reset')],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        height: 40,
                        width: 30,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.canPop(context)
                                ? Navigator.pop(context)
                                : null;
                          },
                          child: Image.asset('assets/images/back.png'),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
