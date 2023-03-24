import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vegan_app/globals/globalVariables.dart';

List<String> list = <String>[
  "Geral",
  "Massa",
  "Salgados",
  "Hamburguer",
  "Asiático"
];

class filterRestaurant extends StatefulWidget {
  const filterRestaurant({super.key});

  @override
  _FilterRestaurant createState() => _FilterRestaurant();
}

class _FilterRestaurant extends State<filterRestaurant> {
  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(
                onPressed: () {
                  //
                },
                child: Text("Aplicar")),
          ],
        ));
  }
}
