import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final userRef = FirebaseFirestore.instance.collection('users');

  final username = TextEditingController();
  final name = TextEditingController();
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
              Text("Nome"),
              TextField(
                controller: name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Seu nome',
                ),
              ),
              Text("Usuário"),
              TextField(
                controller: username,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Seu usuário',
                ),
              ),
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
                    CreateUser(context);
                  },
                  child: Text("Registrar"))
            ],
          ))
        ],
      ),
    );
  }

  Future CreateUser(context) async {
    List<String> users = [];
    await userRef
        .where("username", isEqualTo: username.text)
        .get()
        .then((values) => values.docs.forEach((element) {
              users.add(element.reference.id);
            }));
    if (users.length == 0) {
      //fazer registro
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) => {
                value.user?.updateDisplayName(name.text).then((value2) {
                  userRef.add({
                    "id": value.user?.uid,
                    "bio": "",
                    "photoURL": null,
                    "username": username.text
                  }).then((value) => Navigator.pop(context));
                })
              });
    }
  }
}
