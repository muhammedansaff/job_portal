import 'package:flutter/material.dart';

class Contt extends StatelessWidget {
  final Widget childd;
  const Contt({super.key, required this.childd});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 460,
        decoration: BoxDecoration(
            color: Colors.black45,
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(50)),
        child: childd);
  }
}
