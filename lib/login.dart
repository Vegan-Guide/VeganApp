import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'signin.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: [
          Text("Login", style: TextStyle(fontSize: 25)),
          Center(
              child: Column(
            children: [
              Text("Email"),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'example@example.com',
                ),
              ),
              Text("Password"),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    //fazer login
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email.text, password: password.text);
                  },
                  child: Text("Login")),
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SignInPage())));
                  },
                  child: Text("Registrar"),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
