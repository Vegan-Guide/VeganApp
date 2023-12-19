import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';

import 'package:vegan_app/pages/auth/login.dart';
import 'package:vegan_app/pages/admin/myFavoriteRecipes.dart';
import 'package:vegan_app/pages/admin/myFavoriteRestaurants.dart';
import 'package:vegan_app/pages/admin/myRecipes.dart';
import 'package:vegan_app/pages/components/photo.dart';
import 'package:vegan_app/pages/profile.dart';

class ConfigPage extends StatefulWidget {
  final userData;

  ConfigPage({this.userData});

  _config createState() => _config();
}

class _config extends State<ConfigPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String url = "";

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
                    child: (widget.userData['photoURL'] != null)
                        ? Container(
                            height: 150,
                            width: 150,
                            child: Image.network(
                              widget.userData['photoURL'],
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ));
                                }
                              },
                            ))
                        : FotoContainer(
                            context: context, data: {}, width: 200)),
                Center(
                    child: Expanded(
                        child: Text(
                            (FirebaseAuth.instance.currentUser?.displayName ??
                                "Usuário"),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                color: Globals.drawerTextColor)))),
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
                              style:
                                  TextStyle(color: Globals.drawerTextColor)))))
            ])),
            // ListTile(
            //     title: Row(children: [
            //   Icon(Icons.group),
            //   Padding(
            //       padding: EdgeInsets.all(10.00),
            //       child: Center(
            //           child: Text("Amigos",
            //               style: TextStyle(color: Globals.drawerTextColor))))
            // ])),
            ListTile(
                title: Row(children: [
              Icon(Icons.restaurant_menu),
              Padding(
                  padding: EdgeInsets.all(10.00),
                  child: Center(
                      child: GestureDetector(
                    child: Text("Meus Pratos",
                        style: TextStyle(color: Globals.drawerTextColor)),
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
                        style: TextStyle(color: Globals.drawerTextColor)),
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
                        style: TextStyle(color: Globals.drawerTextColor)),
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MeusRestaurantesFavoritos()));
                    }),
                  )))
            ])),
            ListTile(
                title: Row(children: [
              Icon(Icons.logout),
              Padding(
                  padding: EdgeInsets.all(10.00),
                  child: Center(
                      child: GestureDetector(
                    child: Text("Logout",
                        style: TextStyle(color: Globals.drawerTextColor)),
                    onTap: (() {
                      FirebaseAuth.instance.signOut().then((value) => {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()))
                          });
                    }),
                  )))
            ]))
          ])
        ]),
      ],
    ));
  }
}
