import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'signin.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      routes: {
        '/': (context) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Perfil"),
                Text("Localização"),
                Text("Meus Pratos"),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => LoginPage())));
                  },
                  child: Text("Login"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => SignInPage())));
                  },
                  child: Text("Registrar"),
                )
              ],
            ),
        '/login': (context) => LoginPage()
      },
    );
  }
}
