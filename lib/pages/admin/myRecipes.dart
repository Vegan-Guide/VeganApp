import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/listView.dart';
import 'package:vegan_app/pages/receitas/add.dart';

class MinhasReceitas extends StatefulWidget {
  const MinhasReceitas({super.key});
  @override
  _MinhasReceitas createState() => _MinhasReceitas();
}

class _MinhasReceitas extends State<MinhasReceitas> {
  @override
  Future<void> refreshPage() async {
    setState(() {});
  }

  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> recipesReference = FirebaseFirestore.instance
        .collection('recipes')
        .where("author_uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid);

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Globals.drawerIconColor), //add this line here
          title: Text("Minhas Receitas"),
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
            //
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //algo aqui
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addReceita()));
            },
            child: Icon(Icons.add)));
  }
}
