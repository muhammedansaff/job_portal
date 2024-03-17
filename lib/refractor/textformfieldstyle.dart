import 'package:flutter/material.dart';

const TextStyle newstyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

InputDecoration passdeco(String hint, double topp, Widget childd) {
  return InputDecoration(
      suffixIcon: childd,
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.only(left: 10, top: topp),
      hintText: hint,
      hintStyle: const TextStyle(color: Color.fromARGB(137, 41, 39, 39)),
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none);
}

InputDecoration deco(
  String hint,
  double topp,
) {
  return InputDecoration(
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.only(left: 10, top: topp, bottom: 5),
      hintText: hint,
      hintStyle: const TextStyle(color: Color.fromARGB(137, 41, 39, 39)),
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none);
}

const TextStyle bottomtextstyle = TextStyle(
  color: Color(0xFFF5F5DC),
  fontWeight: FontWeight.bold,
  fontSize: 16,
);
