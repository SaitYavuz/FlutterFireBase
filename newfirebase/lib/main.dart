import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newfirebase/core/color/color.dart';
import 'package:newfirebase/screen/login_screen.dart';
import 'package:newfirebase/services/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseRemoteConfigService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Base',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
