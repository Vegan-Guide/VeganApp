import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:vegan_app/globals/globalVariables.dart';

List<String> list = <String>[
  "Geral",
  "Massa",
  "Salgados",
  "Hamburguer",
  "Asiático"
];

class filterRestaurant extends StatefulWidget {
  final double rating;
  const filterRestaurant({this.rating = 0.0});

  @override
  _FilterRestaurant createState() => _FilterRestaurant();
}

class _FilterRestaurant extends State<filterRestaurant> {
  @override
  double minRating = 1;
  double rating = 0;
  Widget build(BuildContext context) {
    double initialRating = (widget.rating > 0.0) ? widget.rating : 1;
    CollectionReference ref =
        FirebaseFirestore.instance.collection("restaurants");

    // TODO: implement build
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Adicionar Restaurante"),
          backgroundColor: Globals.appBarBackgroundColor,
        ),
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "Filtro",
                    style: TextStyle(fontSize: 25),
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Rating mínimo"),
                  RatingBar.builder(
                    initialRating: initialRating,
                    minRating: minRating,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: 30.0,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 5.0,
                    ),
                    onRatingUpdate: (newRating) async {
                      rating = newRating;
                    },
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      rating = 0.0;
                      initialRating = 1;
                    });
                    final returnData = {'rating': rating};
                    Navigator.pop(context, returnData);
                  },
                  child: Text("Limpar")),
              ElevatedButton(
                  onPressed: () {
                    final returnData = {'rating': rating};
                    Navigator.pop(context, returnData);
                  },
                  child: Text("Aplicar")),
            ])
          ],
        ));
  }
}
