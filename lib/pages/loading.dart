import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnew/logic/diary/controllers.dart';
import 'package:dnew/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class LoadingPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        Intl.defaultLocale = 'ru_RU';
        initializeDateFormatting('ru_RU');

        await Firebase.initializeApp();
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;


        var user = FirebaseAuth.instance.currentUser;
        if (user?.isAnonymous ?? true) {
          await FirebaseAuth.instance.signOut();
          await Navigator.pushReplacementNamed(context, Routes.auth);
          return;
        }

        await context
            .read(diaryRecordControllerProvider.notifier)
            .listByUserId(user!.uid);

        Navigator.pushReplacementNamed(context, Routes.list);
      });
    });

    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Padding(padding: EdgeInsets.only(bottom: 8)),
          Text("Грузим записи...")
        ],
      )),
    );
  }
}
