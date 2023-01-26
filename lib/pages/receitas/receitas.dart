import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:vegan_app/pages/receitas/add.dart';
import 'package:vegan_app/pages/receitas/recipeTile.dart';

class Receitas extends StatefulWidget {
  const Receitas({super.key});

  _Receitas createState() => _Receitas();
}

class _Receitas extends State<Receitas> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> recipes = [];

  Future getRecipes() async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .get()
        .then(((values) => values.docs.forEach((value) {
              print(value);
              recipes.add(value.reference.id);
            })));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(children: [
          Center(child: Text("Receitas", style: TextStyle(fontSize: 25))),
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
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //algo aqui
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addReceita()));
            },
            child: Icon(Icons.add)));
  }
}
