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

    return Scaffold(
        appBar: AppBar(
          title: Text("Receita"),
          backgroundColor: Globals.appBarBackgroundColor,
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: doc.get(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                List totalReviews = data["reviews"] ?? [];
                List ingredients = data["ingredients"] ?? [];
                List favorites = data["favorites"] ?? [];
                Color heartColor = Colors.white;
                if (favorites
                    .contains(FirebaseAuth.instance.currentUser?.uid)) {
                  heartColor = Colors.red;
                }
                return SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: FotoContainer(
                          context: context,
                          data: data,
                          width: MediaQuery.of(context).size.width),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            margin: EdgeInsets.all(10.0),
                            child: Text(
                              "Nome: ${(data['name'] ?? "")}",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Favorite(favorites: favorites, doc: doc, data: data)
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text("Rating médio: "),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Rating(
                                collection: "recipes",
                                totalReviews: totalReviews,
                                documentId: widget.documentId)),
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                    ),
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: Text("Tipo: ${(data['type'] ?? "Não Informado")}"),
                    ),
                    Container(
                        margin: EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Text("Ingredientes: "),
                            // Text((ingredients.join(', ')))
                            Expanded(
                                child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.all(15.0),
                                        itemCount: ingredients.length,
                                        itemBuilder: ((context, index) {
                                          final a = ingredients[index];
                                          return Container(
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.lightGreen),
                                              padding: EdgeInsets.all(5.0),
                                              margin: EdgeInsets.all(2.0),
                                              child: Text(a));
                                        })))),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child:
                          Text("Tempo de preparo: ${data['time'] ?? "??"} min"),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Text(
                                "Instruções",
                                style: TextStyle(fontSize: 25),
                              )),
                              Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(data["instructions"] ??
                                      "Nenhuma instrução passada"))
                            ],
                          )),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                      indent: 20, // espaço à esquerda
                      endIndent: 20, // espaço à direita
                    ),
                    Row(
                      children: [
                        Text("Seu rating: "),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Rating(
                                type: "detail",
                                collection: "recipes",
                                totalReviews: totalReviews,
                                documentId: widget.documentId)),
                      ],
                    ),
                    Comments(
                        collection: "restaurants",
                        comments: totalReviews
                            .where((element) => element['comment'] != null)
                            .toList(),
                        documentId: widget.documentId)
                  ],
                ));
              }
              return Text("Loading...");
            })),
        floatingActionButton:
            widget.created_by == FirebaseAuth.instance.currentUser?.uid
                ? FloatingActionButton(
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
  }
}
