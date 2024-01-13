import 'package:flutter/material.dart';

class Refcontt extends StatelessWidget {
  final Widget? childd;
  const Refcontt({super.key, this.childd});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 460,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          border: Border.all(width: 5, color: Colors.black),
          borderRadius: BorderRadius.circular(50),
        ),
        child: childd);
  }
}
