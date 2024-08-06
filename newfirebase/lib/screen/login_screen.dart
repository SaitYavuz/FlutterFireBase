import 'package:flutter/material.dart';
import 'package:newfirebase/core/color/color.dart';
import 'package:newfirebase/core/const/circul.dart';
import 'package:newfirebase/core/const/double.dart';
import 'package:newfirebase/core/const/padiing.dart';
import 'package:newfirebase/core/const/string.dart';
import 'package:newfirebase/custom/divider_custom.dart';
import 'package:newfirebase/custom/kayit_button_custom.dart';
import 'package:newfirebase/custom/kayit_text_button_custom.dart';
//import 'package:newfirebase/custom/kayit_text_field_custom.dart';
import 'package:newfirebase/custom/size_boz_custom.dart';
import 'package:newfirebase/screen/photo_list_screen.dart';
import 'package:newfirebase/screen/register_screen.dart';
import 'package:newfirebase/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _login() async {
    final user = await _authService.signWithEmailAndPassword(
        _emailController.text, _passwordController.text);

    if (user != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.confirm),
          ),
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const PhotoListScreen()));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.girisBasarisiz),
          ),
        );
      }
      _emailController.text = "";
      _passwordController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.girisYap),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.padding16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              divider(),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: AppStrings.ePosta,
                  prefixIcon: const Icon(Icons.mail),
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
              ),
              sizeBox(),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppStrings.sifre,
                  prefixIcon: const Icon(Icons.password),
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
              ),
              sizeBox(),
              button(AppStrings.girisYap, _login),
              textButtonBottom(
                  context, AppStrings.uyeOl, const RegisterScreen())
            ],
          ),
        ),
      ),
    );
  }
}
