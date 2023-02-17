import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vegan_app/login.dart';
import 'package:vegan_app/pages/admin/myFavoriteRecipes.dart';
import 'package:vegan_app/pages/admin/myFavoriteRestaurants.dart';
import 'package:vegan_app/pages/admin/myRecipes.dart';
import 'package:vegan_app/pages/components/photo.dart';
import 'package:vegan_app/pages/profile.dart';

class ConfigPage extends StatefulWidget {
  final photoUrl;

  ConfigPage({this.photoUrl});

  _config createState() => _config();
}

class _config extends State<ConfigPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String url = "";

  Future getImage() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('users/${FirebaseAuth.instance.currentUser?.uid}.jpg');
    String fileUrl = await ref.getDownloadURL();
    print("fileUrl");
    print(fileUrl);
    setState(() {
      url = fileUrl;
    });
    return url;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    padding: EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getImage(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (url != "") {
                            return Container(
                                height: 100, child: Image.network(url));
                          }
                          return FotoContainer(
                              context: context, data: {}, width: 200);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )),
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
            ])),
            ListTile(
                title: Row(children: [
              Icon(Icons.favorite),
              Padding(
                  padding: EdgeInsets.all(10.00),
                  child: Center(
                      child: GestureDetector(
                    child: Text("Minhas Receitas Favoritas",
                        style: TextStyle(color: Colors.white)),
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MinhasReceitasFavoritas()));
                    }),
                  )))
            ])),
            ListTile(
                title: Row(children: [
              Icon(Icons.favorite),
              Padding(
                  padding: EdgeInsets.all(10.00),
                  child: Center(
                      child: GestureDetector(
                    child: Text("Meus Restaurantes Favoritos",
                        style: TextStyle(color: Colors.white)),
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MeusRestaurantesFavoritos()));
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
    ));
  }
}
