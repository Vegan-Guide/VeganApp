import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vegan_app/pages/components/tile.dart';
import 'package:vegan_app/pages/receitas/recipe.dart';

class HomePage extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<HomePage> {
  final Query<Map<String, dynamic>> recipesReference = FirebaseFirestore
      .instance
      .collection('recipes')
      .orderBy("totalReviews", descending: true)
      .limit(10);
  final Query<Map<String, dynamic>> restaurantsReference = FirebaseFirestore
      .instance
      .collection('restaurants')
      .orderBy("totalReviews", descending: true)
      .limit(10);

  @override
  Widget build(BuildContext context) {
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
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Top Receitas",
          style: TextStyle(fontSize: 25),
        ),
      ),
      Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: _buildBody(context, recipesReference)),
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Restaurantes para voce conhecer!",
          style: TextStyle(fontSize: 25),
        ),
      ),
      Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: _buildBody(context, restaurantsReference))
    ]));
  }

  Widget _buildBody(
      BuildContext context, Query<Map<String, dynamic>> reference) {
    return StreamBuilder<QuerySnapshot>(
      stream: reference.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final documentId = data.id;
    final row = data.data() as Map<String, dynamic>;
    return rowContainer(context, documentId, row);
  }
}

Widget rowContainer(context, documentId, row) {
  return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RecipeDetail(documentId: documentId)));
          },
          child: Tile(
              documentId: documentId, data: row, flexDirection: "vertical")));
}
