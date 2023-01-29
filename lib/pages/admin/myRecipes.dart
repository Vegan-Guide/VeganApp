import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vegan_app/pages/components/tile.dart';

import 'package:vegan_app/pages/receitas/add.dart';
import 'package:vegan_app/pages/receitas/recipe.dart';

class MinhasReceitas extends StatefulWidget {
  const MinhasReceitas({super.key});
  @override
  _MinhasReceitas createState() => _MinhasReceitas();
}

class _MinhasReceitas extends State<MinhasReceitas> {
  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> recipesReference = FirebaseFirestore.instance
        .collection('recipes')
        .where("createdBy", isEqualTo: FirebaseAuth.instance.currentUser?.uid);

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
        appBar: AppBar(title: Text("Minhas Receitas")),
        body: Column(children: bodyContent),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //algo aqui
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addReceita()));
            },
            child: Icon(Icons.add)));
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
      child: Container(
          margin: EdgeInsets.only(left: 5, right: 5, top: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Tile(
              documentId: documentId, data: row, flexDirection: "horizontal")));
}
