import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:vegan_app/pages/receitas/add.dart';
import 'package:vegan_app/pages/receitas/categorieTile.dart';
import 'package:vegan_app/pages/receitas/recipeTile.dart';

class Receitas extends StatefulWidget {
  const Receitas({super.key});

  _Receitas createState() => _Receitas();
}

class _Receitas extends State<Receitas> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> recipes = [];
  List<String> categories = [];

  Future getRecipes() async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .get()
        .then(((values) => values.docs.forEach((value) {
              recipes.add(value.reference.id);
            })));
  }

  Future getCategories() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then(((values) => values.docs.forEach((value) {
              categories.add(value.reference.id);
            })));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () {
              setState(() {});
              return getRecipes();
            },
            child: Column(children: [
              Center(child: Text("Categorias", style: TextStyle(fontSize: 30))),
              FutureBuilder(
                  future: getCategories(),
                  builder: ((context, snapshot) {
                    return Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: ((context, index) {
                              return getCategorie(
                                  documentId: categories[index]);
                            })));
                  })),
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
