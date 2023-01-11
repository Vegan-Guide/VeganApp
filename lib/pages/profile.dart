import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final name = TextEditingController();
    if (user?.displayName != null) {
      name.text = (user?.displayName).toString();
    }
    final email = TextEditingController();
    if (user?.email != null) {
      email.text = (user?.email).toString();
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Editar perfil")),
      body: Card(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Text("Nome"),
          ),
          TextField(
            controller: name,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Seu nome',
            ),
          ),
          Center(
            child: Text("Email"),
          ),
          TextField(
            controller: email,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'example@example.com',
            ),
          ),
          ElevatedButton(
              onPressed: () {
                user?.updateDisplayName(name.text);
                user?.updateEmail(email.text);
                Navigator.pop(context);
              },
              child: Text("Editar"))
        ]),
      ),
    );
  }
}
