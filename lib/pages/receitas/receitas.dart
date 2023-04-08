import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/listView.dart';
import 'package:vegan_app/pages/receitas/add.dart';
import 'package:vegan_app/pages/receitas/filter.dart';

class Receitas extends StatefulWidget {
  final category;
  final categoryName;
  final searchText;

  const Receitas({this.category, this.categoryName, this.searchText});
  @override
  _Receitas createState() => _Receitas();
}

class _Receitas extends State<Receitas> {
  @override
  var min = null;
  var max = null;
  final searchValue = TextEditingController();
  String categoryName = "";
  Future<void> refreshPage() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestoreRecipes = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> recipesReference =
        _firestoreRecipes.collection('recipes');

    final FirebaseFirestore _firestoreCategories = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> categorieReference =
        _firestoreCategories.collection('categories');

    if (widget.category != null) {
      recipesReference =
          recipesReference.where("type", isEqualTo: widget.category);
    }

    if (min != null) {
      recipesReference = recipesReference.where("time",
          isGreaterThanOrEqualTo: int.parse(min));
    }
    if (max != null) {
      recipesReference =
          recipesReference.where("time", isLessThanOrEqualTo: int.parse(max));
    }

    return Scaffold(
        appBar: (widget.category != null)
            ? AppBar(
                backgroundColor: Globals.appBarBackgroundColor,
                title: Text("Receitas"),
              )
            : null,
        body: RefreshIndicator(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                "Categorias",
                style: TextStyle(fontSize: 25),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Categories(categorieReference),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Receitas",
                      style: TextStyle(fontSize: 25),
                    ),
                    GestureDetector(
                        onTap: () async {
                          dynamic result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      filterRecipe(min: min, max: max)));
                          setState(() {
                            min = result['min'] ?? null;
                            max = result['max'] ?? null;
                          });
                        },
                        child: Icon(Icons.filter_alt))
                  ],
                ),
              ),
              listViewResult(
                  collectionRef: recipesReference, collection: "recipes")
            ],
          )),
          onRefresh: () {
            return refreshPage();
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //algo aqui
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addReceita()));
            },
            child: Icon(Icons.add)));
  }
}

Widget Categories(collectionRef) {
  return StreamBuilder<QuerySnapshot>(
    stream: collectionRef.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      return ListView(
        scrollDirection: Axis.horizontal,
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Receitas(category: document.id)));
            },
            child: Container(
                child: Column(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    shape: BoxShape.circle,
                  ),
                  child:
                      (data.keys.contains("photoURL") && data["photoURL"] != "")
                          ? ClipOval(
                              child: Image.network(
                              data["photoURL"],
                              width: 100, // adjust the size as needed
                              height: 100,
                              fit: BoxFit.cover,
                            ))
                          : Center(child: Text("FOTO")),
                ),
                Center(child: Text(data["name"] ?? ""))
              ],
            )),
          );
        }).toList(),
      );
    },
  );
}
