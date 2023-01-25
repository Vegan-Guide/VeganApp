import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantDetail extends StatelessWidget {
  final String documentId;

  RestaurantDetail({required this.documentId});

  @override
  Widget build(BuildContext context) {
    //get collection data
    CollectionReference restaurants =
        FirebaseFirestore.instance.collection('restaurants');

    return Scaffold(
      appBar: AppBar(title: Text("Restaurante")),
      body: FutureBuilder<DocumentSnapshot>(
          future: restaurants.doc(documentId).get(),
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
                    child: Text("Endereço: ${(data['address'] ?? "")}"),
                  ),
                  Center(
                      child: Text(
                          "Totalmente Vegano: ${((data['vegan'] ?? false) ? "Sim" : "Não")}")),
                ],
              );
            }
            return Text("Loading...");
          })),
    );
  }
}
