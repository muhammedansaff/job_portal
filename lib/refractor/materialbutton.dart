import 'package:flutter/material.dart';

class Bottun extends StatelessWidget {
  final VoidCallback? onPressed;

  final Widget child;
  const Bottun({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              foregroundColor:
                  const MaterialStatePropertyAll(Colors.blueAccent),
              overlayColor: const MaterialStatePropertyAll(Colors.greenAccent),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: child),
          ),
        ),
      ],
    );
  }
}

Text buttontext(String buttontext) {
  return Text(
    buttontext,
    style: const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
  );
}
