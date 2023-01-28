import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/pages/components/rating.dart';

class RecipeDetail extends StatelessWidget {
  final String documentId;

  RecipeDetail({required this.documentId});

  @override
  Widget build(BuildContext context) {
    //get collection data
    CollectionReference recipes =
        FirebaseFirestore.instance.collection('recipes');

    return Scaffold(
      appBar: AppBar(title: Text("Receita")),
      body: FutureBuilder<DocumentSnapshot>(
          future: recipes.doc(documentId).get(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              List totalReviews = data["reviews"] ?? [];
              List ingredients = data["ingredients"] ?? [];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Center(child: Text("FOTO")),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      "Nome: ${(data['name'] ?? "")}",
                      style: TextStyle(fontSize: 25),
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
                              documentId: documentId)),
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 5,
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
                              documentId: documentId)),
                    ],
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
                                                    BorderRadius.circular(20.0),
                                                color: Colors.lightGreen),
                                            padding: EdgeInsets.all(5.0),
                                            margin: EdgeInsets.all(2.0),
                                            child: Text(a));
                                      })))),
                        ],
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text(
                          "Instruções",
                          style: TextStyle(fontSize: 25),
                        ),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(data["instructions"] ??
                                "Nenhuma instrução passada"))
                      ],
                    ),
                  ),
                ],
              );
            }
            return Text("Loading...");
          })),
    );
  }
}
