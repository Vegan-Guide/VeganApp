import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/listView.dart';

class MeusRestaurantesFavoritos extends StatefulWidget {
  const MeusRestaurantesFavoritos({super.key});
  @override
  _MeusRestaurantesFavoritos createState() => _MeusRestaurantesFavoritos();
}

class _MeusRestaurantesFavoritos extends State<MeusRestaurantesFavoritos> {
  @override
  Widget build(BuildContext context) {
    Future<void> refreshPage() async {
      setState(() {});
    }

    Query<Map<String, dynamic>> restaurantReference = FirebaseFirestore.instance
        .collection('restaurants')
        .where("favorites",
            arrayContains: FirebaseAuth.instance.currentUser?.uid);

    return Scaffold(
        appBar: AppBar(
          title: Text("Meus Restaurantes Favoritos"),
          backgroundColor: Globals.appBarBackgroundColor,
        ),
        body: RefreshIndicator(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Restaurantes",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              listViewResult(
                  collectionRef: restaurantReference, collection: "restaurants")
            ],
          )),
          onRefresh: () {
            return refreshPage();
            //
          },
        ));
  }
}
