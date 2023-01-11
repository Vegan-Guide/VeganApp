import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vegan_app/login.dart';
import 'package:vegan_app/pages/profile.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Center(
            child: Text(FirebaseAuth.instance.currentUser?.displayName ?? "")),
        Center(
            child: GestureDetector(
                onTap: (() {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Profile()));
                }),
                child: Text("Perfil"))),
        Center(child: Text("Localização")),
        Center(child: Text("Meus Pratos")),
        ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) => {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()))
                });
          },
          child: Text("Logout"),
        )
      ],
    );
  }
}
