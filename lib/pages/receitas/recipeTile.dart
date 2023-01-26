import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:vegan_app/pages/receitas/recipe.dart';

class getRecipe extends StatelessWidget {
  final String documentId;
  final double tileWidth;
  final String flexDirection;

  getRecipe(
      {required this.documentId,
      required this.tileWidth,
      required this.flexDirection});

  @override
  Widget build(BuildContext context) {
    //get collection data
    CollectionReference recipes =
        FirebaseFirestore.instance.collection('recipes');

    return FutureBuilder<DocumentSnapshot>(
        future: recipes.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              width: ((tileWidth < 1.00)
                  ? MediaQuery.of(context).size.width * tileWidth
                  : tileWidth),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 236, 236, 236),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(0, 0, 0, 0).withAlpha(10),
                    blurRadius: 4,
                    offset: Offset(4, 8), // Shadow position
                  ),
                ],
              ),
              child: InkWell(
                splashColor: Color.fromARGB(255, 212, 255, 226).withAlpha(100),
                onTap: () {
                  debugPrint('Card tapped.');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetail(documentId: documentId)));
                },
                child: Tile(data['name']),
              ),
            );
          }
          return Text("Loading...");
        }));
  }

  Widget Tile(name) {
    if (flexDirection == "vertical") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(2),
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            color: Colors.white,
            width: 100,
            height: 100,
            child: Center(child: Text("FOTO")),
          ),
          Text(name),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            color: Colors.white,
            width: 100,
            height: 100,
            child: Center(child: Text("FOTO")),
          ),
          Text(name),
        ],
      );
    }
  }
}
