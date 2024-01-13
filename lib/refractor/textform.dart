import 'package:JOBHUB/refractor/textformfieldstyle.dart';
import 'package:flutter/material.dart';

class Reftxtfield extends StatefulWidget {
  final String? typee;
  final Widget? childd;
  final FocusNode? fnode;
  final TextEditingController txtcontroller;
  final TextInputType inpp;
  final bool obsc;
  final FocusNode? tonode;

  final InputDecoration deccc;

  const Reftxtfield({
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
  State<Reftxtfield> createState() => _ReftxtfieldState();
}

class _ReftxtfieldState extends State<Reftxtfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: widget.obsc,
        cursorColor: Colors.black,
        textInputAction: TextInputAction.go,
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(widget.fnode);
        },
        focusNode: widget.tonode,
        keyboardType: widget.inpp,
        controller: widget.txtcontroller,
        style: newstyle,
        validator: (value) {
          String? rtntxt;
          if (widget.typee == 'email') {
            if (value!.isEmpty || !value.contains('@')) {
              String rtntxt = '   please enter a valid Email';
              return rtntxt;
            }
          }
          if (widget.typee == 'name') {
            if (value!.isEmpty) {
              String rtntxt = '   This field is missing';
              return rtntxt;
            }
          }
          if (widget.typee == 'password') {
            if (value!.isEmpty || value.length < 7) {
              String rtntxt = '   please Enter a valid password ';

              return rtntxt;
            }
          }
          if (widget.typee == 'number') {
            if (value!.isEmpty || value.length != 10) {
              String rtntxt = '   Enter a valid phone number';

              return rtntxt;
            }
          }
          if (widget.typee == 'adress') {
            if (value!.isEmpty) {
              String rtntxt = '   This field is missing';
              return rtntxt;
            }
          }

          return rtntxt;
        },
        decoration: widget.deccc);
  }
}
