import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/pages/components/rating.dart';

class RestaurantDetail extends StatefulWidget {
  final String documentId;

  RestaurantDetail({required this.documentId});

  @override
  _RestaurantDetail createState() => _RestaurantDetail();
}

class _RestaurantDetail extends State<RestaurantDetail> {
  @override
  Widget build(BuildContext context) {
    //get collection data
    CollectionReference restaurants =
        FirebaseFirestore.instance.collection('restaurants');

    return Scaffold(
      appBar: AppBar(title: Text("Restaurante")),
      body: FutureBuilder<DocumentSnapshot>(
          future: restaurants.doc(widget.documentId).get(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              List totalReviews = data["reviews"] ?? [];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          child: Center(
                              child:
                                  Text("FOTO", style: TextStyle(fontSize: 25))),
                        ),
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "Nome: ${(data['name'] ?? "")}",
                              style: TextStyle(fontSize: 25),
                            )),
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 5,
                  ),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Rating(
                          type: "detail",
                          collection: "restaurants",
                          totalReviews: totalReviews,
                          documentId: widget.documentId)),
                  Center(
                    child: Text("Tipo: ${(data['type'] ?? "Não Informado")}"),
                  ),
                  Center(
                    child: Text("Endereço: ${(data['address'] ?? "")}"),
                  ),
                  Center(
                      child: Text(
                          "Totalmente Vegano: ${((data['isVegan'] ?? false) ? "Sim" : "Não")}")),
                ],
              );
            }
            return Text("Loading...");
          })),
    );
  }
}
