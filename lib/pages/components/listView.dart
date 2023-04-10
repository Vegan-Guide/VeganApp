import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';
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
  int page = 1;
  int rowsPerPage = 5;

  Future<void> refreshPage() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.collectionRef.limit(page * rowsPerPage).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.data!.size == 0) {
          return Center(
            child: Text("Desculpa, nada encontrado :("),
          );
        }

        return Column(
          children: [
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 20.0),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    if (widget.collection != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => (widget.collection ==
                                      "restaurants")
                                  ? RestaurantDetail(documentId: document.id)
                                  : RecipeDetail(
                                      documentId: document.id,
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
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Globals.appBarBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add),
              ),
              onTap: () {
                setState(() {
                  page++;
                });
              },
            )
          ],
        );
      },
    );
  }
}
