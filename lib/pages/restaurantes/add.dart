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

List<String> list = <String>[
  "Geral",
  "Massa",
  "Salgados",
  "Hamburguer",
  "Asiático"
];

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
  late double latitude;
  late double longitude;
  String tipo = list.first;
  bool veggie = false;
  dynamic address = null;
  bool _isLoading = false;
  String errorMessage = "";

  final _formKey = new GlobalKey<FormState>();

  List<String> categories = <String>["Geral"];

  Future getCategories() async {
    await FirebaseFirestore.instance
        .collection('restaurantTypes')
        .get()
        .then((value) => value.docs.forEach((element) async {
              await getCategorieName(element.reference.id);
              if (tipo == "") {
                tipo = categories.first;
              }
            }));
  }

  Future getCategorieName(id) async {
    CollectionReference ref =
        FirebaseFirestore.instance.collection('restaurantTypes');
    final doc = ref.doc(id).get();
    return await doc.then((value) => {
          value.reference.snapshots().forEach((element) {
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;
            String name = data["name"];
            if (categories.contains(name) == false) {
              setState(() {
                categories.add(name);
              });
            }
            return data["name"];
          })
        });
  }

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
                    errorMessage,
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                      child: Text(
                    "Adicionar Restaurante",
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Nome"),
                          ),
                          TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? "Qual o nome daqui?" : null,
                              controller: nameController,
                              decoration: Globals.inputDecorationStyling),
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
                          FutureBuilder(
                              future: getCategories(),
                              builder: ((context, snapshot) {
                                return DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 12.0),
                                    ),
                                    items: categories
                                        .map<DropdownMenuItem<String>>(
                                            (String e) => DropdownMenuItem(
                                                value: e, child: Text(e)))
                                        .toList(),
                                    value: tipo,
                                    onChanged: (value) {
                                      setState(() {
                                        tipo = value!;
                                      });
                                    });
                              })),
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
                          TextFormField(
                              validator: (value) => value!.isEmpty
                                  ? "Fale onde esta esse lugar legal pra galera!"
                                  : null,
                              controller: initialAddress,
                              onChanged: ((value) {
                                getLocation(value);
                              }),
                              decoration: Globals.inputDecorationStyling),
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
                                              address = row.toJson();
                                              possibleAddresses = [];
                                              address['latitude'] = latitude;
                                              address['longitude'] = longitude;
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
                                if (_formKey.currentState!.validate()) {
                                  //algo
                                  String photoURL = "";
                                  if (nameController.text != "" &&
                                      initialAddress.text != "" &&
                                      address != "") {
                                    errorMessage = "";
                                    _showLoading();
                                    if (_recipeImage != null) {
                                      final storageRef = FirebaseStorage
                                          .instance
                                          .ref()
                                          .child('restaurants/$imageUuid.jpg');
                                      final uploadTask = storageRef
                                          .putFile(File(_recipeImage!.path));
                                      await uploadTask.then((res) async => {
                                            photoURL =
                                                await res.ref.getDownloadURL()
                                          });
                                    }
                                    print("creating document");
                                    await ref.add({
                                      "author_uid": FirebaseAuth
                                          .instance.currentUser?.uid,
                                      "name": nameController.text,
                                      "type": tipo,
                                      "isVegan": veggie,
                                      "address": address,
                                      "photoURL": photoURL,
                                      "reviews": [],
                                      "comments": [],
                                      "quantityReviews": 1,
                                      "totalReviews": 1,
                                      "averageReview": 1,
                                      "created_at":
                                          Timestamp.fromDate(DateTime.now())
                                    }).then((value) {
                                      _hideLoading();
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    setState(() {
                                      errorMessage =
                                          "Por favor, preencha todos os campos";
                                    });
                                  }
                                }
                              },
                              child: Text("Adicionar"))
                        ],
                      ),
                    ),
                    _isLoading
                        ? Container(
                            color: Colors.black26,
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container()
                  ],
                )
              ]),
        ),
      ),
    );
  }

  void _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  void getLocation(address) async {
    List<Location> coordenates =
        await locationFromAddress(address, localeIdentifier: 'pt');
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordenates[0].latitude, coordenates[0].longitude);
    // print("placemarks");
    // print(placemarks);
    setState(() {
      latitude = coordenates[0].latitude;
      longitude = coordenates[0].longitude;
      possibleAddresses = placemarks;
    });
  }
}
