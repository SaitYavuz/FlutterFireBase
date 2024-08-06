import 'package:flutter/material.dart';
import 'package:newfirebase/core/const/string.dart';
import 'package:newfirebase/custom/kayit_button_custom.dart';
import 'package:newfirebase/screen/login_screen.dart';
import 'package:newfirebase/services/auth_service.dart';

class SingOutScreen extends StatefulWidget {
  const SingOutScreen({super.key});

  @override
  State<SingOutScreen> createState() => _SingOutScreenState();
}

class _SingOutScreenState extends State<SingOutScreen> {
  final AuthService _authService = AuthService();

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      debugPrint("Oturum kapatma hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.cikisYap),
      ),
      body: Center(
        child: button(AppStrings.cikisYap, _signOut),
      ),
    );
  }
}
