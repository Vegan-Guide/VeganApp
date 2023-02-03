import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/pages/components/favorite.dart';
import 'package:vegan_app/pages/components/photo.dart';
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
    DocumentReference doc = restaurants.doc(widget.documentId);

    return Scaffold(
      appBar: AppBar(title: Text("Restaurante")),
      body: FutureBuilder<DocumentSnapshot>(
          future: doc.get(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              List totalReviews = data["reviews"] ?? [];
              List favorites = data["favorites"] ?? [];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
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
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Row(
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
                                  )),
                              Container(
                                  child: Favorite(
                                      favorites: favorites,
                                      doc: doc,
                                      data: data))
                            ]),
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
