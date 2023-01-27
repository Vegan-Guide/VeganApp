import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
                      child: RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          // print(rating);
                          checkReview(
                              rating, data['reviews'] ?? [], documentId);
                        },
                      )),
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

void checkReview(double rating, List reviews, id) async {
  print("id");
  print(id);
  print("/restaurants/$id");

  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child("/restaurants/$id").get();

  print("snapshot");
  print(snapshot.value);
}
