import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/comments.dart';
import 'package:vegan_app/pages/components/favorite.dart';
import 'package:vegan_app/pages/components/photo.dart';
import 'package:vegan_app/pages/components/rating.dart';
import 'package:vegan_app/pages/receitas/add.dart';

class RecipeDetail extends StatefulWidget {
  final String documentId;
  final created_by;
  RecipeDetail({required this.documentId, required this.created_by});

  _recipeDetail createState() => _recipeDetail();
}

class _recipeDetail extends State<RecipeDetail> {
  @override
  Widget build(BuildContext context) {
    //get collection data

    CollectionReference recipes =
        FirebaseFirestore.instance.collection('recipes');
    DocumentReference doc = recipes.doc(widget.documentId);

    return FutureBuilder<DocumentSnapshot>(
        future: doc.get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            print("data type");
            print(data['type'] == "");

            List totalReviews = data["reviews"] ?? [];
            List totalComments = data["comments"] ?? [];
            List ingredients = data["ingredients"] ?? [];
            List favorites = data["favorites"] ?? [];
            return Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(
                      color: Globals.drawerIconColor), //add this line here
                  title: Text(Globals.capitalize(data['name'] ?? "")),
                  backgroundColor: Globals.appBarBackgroundColor,
                ),
                body: SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FotoContainer(
                            context: context,
                            data: data,
                            width: MediaQuery.of(context).size.width),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Text("Rating médio: "),
                              Rating(
                                  collection: "recipes",
                                  totalReviews: totalReviews,
                                  documentId: widget.documentId),
                            ]),
                            Favorite(
                                favorites: favorites, doc: doc, data: data),
                          ],
                        ),
                        Divider(
                          height: 20,
                          thickness: 1,
                        ),
                        Container(
                            margin: EdgeInsets.all(5.0),
                            child: (data['type'] == null || data['type'] == "")
                                ? Text("")
                                : ShowCategorie(data["type"])),
                        Container(
                            margin: EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Text("Ingredientes: "),
                                // Text((ingredients.join(', ')))
                                Expanded(
                                    child: Container(
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.all(15.0),
                                            itemCount: ingredients.length,
                                            itemBuilder: ((context, index) {
                                              final a = ingredients[index];
                                              return Container(
                                                  height: 20,
                                                  decoration:
                                                      Globals.tagDecoration,
                                                  padding: EdgeInsets.all(5.0),
                                                  margin: EdgeInsets.all(2.0),
                                                  child: Text(a));
                                            })))),
                              ],
                            )),
                        Text("Tempo de preparo: ${data['time'] ?? "??"} min"),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    "Instruções",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                )),
                                Text(data["instructions"] ??
                                    "Nenhuma instrução passada")
                              ],
                            )),
                        Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                          indent: 20, // espaço à esquerda
                          endIndent: 20, // espaço à direita
                        ),
                        Row(
                          children: [
                            Text("Seu rating: "),
                            Rating(
                                type: "detail",
                                collection: "recipes",
                                totalReviews: totalReviews,
                                documentId: widget.documentId),
                          ],
                        ),
                        Comments(
                            collection: "recipes",
                            comments: totalComments
                                .where((element) => element['comment'] != null)
                                .toList(),
                            documentId: widget.documentId)
                      ],
                    )),
                floatingActionButton:
                    widget.created_by == FirebaseAuth.instance.currentUser?.uid
                        ? FloatingActionButton(
                            backgroundColor: Globals.floatingAddButton,
                            child: Icon(Icons.edit),
                            onPressed: () {
                              // edit
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => addReceita(
                                            doc_id: widget.documentId,
                                          )));
                            },
                          )
                        : Container());
          } else {
            return Scaffold(
              body: Expanded(child: Text("Receita não encontrada")),
            );
          }
        }));
  }
}

Widget ShowCategorie(String type) {
  return FutureBuilder(
    future: FirebaseFirestore.instance.collection('categories').doc(type).get(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (!snapshot.hasData) {
        return CircularProgressIndicator();
      }

      var data = snapshot.data!.data() as Map<String, dynamic>;
      return Text("Tipo: ${data['name']}");
    },
  );
}
