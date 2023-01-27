import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final name = TextEditingController();
    final email = TextEditingController();
    final username = TextEditingController();

    if (user?.displayName != null) {
      name.text = (user?.displayName).toString();
    }
    if (user?.email != null) {
      email.text = (user?.email).toString();
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Editar perfil")),
      body: Card(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Perfil",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("Nome"),
                ),
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Seu nome',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("Usuário"),
                ),
                TextField(
                  controller: username,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Seu usuário',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("Email"),
                ),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'example@example.com',
                  ),
                ),
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          user?.updateDisplayName(name.text);
                          user?.updateEmail(email.text);
                          Navigator.pop(context);
                        },
                        child: Text("Editar")))
              ]),
        ),
      ),
    );
  }
}
