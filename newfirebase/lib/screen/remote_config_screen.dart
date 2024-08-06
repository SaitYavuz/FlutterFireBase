import 'package:flutter/material.dart';
import 'package:newfirebase/core/const/string.dart';
import 'package:newfirebase/custom/kayit_button_custom.dart';
import 'package:newfirebase/screen/register_screen.dart';
import 'package:newfirebase/services/remote_config_service.dart';

class RemoteConfigScreen extends StatefulWidget {
  const RemoteConfigScreen({super.key});

  @override
  State<RemoteConfigScreen> createState() => _RemoteConfigScreenState();
}

class _RemoteConfigScreenState extends State<RemoteConfigScreen> {
  @override
  Widget build(BuildContext context) {
    final remoteConfig = FirebaseRemoteConfigService();
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.remoteConfig),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            ),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: remoteConfig
                  .getBool(FirebaseRemoteConfigKeys.imageVisibility),
              child: ListTile(
                title: Text(remoteConfig
                    .getString(FirebaseRemoteConfigKeys.welcomeMessage)),
                leading: Image.asset("assets/5.png", width: 50, height: 50),
              ),
            ),
            button(
              AppStrings.remoteConfig,
              () async {
                await remoteConfig.fetchAndActivate();
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}
