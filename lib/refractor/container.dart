import 'package:flutter/material.dart';

class Refcontt extends StatelessWidget {
  final bool? check;
  final Widget? childd;
  final Widget? text;

  const Refcontt({Key? key, this.childd, this.text, this.check})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 460,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: check! ? Colors.grey.withOpacity(0.5) : Colors.transparent,
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            check! ? Colors.white : Color(0xFFECE2B6), // Gradient start color
            check! ? Color(0xFFECE2B6) : Colors.white, // Gradient end color
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: childd,
      ),
    );
  }
}

class uplcontt extends StatelessWidget {
  final Widget? childd;
  final Widget? text;

  const uplcontt({Key? key, this.childd, this.text}) : super(key: key);

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
      child: childd,
    );
  }
}
