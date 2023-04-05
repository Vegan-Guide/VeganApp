import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';

import 'package:vegan_app/pages/app.dart';
import 'package:vegan_app/signin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _Login createState() => _Login();
}

class _Login extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        // appBar: AppBar(title: Text("Login")),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('assets/images/logo.png', width: 200),
                // Text("Login", style: TextStyle(fontSize: 25)),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.all(10), child: Text("Email")),
                    TextField(
                      controller: emailController,
                      decoration: Globals.inputDecorationStyling,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10), child: Text("Password")),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: Globals.inputDecorationStyling,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          //fazer login
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text)
                              .then((value) => {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => App()))
                                  });
                        },
                        child: Text("Login")),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: RichText(
                            selectionColor: Color.fromARGB(174, 0, 0, 0),
                            text: TextSpan(text: "Não tem login? ", children: [
                              TextSpan(
                                  text: "Registrar",
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignInPage()));
                                    }),
                              TextSpan(text: " Aqui")
                            ]))),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Ainda não possui sua conta? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => SignInPage())));
                            },
                            child: Text(
                              "Registrar",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            )));
  }
}
