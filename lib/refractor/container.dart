import 'package:flutter/material.dart';

class Refcontt extends StatelessWidget {
  final bool? check;
  final Widget? childd;
  final Widget? text;
  const Refcontt({super.key, this.childd, this.text, this.check});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 460,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          border: Border.all(
              width: 2,
              color: check!
                  ? const Color(0xFFF5F5DC)
                  : const Color.fromARGB(255, 0, 130, 235)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: childd);
  }
}

class uplcontt extends StatelessWidget {
  final Widget? childd;
  final Widget? text;
  const uplcontt({super.key, this.childd, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 460,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          border: Border.all(width: 4, color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        child: childd);
  }
}//refactored container for the style of each textbox
