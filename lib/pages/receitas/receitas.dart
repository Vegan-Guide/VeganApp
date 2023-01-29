import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/pages/components/tile.dart';
import 'package:vegan_app/pages/receitas/add.dart';
import 'package:vegan_app/pages/receitas/recipe.dart';

class Receitas extends StatefulWidget {
  final category;

  const Receitas({this.category});
  @override
  _Receitas createState() => _Receitas();
}

class _Receitas extends State<Receitas> {
  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> recipesReference = (widget.category != null)
        ? FirebaseFirestore.instance
            .collection('recipes')
            .where("type", isEqualTo: widget.category)
        : FirebaseFirestore.instance.collection('recipes');

    final CollectionReference categoryReference =
        FirebaseFirestore.instance.collection('categories');

    List<Widget> bodyContent = (widget.category != null)
        ? <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Receitas",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Expanded(child: _buildBody(context, recipesReference, false))
          ].toList()
        : <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Categorias",
                  style: TextStyle(fontSize: 25),
                )),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Center(
                    child: _buildBody(context, categoryReference, true))),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Receitas",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Expanded(child: _buildBody(context, recipesReference, false))
          ].toList();
    ;

    if ((widget.category != null)) {
      return Scaffold(
        appBar: AppBar(title: Text("Receitas")),
        body: Column(children: bodyContent),
      );
    } else {
      return Scaffold(
          body: Column(children: bodyContent),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                //algo aqui
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => addReceita()));
              },
              child: Icon(Icons.add)));
    }
  }

  Widget _buildBody(BuildContext context, reference, bool row) {
    return StreamBuilder<QuerySnapshot>(
      stream: reference.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data!.docs, row);
      },
    );
  }

  Widget _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot, bool row) {
    return ListView(
      scrollDirection: (row == false) ? Axis.vertical : Axis.horizontal,
      children:
          snapshot.map((data) => _buildListItem(context, data, row)).toList(),
    );
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot data, bool isRow) {
    final documentId = data.id;
    final row = data.data() as Map<String, dynamic>;
    return (isRow == false)
        ? recipeContainer(context, documentId, row)
        : categoryContainer(context, documentId, row);
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

Widget categoryContainer(context, documentId, row) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Receitas(category: row['name'])));
    },
    child: Container(
      width: 110,
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 75,
            height: 75,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(row["photoURL"] ?? "FOTO")),
          ),
          Center(child: Text(row["name"] ?? "")),
        ],
      ),
    ),
  );
}
