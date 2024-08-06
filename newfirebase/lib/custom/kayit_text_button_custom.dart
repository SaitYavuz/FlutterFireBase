import 'package:flutter/material.dart';

Widget textButtonBottom(BuildContext context, String text, Widget screen) {
  return TextButton(
    onPressed: () => Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => screen)),
    child: Text(text),
  );
}
