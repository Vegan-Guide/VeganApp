import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';

import 'package:vegan_app/pages/auth/login.dart';
import 'package:vegan_app/pages/auth/signin.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _Welcome createState() => _Welcome();
}

class _Welcome extends State<WelcomePage> {
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: Stack(alignment: Alignment.center, children: [
      Scaffold(
          body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Image.asset('assets/images/welcome.png',
                width: MediaQuery.of(context).size.width * 0.9),
            Padding(
              padding: EdgeInsets.all(35),
              child: Text(
                "Experimente todas as possibilidades que preparamos para você.",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                      Globals.primaryColor,
                    )),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginPage())));
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => SignInPage())));
                    },
                    child: Text(
                      "Cadastrar-se",
                      style: TextStyle(color: Globals.primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // alguma coisa
                    },
                    child: Text(
                      "Entrar como convidado",
                      style: TextStyle(color: Globals.primaryColor),
                    ),
                  )
                ],
              ),
            )
          ]))
    ]));
  }
}
