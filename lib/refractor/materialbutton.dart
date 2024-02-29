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
              backgroundColor:
                  const MaterialStatePropertyAll(Color(0xFFF5F5DC)),
              foregroundColor: const MaterialStatePropertyAll(Colors.red),
              overlayColor: const MaterialStatePropertyAll(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7), child: child),
          ),
        ),
      ],
    );
  }
} //refactored material button

Text buttontext(String buttontext) {
  return Text(
    buttontext,
    style: const TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
  );
}
