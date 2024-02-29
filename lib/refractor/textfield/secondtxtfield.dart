import 'package:JOBHUB/refractor/textformfieldstyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class passtxtfield extends StatefulWidget {
  final String? typee;
  final Widget? childd;
  final FocusNode? fnode;
  final TextEditingController txtcontroller;
  final TextInputType inpp;
  final bool obsc;
  final FocusNode? tonode;

  final InputDecoration deccc;

  const passtxtfield({
    this.tonode,
    required this.deccc,
    super.key,
    this.obsc = false,
    required this.typee,
    required this.inpp,
    this.childd,
    this.fnode,
    required this.txtcontroller,
  });

  @override
  State<passtxtfield> createState() => _passtxtfieldState();
}

class _passtxtfieldState extends State<passtxtfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: widget.obsc,
        cursorColor: Colors.black,
        textInputAction: TextInputAction.go,
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        focusNode: widget.tonode,
        keyboardType: widget.inpp,
        controller: widget.txtcontroller,
        style: newstyle,
        validator: (value) {
          String? rtntxt;

          if (widget.typee == 'password') {
            if (value!.isEmpty || value.length < 7) {
              showToast("please Enter a valid password ");

              return rtntxt;
            }
          }

          if (widget.typee == 'adress') {
            if (value!.isEmpty) {
              showToast("please Enter your adress");
              return rtntxt;
            }
          }

          return rtntxt;
        },
        decoration: widget.deccc);
  }

  double toastPosition = 0.0;
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
      webPosition: "center",
      webBgColor: "#e74c3c",
      webShowClose: true,
    );
    setState(() {
      toastPosition += 50.0;
    });
  }
}// refactored textbox for password and adress only
