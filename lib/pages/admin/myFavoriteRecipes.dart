import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/listView.dart';

class MinhasReceitasFavoritas extends StatefulWidget {
  const MinhasReceitasFavoritas({super.key});
  @override
  _MinhasReceitas createState() => _MinhasReceitas();
}

class _MinhasReceitas extends State<MinhasReceitasFavoritas> {
  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> recipesReference = FirebaseFirestore.instance
        .collection('recipes')
        .where("favorites",
            arrayContains: FirebaseAuth.instance.currentUser?.uid);

    Future<void> refreshPage() async {
      setState(() {});
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Minhas Receitas Favoritas"),
          backgroundColor: Globals.appBarBackgroundColor,
        ),
        body: RefreshIndicator(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Receitas",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              listViewResult(
                  collectionRef: recipesReference, collection: "recipes")
            ],
          )),
          onRefresh: () {
            return refreshPage();
          },
        ));
  }
}
