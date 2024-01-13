import 'package:flutter/material.dart';

const TextStyle newstyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

InputDecoration deco(String hint, double topp, Widget childd) {
  return InputDecoration(
      suffixIcon: childd,
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.only(left: 10, top: topp),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black87),
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none);
}

const TextStyle bottomtextstyle = TextStyle(
    color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16);
