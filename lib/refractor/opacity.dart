import 'package:flutter/material.dart';

class oppp extends StatelessWidget {
  final double rec;
  final Color col;
  const oppp({super.key, required this.rec, required this.col});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: rec,
      child: Icon(
        Icons.check_box,
        color: col,
      ),
    );
  }
}

class Txt extends StatelessWidget {
  final String txt;
  const Txt({super.key, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: const TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.black,
          fontWeight: FontWeight.normal),
    );
  }
}
