import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/globals/globalVariables.dart';

import 'package:vegan_app/pages/components/tile.dart';

import 'package:vegan_app/pages/receitas/recipe.dart';

class MinhasReceitasFavoritas extends StatefulWidget {
  const MinhasReceitasFavoritas({super.key});
  @override
  _MinhasReceitas createState() => _MinhasReceitas();
}

class _MinhasReceitas extends State<MinhasReceitasFavoritas> {
  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> recipesReference = FirebaseFirestore.instance
        .collection('recipes')
        .where("favorites",
            arrayContains: FirebaseAuth.instance.currentUser?.uid);

    List<Widget> bodyContent = <Widget>[
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Receitas",
          style: TextStyle(fontSize: 25),
        ),
      ),
      Expanded(child: _buildBody(context, recipesReference))
    ].toList();

    return Scaffold(
        appBar: AppBar(
          title: Text("Minhas Receitas"),
          backgroundColor: Globals.appBarBackgroundColor,
        ),
        body: Column(children: bodyContent));
  }

  Widget _buildBody(BuildContext context, reference) {
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
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final documentId = data.id;
    final row = data.data() as Map<String, dynamic>;
    return recipeContainer(context, documentId, row);
  }
}

Widget recipeContainer(context, documentId, row) {
  return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecipeDetail(documentId: documentId)));
      },
      child: Tile(
        documentId: documentId,
        data: row,
        flexDirection: "horizontal",
        collection: "recipes",
      ));
}
