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
                                Text(data['type'] ?? "Não Cadastrado")
                              ],
                            ),
                          ),
                          Center(
                            child: Row(
                              children: [
                                Text("Endereço:"),
                                Text(data['address'] ?? "")
                              ],
                            ),
                          ),
                          Center(
                              child: Row(
                            children: [
                              Text("Totalmente Vegano: "),
                              Text(data['vegan'] ? "Sim" : "Não")
                            ],
                          )),
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
