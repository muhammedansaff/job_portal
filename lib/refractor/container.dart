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
          color: Colors.black87,
          border: Border.all(width: 3, color: Colors.white70),
          borderRadius: BorderRadius.circular(10),
        ),
        child: childd);
  }
}
