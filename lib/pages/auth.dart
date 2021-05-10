import 'package:dnew/logic/settings/controllers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../routes.dart';

class AuthPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var isDarkMode = useProvider(isDarkModeProvider);

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Надо бы войти"),
          SizedBox(height: 10),
          SignInButton(
            isDarkMode ? Buttons.GoogleDark : Buttons.Google,
            onPressed: () async {
              await signInByGoogle();
              Navigator.pushReplacementNamed(context, Routes.loading);
            },
          ),
        ],
      ),
    ));
  }

  Future<User> signInByGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    var googleAuth = await googleUser!.authentication;
    var credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var fbCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return fbCredential.user!;
  }
}
