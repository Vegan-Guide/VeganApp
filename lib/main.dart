import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';

import 'package:vegan_app/login.dart';
import 'package:vegan_app/pages/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, loggedin: false});

  @override
  State<MyApp> createState() => _LoginState();
}

class _LoginState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (FirebaseAuth.instance.currentUser != null) {
      return MaterialApp(
        home: App(),
      );
    } else {
      return MaterialApp(
        home: LoginPage(),
      );
    }
  }
}
