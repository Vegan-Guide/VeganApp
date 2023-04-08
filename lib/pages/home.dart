import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/pages/components/fullList.dart';

import 'package:vegan_app/pages/components/tile.dart';
import 'package:vegan_app/pages/receitas/recipe.dart';
import 'package:vegan_app/pages/restaurantes/restaurant.dart';

class HomePage extends StatefulWidget {
  final userData;
  const HomePage({this.userData});
  @override
  _Home createState() => _Home();
}

@override
class _Home extends State<HomePage> {
  Widget build(BuildContext context) {
    final Query<Map<String, dynamic>> recipesReference = FirebaseFirestore
        .instance
        .collection('recipes')
        .orderBy("totalReviews", descending: true);

    final Query<Map<String, dynamic>> recipesReferenceLimited =
        recipesReference.limit(10);

    final Query<Map<String, dynamic>> restaurantsReference = FirebaseFirestore
        .instance
        .collection('restaurants')
        .orderBy("totalReviews", descending: true);

    final Query<Map<String, dynamic>> restaurantsReferenceLimited =
        restaurantsReference.limit(10);

    final Query<Map<String, dynamic>> restaurantsReferenceNear =
        FirebaseFirestore.instance
            .collection('restaurants')
            .where("address.isoCountryCode",
                isEqualTo: widget.userData["address"]["isoCountryCode"])
            .where("address.administrativeArea",
                isEqualTo: widget.userData["address"]["administrativeArea"]);
    final Query<Map<String, dynamic>> restaurantsReferenceNearLimited =
        restaurantsReferenceNear.limit(10);

    final userName = widget.userData['name'];

    return SingleChildScrollView(
        child: Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        decoration: BoxDecoration(color: Colors.green),
        margin: EdgeInsets.all(5),
        child: Center(
          child: Text(
            "BANNER",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
      TitleRow("Top Receitas", "recipes", recipesReference),
      ListContainerRow(context, recipesReferenceLimited, "recipe"),
      TitleRow("Restaurantes para voce conhecer!", "restaurants",
          restaurantsReference),
      ListContainerRow(context, restaurantsReferenceLimited, "restaurant"),
      TitleRow("Restaurantes na sua cidade!", "restaurants",
          restaurantsReferenceNear),
      ListContainerRow(context, restaurantsReferenceNearLimited, "restaurant"),
    ]));
  }

  Widget ListContainerRow(context, reference, collection) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: _buildBody(context, reference, collection));
  }

  Widget _buildBody(BuildContext context, Query<Map<String, dynamic>> reference,
      String collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: reference.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data!.docs, collection);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
      String collection) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot
          .map((data) => _buildListItem(context, data, collection))
          .toList(),
    );
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot data, String collection) {
    final documentId = data.id;
    final row = data.data() as Map<String, dynamic>;
    return rowContainer(context, documentId, row, collection);
  }

  Widget TitleRow(String title, String collection, collectionRef) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 5),
            child: Text(
              title,
              style: TextStyle(fontSize: 25),
            ),
          )),
          GestureDetector(
            child: Text(
              "Ver mais",
              style: TextStyle(
                decoration: TextDecoration
                    .underline, // optional: specify the color of the underline
                decorationThickness:
                    2, // optional: specify the thickness of the underline
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullList(
                            collection: collection,
                            collectionRef: collectionRef,
                          )));
            },
          )
        ],
      ),
    );
  }
}

Widget rowContainer(
    BuildContext context, String documentId, row, String collection) {
  return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => (collection == "recipe")
                    ? RecipeDetail(
                        documentId: documentId,
                        created_by: null,
                      )
                    : RestaurantDetail(documentId: documentId)));
      },
      child: Tile(
        documentId: documentId,
        data: row,
        flexDirection: "vertical",
        collection: collection,
      ));
}
