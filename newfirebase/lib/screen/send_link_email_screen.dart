import 'package:flutter/material.dart';
import 'package:newfirebase/core/color/color.dart';
import 'package:newfirebase/core/const/circul.dart';
import 'package:newfirebase/core/const/double.dart';
import 'package:newfirebase/core/const/padiing.dart';
import 'package:newfirebase/core/const/string.dart';
import 'package:newfirebase/custom/divider_custom.dart';
import 'package:newfirebase/custom/kayit_button_custom.dart';
import 'package:newfirebase/custom/kayit_text_button_custom.dart';
import 'package:newfirebase/custom/size_boz_custom.dart';
import 'package:newfirebase/screen/login_screen.dart';
import 'package:newfirebase/screen/register_screen.dart';
import 'package:newfirebase/screen/sing_out_screen.dart';
import 'package:newfirebase/services/auth_service.dart';

class SendLinkEmailScreen extends StatefulWidget {
  const SendLinkEmailScreen({super.key});

  @override
  State<SendLinkEmailScreen> createState() => _SendLinkEmailScreenState();
}

class _SendLinkEmailScreenState extends State<SendLinkEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> _send() async {
    try {
      await _authService.sendSignInLinkToEmail(_emailController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.linkSent),
          ),
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SingOutScreen()));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.linkSendError),
          ),
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RegisterScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.ePostaKod),
      ),
      body: Center(
        child: Padding(
          padding: AppPadding.padding12,
          child: Column(
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
              button(AppStrings.ePostaKod, _send),
              textButtonBottom(
                  context, AppStrings.girisYap, const LoginScreen())
            ],
          ),
        ),
      ),
    );
  }
}
