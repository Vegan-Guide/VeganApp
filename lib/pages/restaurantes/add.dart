import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:geocoding/geocoding.dart';

import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:vegan_app/globals/globalVariables.dart';

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
  List possibleAddresses = [];
  String tipo = list.first;
  bool veggie = false;
  dynamic address;

  final _formKey = new GlobalKey<FormState>();

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
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Nome"),
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Digite aqui...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final file = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  setState(() {
                                    _recipeImage = file;
                                  });
                                },
                                child: Text('Escolher Imagem'),
                              ),
                              Container(
                                height: 100.0,
                                width: 100.0,
                                child: _recipeImage == null
                                    ? Center(child: Text('No Image'))
                                    : Image.file(File(_recipeImage!.path)),
                              ),
                            ],
                          ),
                          Center(
                            child: Text("Tipo do Restaurante"),
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                            ),
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Digite aqui...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: possibleAddresses.length,
                              itemBuilder: (context, index) {
                                final row = possibleAddresses[index];
                                if (possibleAddresses.length > 0) {
                                  return Card(
                                      child: ListTile(
                                          onTap: () {
                                            setState(() {
                                              address = row;
                                              possibleAddresses = [];
                                              print("address");
                                              print(address);
                                            });
                                          },
                                          title: Text(row.street +
                                              ", " +
                                              row.subLocality +
                                              " - " +
                                              row.subAdministrativeArea +
                                              ", " +
                                              row.administrativeArea +
                                              " - " +
                                              row.isoCountryCode)));
                                } else {
                                  return Card(
                                      child: ListTile(
                                    title: Text("Nenhum endereço encontrado"),
                                  ));
                                }
                              }),
                          ElevatedButton(
                              onPressed: () async {
                                //algo
                                String photoURL = "";
                                if (nameController.text != "" &&
                                    initialAddress.text != "" &&
                                    address.latitude != 0.0 &&
                                    address.longitude != 0.0) {
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
                                    "address": address,
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
    // print("placemarks");
    // print(placemarks);
    setState(() {
      possibleAddresses = placemarks;
    });
  }
}
