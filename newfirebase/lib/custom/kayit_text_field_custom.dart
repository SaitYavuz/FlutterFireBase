import 'package:flutter/material.dart';
import 'package:newfirebase/core/color/color.dart';
import 'package:newfirebase/core/const/circul.dart';
import 'package:newfirebase/core/const/double.dart';

Widget textField({
  required String title,
  bool obs = false,
  required Icon ic,
  Icon? suf,
  TextEditingController? controller,
  VoidCallback? func,
}) {
  return TextField(
    onChanged: (value) => func,
    obscureText: obs,
    decoration: InputDecoration(
      labelText: title,
      prefixIcon: ic,
      suffixIcon: suf,
      border: OutlineInputBorder(
        borderRadius: AppCircul.circul12,
        borderSide: const BorderSide(
          color: AppColor.red,
          width: AppDouble.with2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppCircul.circul12,
        borderSide: const BorderSide(
          color: AppColor.purpleAccent,
          width: AppDouble.with2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppCircul.circul12,
        borderSide: const BorderSide(
          color: AppColor.deepPurple,
          width: AppDouble.with1,
        ),
      ),
    ),
  );
}

