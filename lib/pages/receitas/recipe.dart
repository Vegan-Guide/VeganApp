import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 154, 179, 162),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Column(
                        children: [
                          Center(
                            child: Row(
                              children: [
                                Text("Nome: "),
                                Text(data['name'] ?? "")
                              ],
                            ),
                          ),
                          Center(
                            child: Row(
                              children: [
                                Text("Tipo: "),
                                Text(data['type'] ?? "Não Informado")
                              ],
                            ),
                          ),
                          Center(
                            child: Row(
                              children: [
                                Text("Ingredientes: "),
                                Text(data['ingredients'].toString())
                              ],
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              );
            }
            return Text("Loading...");
          })),
    );
  }
}
