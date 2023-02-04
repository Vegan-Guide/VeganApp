import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:geocoding/geocoding.dart';

import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

List<String> list = <String>["Geral", "Massa", "Salgados"];

class addRestaurant extends StatefulWidget {
  const addRestaurant({super.key});

  @override
  _Restaurante createState() => _Restaurante();
}

class _Restaurante extends State<addRestaurant> {
  var imageUuid = Uuid().v4();
  XFile? _recipeImage;

  final controller = TextEditingController();
  final nameController = TextEditingController();
  final initialAddress = TextEditingController();
  String tipo = list.first;
  bool veggie = false;
  double latitude = 0.0;
  double longitude = 0.0;
  String country = "";
  String state = "";
  String city = "";

  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CollectionReference ref =
        FirebaseFirestore.instance.collection("restaurants");

    // TODO: implement build
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("Adicionar Restaurante")),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                        child: Text(
                      "Adicionar Restaurante",
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
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
                          ElevatedButton(
                            onPressed: () async {
                              final file = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              setState(() {
                                _recipeImage = file;
                              });
                            },
                            child: Text('Subir arquivo'),
                          ),
                          Container(
                            height: 100.0,
                            width: 100.0,
                            child: _recipeImage == null
                                ? Text('No Image')
                                : Image.file(File(_recipeImage!.path)),
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
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text("Endereço"),
                            ),
                          ),
                          TextField(
                            controller: initialAddress,
                            onChanged: ((value) {
                              getLocation(value);
                            }),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Endereço',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: (latitude != 0.0 && longitude != 0.0)
                                ? Icon(Icons.check)
                                : Icon(Icons.error),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                                "Latitude: ${latitude}; Longitude: ${longitude}"),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                //algo
                                String photoURL = "";
                                if (nameController.text != "" &&
                                    initialAddress.text != "" &&
                                    latitude != 0.0 &&
                                    longitude != 0.0) {
                                  if (_recipeImage != null) {
                                    final storageRef = FirebaseStorage.instance
                                        .ref()
                                        .child('restaurants/$imageUuid.jpg');
                                    final uploadTask = storageRef
                                        .putFile(File(_recipeImage!.path));
                                    await uploadTask.then((res) async => {
                                          photoURL =
                                              await res.ref.getDownloadURL()
                                        });
                                  }
                                  ref.add({
                                    "createdBy":
                                        FirebaseAuth.instance.currentUser?.uid,
                                    "name": nameController.text,
                                    "type": tipo,
                                    "isVegan": veggie,
                                    "address": initialAddress.text,
                                    "latitude": latitude,
                                    "longitude": longitude,
                                    "country": country,
                                    "state": state,
                                    "city": city,
                                    "photoURL": photoURL,
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

  void getLocation(address) async {
    List<Location> coordenates =
        await locationFromAddress(address, localeIdentifier: 'pt');
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordenates[0].latitude, coordenates[0].longitude);

    setState(() {
      latitude = coordenates[0].latitude;
      longitude = coordenates[0].longitude;
      country = placemarks[0].country as String;
      city = placemarks[0].locality as String;
      state = placemarks[0].administrativeArea as String;
    });
  }
}
