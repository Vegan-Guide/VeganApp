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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          child: Center(
                              child:
                                  Text("FOTO", style: TextStyle(fontSize: 25))),
                        ),
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  "Nome: ${(data['name'] ?? "")}",
                                  style: TextStyle(fontSize: 25),
                                )),
                            Container(
                              child: ((data['isVegan'] ?? false)
                                  ? Icon(Icons.eco)
                                  : Text("")),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text("Rating médio: "),
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Rating(
                                    collection: "restaurants",
                                    totalReviews: totalReviews,
                                    documentId: widget.documentId)),
                          ],
                        ),
                      ],
                    ),
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
                              collection: "restaurants",
                              totalReviews: totalReviews,
                              documentId: widget.documentId)),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Tipo: ${(data['type'] ?? "Não Informado")}"),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Endereço: ${(data['address'] ?? "")}"),
                  ),
                ],
              );
            }
            return Text("Loading...");
          })),
    );
  }
}
