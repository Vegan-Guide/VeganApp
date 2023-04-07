import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/pages/components/tile.dart';
import 'package:vegan_app/pages/receitas/recipe.dart';
import 'package:vegan_app/pages/restaurantes/restaurant.dart';

class listViewResult extends StatefulWidget {
  final Query<Map<String, dynamic>> collectionRef;
  final collection;
  final String title;
  final String type;

  listViewResult(
      {this.title = "",
      this.collection,
      required this.collectionRef,
      this.type = "horizontal"});

  _listViewResult createState() => _listViewResult();
}

class _listViewResult extends State<listViewResult> {
  Future<void> refreshPage() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.collectionRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 20.0),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return GestureDetector(
              onTap: () {
                if (widget.collection != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              (widget.collection == "restaurants")
                                  ? RestaurantDetail(documentId: data['id'])
                                  : RecipeDetail(
                                      documentId: data['id'],
                                      created_by: data['author_uid'],
                                    )));
                }
              },
              child: Tile(
                documentId: data['id'],
                data: data,
                flexDirection:
                    widget.type == "horizontal" ? "horizontal" : "vertical",
                collection: "restaurants",
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
