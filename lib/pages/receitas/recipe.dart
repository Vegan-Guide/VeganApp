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
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Nome: ${(data['name'] ?? "")}",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Center(
                    child: Text("Tipo: ${(data['type'] ?? "Não Informado")}"),
                  ),
                  Center(
                    child: Text(
                        "Ingredientes: ${(data['ingredients'].toString())}"),
                    // child: Row(
                    //   children: [
                    //     Text("Ingredientes: "),
                    //     ListView.builder(
                    //         itemCount: (data['ingredients'] ?? []).length,
                    //         itemBuilder: ((context, index) {
                    //           return ListTile(
                    //             title: Text(data['ingredients'][index] ?? ""),
                    //           );
                    //         }))
                    //   ],
                    // ),
                  ),
                ],
              );
            }
            return Text("Loading...");
          })),
    );
  }
}
