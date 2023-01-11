import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(SignInPage());
}

class SignInPage extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: [
          Text("Registrar", style: TextStyle(fontSize: 25)),
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
                    //fazer registro
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email.text, password: password.text)
                        .then((value) => Navigator.pop(context))
                        .onError(
                            (error, stackTrace) => {print("Error ${error}")});
                  },
                  child: Text("Registrar"))
            ],
          ))
        ],
      ),
    );
  }
}
