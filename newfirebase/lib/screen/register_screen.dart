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
import 'package:newfirebase/screen/login_screen.dart';
import 'package:newfirebase/screen/remote_config_screen.dart';
import 'package:newfirebase/screen/send_link_email_screen.dart';
import 'package:newfirebase/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _register() async {
    try {
      final user = await _authService.createUserWithEmailAndPassword(
          _emailController.text, _passwordController.text);

      if (user != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.kayitBasarili),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.kayitBasarisiz + error.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.kayitOl),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.padding12,
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
              button(AppStrings.kayitOl, _register),
              textButtonBottom(
                context,
                AppStrings.zatenUyeMisiniz,
                const LoginScreen(),
              ),
              textButtonBottom(
                context,
                AppStrings.ePostaKod,
                const SendLinkEmailScreen(),
              ),
              textButtonBottom(
                context,
                AppStrings.remoteConfig,
                const RemoteConfigScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
