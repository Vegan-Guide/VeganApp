import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:vegan_app/pages/receitas/add.dart';
import 'package:vegan_app/pages/receitas/categorieTile.dart';
import 'package:vegan_app/pages/receitas/recipeTile.dart';

class MinhasReceitas extends StatefulWidget {
  const MinhasReceitas({super.key});

  _Receitas createState() => _Receitas();
}

class _Receitas extends State<MinhasReceitas>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> recipes = [];
  List<String> categories = [];

  Future getRecipes() async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then(((values) => values.docs.forEach((value) {
              if (!recipes.contains(value.reference.id)) {
                recipes.add(value.reference.id);
              }
            })));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Minhas Receitas"),
        ),
        body: RefreshIndicator(
            onRefresh: () {
              setState(() {});
              return getRecipes();
            },
            child: Column(children: [
              Center(child: Text("Receitas", style: TextStyle(fontSize: 30))),
              FutureBuilder(
                future: getRecipes(),
                builder: (context, snapshot) {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: getRecipe(
                          documentId: recipes[index],
                          tileWidth: 0.9,
                          flexDirection: "horizontal",
                        ),
                      );
                    },
                  ));
                },
              ),
            ])),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //algo aqui
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addReceita()));
            },
            child: Icon(Icons.add)));
  }
}
