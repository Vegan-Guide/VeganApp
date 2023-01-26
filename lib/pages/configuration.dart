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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.white,
              child: Center(child: Text("FOTO")),
            ),
            Center(
                child: Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? "",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)))
          ]),
          Column(children: [
            Container(
                height: 50,
                child: Center(
                    child: GestureDetector(
                        onTap: (() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Profile()));
                        }),
                        child: Text("Perfil",
                            style: TextStyle(color: Colors.white))))),
            Container(
                height: 50,
                child: Center(
                    child:
                        Text("Amigos", style: TextStyle(color: Colors.white)))),
            Container(
                height: 50,
                child: Center(
                    child: Text("Localização",
                        style: TextStyle(color: Colors.white)))),
            Container(
                height: 50,
                child: Center(
                    child: Text("Meus Pratos",
                        style: TextStyle(color: Colors.white))))
          ])
        ]),
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
