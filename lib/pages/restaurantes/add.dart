import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:address_search_field/address_search_field.dart';

List<String> list = <String>["Geral", "Massa", "Salgados"];

class addRestaurant extends StatefulWidget {
  const addRestaurant({super.key});

  @override
  _Restaurante createState() => _Restaurante();
}

class _Restaurante extends State<addRestaurant> {
  final controller = TextEditingController();
  final nameController = TextEditingController();
  final initialAddress = TextEditingController();
  String tipo = list.first;
  bool veggie = false;

  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CollectionReference ref =
        FirebaseFirestore.instance.collection("restaurants");

    // final geoMethods = GeoMethods(
    //   googleApiKey: 'GOOGLE_API_KEY',
    //   language: 'pt-BR',
    //   countryCode: 'br',
    //   countryCodes: ['br'],
    //   country: 'Brazil',
    //   city: 'Sao Paulo',
    // );
    // final coords = Coords(-23.550087, -46.634066);

    // // It will search in unite states, espain and colombia. It just can filter up to 5 countries.
    // geoMethods.autocompletePlace(query: 'place streets or reference');

    // geoMethods.geoLocatePlace(coords: coords);

    // geoMethods.getPlaceGeometry(
    //   reference: 'place streets',
    //   placeId: 'ajFDN3662fNsa4hhs42FAjeb5n',
    // );

    // var initialAddress = Address.fromCoords(coords: coords);

    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("Adicionar Restaurante")),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  Center(
                      child: Text(
                    "Adicionar Restaurante",
                    style: TextStyle(fontSize: 20),
                  )),
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Nome',
                            ),
                          ),
                          Center(
                            child: Text("Tipo do Restaurante"),
                          ),
                          DropdownButton(
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            value: tipo,
                            onChanged: (value) {
                              setState(() {
                                tipo = value!;
                              });
                            },
                          ),
                          Row(
                            children: [
                              Center(
                                child: Text("Totalmente Vegano"),
                              ),
                              Checkbox(
                                  value: veggie,
                                  onChanged: (value) {
                                    setState(() {
                                      veggie = value!;
                                    });
                                  }),
                            ],
                          ),
                          Center(
                            child: Text("Endereço"),
                          ),
                          TextField(
                            controller: initialAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Endereço',
                            ),
                          ),
                          // AddressLocator(
                          //   coords: coords,
                          //   geoMethods: geoMethods,
                          //   controller: controller,
                          //   child: TextField(
                          //     controller: controller,
                          //     decoration: InputDecoration(
                          //       border: OutlineInputBorder(),
                          //       hintText: 'Endereco',
                          //     ),
                          //     onTap: () => showDialog(
                          //       context: context,
                          //       builder: (BuildContext context) =>
                          //           AddressSearchDialog(
                          //               controller: controller,
                          //               geoMethods: geoMethods,
                          //               onDone: (Address address) =>
                          //                   initialAddress = address),
                          //     ),
                          //   ),
                          // ),
                          ElevatedButton(
                              onPressed: () {
                                //algo
                                if (nameController.text != "" &&
                                    initialAddress.text != "") {
                                  ref.add({
                                    "createdBy":
                                        FirebaseAuth.instance.currentUser?.uid,
                                    "name": nameController.text,
                                    "type": tipo,
                                    "isVegan": veggie,
                                    "address": initialAddress.text,
                                    "quantityReviews": 1,
                                    "totalReviews": 1,
                                    "averageReview": 1
                                  }).then((value) {
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              child: Text("Adicionar"))
                        ],
                      )),
                ]))));
  }
}
