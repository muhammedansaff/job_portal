import 'package:flutter/material.dart';

const TextStyle newstyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

InputDecoration deco(String hint) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 5),
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white),
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
  );
}
