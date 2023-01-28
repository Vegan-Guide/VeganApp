import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vegan_app/login.dart';
import 'package:vegan_app/pages/admin/myRecipes.dart';
import 'package:vegan_app/pages/profile.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  width: 100,
                  height: 100,
                  color: Colors.white,
                  child: Center(child: Text("FOTO")),
                ),
                Center(
                    child: Expanded(
                        child: Text(
                            (FirebaseAuth.instance.currentUser?.displayName ??
                                "Usuário"),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white)))),
                Divider(
                  height: 20,
                  thickness: 5,
                )
              ])),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ListTile(
                title: Row(children: [
              Icon(Icons.person),
              Padding(
                  padding: EdgeInsets.all(10.00),
                  child: Center(
                      child: GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Profile()));
                          }),
                          child: Text("Perfil",
                              style: TextStyle(color: Colors.white)))))
            ])),
            ListTile(
                title: Row(children: [
              Icon(Icons.group),
              Padding(
                  padding: EdgeInsets.all(10.00),
                  child: Center(
                      child: Text("Amigos",
                          style: TextStyle(color: Colors.white))))
            ])),
            ListTile(
                title: Row(children: [
              Icon(Icons.restaurant_menu),
              Padding(
                  padding: EdgeInsets.all(10.00),
                  child: Center(
                      child: GestureDetector(
                    child: Text("Meus Pratos",
                        style: TextStyle(color: Colors.white)),
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MinhasReceitas()));
                    }),
                  )))
            ]))
          ])
        ]),
        Container(
            margin: EdgeInsets.all(10.00),
            child: ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) => {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()))
                    });
              },
              child: Row(children: [
                Padding(
                    padding: EdgeInsets.all(2.00), child: Icon(Icons.settings)),
                Text("Logout")
              ]),
            ))
      ],
    );
  }
}
