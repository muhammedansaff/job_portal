import 'package:JOBHUB/Jobs/jobs_screen.dart';
import 'package:JOBHUB/refractor/cachedimage.dart';
import 'package:JOBHUB/refractor/container.dart';
import 'package:JOBHUB/refractor/materialbutton.dart';

import 'package:JOBHUB/refractor/textform.dart';
import 'package:JOBHUB/refractor/textformfieldstyle.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:JOBHUB/ForgotPassword/forget_password_sreen.dart';
import 'package:JOBHUB/Services/global_methods.dart';
import 'package:JOBHUB/Services/global_variables.dart';
import 'package:JOBHUB/SignUpPage/signup_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  //variables
  late Animation<double> _animation;
  late AnimationController _animationController;

  final FocusNode _passFocusNode = FocusNode();
  // ignore: unused_field
  bool _isLoading = false;

  final TextEditingController _emailTextControler =
      TextEditingController(text: '');
  final TextEditingController _passTextController =
      TextEditingController(text: '');
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _loginFormKey = GlobalKey<FormState>();

  get child => null;

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextControler.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();

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
          ..addStatusListener((animationStatus) {});
    _animationController.forward();
    _animationController.repeat();
    super.initState();
  }

  void _submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailTextControler.text.trim().toLowerCase(),
            password: _passTextController.text.trim());

        // ignore: use_build_context_synchronously
        Navigator.canPop(context)
            // ignore: use_build_context_synchronously
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JobScreen(),
                ),
              )
            : null;
      } catch (error) {
        setState(
          () {
            _isLoading = false;
          },
        );
        // ignore: use_build_context_synchronously
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        // ignore: avoid_print
        print("error occured $error");
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Refimagecached(animation: _animation, imgurl: loginUrlImage),
          const SizedBox(height: 8.0),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 80, right: 80),
                    child: Image.asset('assets/images/login.png'),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        Refcontt(
                          childd: Reftxtfield(
                              deccc: deco('Email', 13, const SizedBox()),
                              typee: 'email',
                              inpp: TextInputType.emailAddress,
                              fnode: _passFocusNode,
                              txtcontroller: _emailTextControler),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Refcontt(
                          childd: Reftxtfield(
                            deccc: deco(
                              'Password',
                              13,
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            typee: 'password',
                            inpp: TextInputType.visiblePassword,
                            obsc: _obscureText,
                            tonode: _passFocusNode,
                            txtcontroller: _passTextController,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Forgetpassword(),
                                ),
                              );
                            },
                            child: const Text("Forget password ?",
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 17,
                                  fontStyle: FontStyle.italic,
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Bottun(
                          onPressed: _submitFormOnLogin,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buttontext('Login'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Do not have an account ?",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const TextSpan(text: '   '),
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUp(),
                                            ),
                                          ),
                                    text: 'Signup',
                                    style: bottomtextstyle),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
