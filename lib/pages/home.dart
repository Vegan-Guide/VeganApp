import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/pages/receitas/recipeTile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  _Home createState() => _Home();
}

class _Home extends State<HomePage> with AutomaticKeepAliveClientMixin {
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
        body: Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: Center(
              child: Text(
            "Banner",
            style: TextStyle(fontSize: 50),
          )),
          decoration: new BoxDecoration(color: Colors.greenAccent),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Center(child: Text("Top Receitas", style: TextStyle(fontSize: 25))),
            FutureBuilder(
              future: getRecipes(),
              builder: (context, snapshot) {
                return Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      return getRecipe(
                          documentId: recipes[index],
                          tileWidth: 180,
                          flexDirection: "vertical");
                    },
                  ),
                );
              },
            ),
          ]),
        )
      ],
    ));
  }
}
