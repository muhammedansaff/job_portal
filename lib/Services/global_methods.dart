import 'package:flutter/material.dart';

class GlobalMethod {
  static void showErrorDialog(
      {required String error, required BuildContext ctx}) {
    showDialog(
      context: ctx,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context, error),
        );
      },
    );
  }

  static Widget contentBox(BuildContext context, String error) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            left: 16,
            top: 16,
            right: 16,
            bottom: 16,
          ),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFF3F2EA), // Cream
            // Light Beige,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 35,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Error Occurred!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                error,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
