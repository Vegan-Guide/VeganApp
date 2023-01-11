import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'signin.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Center(child: Text(FirebaseAuth.instance.currentUser.email ?? "")),
        Center(child: Text("Perfil")),
        Center(child: Text("Localização")),
        Center(child: Text("Meus Pratos")),
        ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: Text("Logout"),
        )
      ],
    );
  }
}
