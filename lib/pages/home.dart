import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vegan_app/pages/receitas/recipeTile.dart';
import 'package:vegan_app/pages/restaurantes/restaurantTile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  _Home createState() => _Home();
}

class _Home extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> recipes = [];
  List<String> restaurants = [];

  Future getRecipes() async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .limit(10)
        .get()
        .then(((values) => values.docs.forEach((value) {
              print(value);
              if (!recipes.contains(value.reference.id)) {
                recipes.add(value.reference.id);
              }
            })));
  }

  Future getRestaurants() async {
    await FirebaseFirestore.instance
        .collection('restaurants')
        .limit(10)
        .get()
        .then(((values) => values.docs.forEach((value) {
              print(value);
              if (!restaurants.contains(value.reference.id)) {
                restaurants.add(value.reference.id);
              }
            })));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Novidades!", style: TextStyle(fontSize: 55)),
          Container(
            margin: EdgeInsets.all(10),
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
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Top Receitas", style: TextStyle(fontSize: 25))),
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
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Restaurantes pra você conhecer!",
                      style: TextStyle(fontSize: 25))),
              FutureBuilder(
                future: getRestaurants(),
                builder: (context, snapshot) {
                  return Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        return getRestaurant(
                            documentId: restaurants[index],
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
      ),
    ));
  }
}
