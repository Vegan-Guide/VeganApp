import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    _getImageUrl();
    // fetchStates();
  }

  void _getImageUrl() async {
    final ref = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    setState(() {
      imageUrl = ref.data()!['photoURL'];
    });
  }

  var imageUuid = Uuid().v4();
  XFile? _recipeImage;
  bool _isLoading = false;

  String selectedState = "SP";
  String selectedCity = "São Paulo";
  List<dynamic> states = [
    {"sigla": "SP", "name": "São Paulo"}
  ];
  List<String> cities = ["São Paulo"];

  fetchStates() async {
    final response = await http.get(Uri.parse(
        "https://servicodados.ibge.gov.br/api/v1/localidades/estados"));

    if (response.statusCode == 200) {
      final statesData = json.decode(response.body);
      for (var state in statesData) {
        List siglas = states.map((e) => e['sigla']).toList();
        if (!siglas.contains(state['sigla'])) {
          setState(() {
            states.add({"sigla": state['sigla'], "name": state['nome']});
          });
        }
      }
    } else {
      throw Exception('Failed to load states');
    }
  }

  fetchCities() async {
    final response = await http.get(Uri.parse(
        "https://servicodados.ibge.gov.br/api/v1/localidades/estados/${selectedState}/distritos"));

    if (response.statusCode == 200) {
      final citiesData = json.decode(response.body);
      for (var city in citiesData) {
        print(cities);
        print(city['nome']);
        if (!cities.contains(city['nome'])) {
          setState(() {
            cities.add(city['nome']);
          });
        }
      }
    } else {
      throw Exception('Failed to load states');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final name = TextEditingController();
    final email = TextEditingController();
    final username = TextEditingController();
    final city = TextEditingController();

    Stream<DocumentSnapshot<Map<String, dynamic>>> ref = FirebaseFirestore
        .instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots();

    if (user?.displayName != null) {
      name.text = (user?.displayName).toString();
    }
    if (user?.email != null) {
      email.text = (user?.email).toString();
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Editar perfil")),
      body: SingleChildScrollView(
          child: Column(children: [
        Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                "Perfil",
                style: TextStyle(fontSize: 25),
              ),
            )),
        Stack(
          children: [
            Card(
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 100.0,
                            width: 100.0,
                            child: _recipeImage == null
                                ? (imageUrl == "")
                                    ? Container(
                                        height: 100.0,
                                        child: CircularProgressIndicator())
                                    : CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        height: 200.0,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.cover,
                                      )
                                : Image.file(File(_recipeImage!.path)),
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
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Nome"),
                      ),
                      TextField(
                        controller: name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Seu nome',
                        ),
                      ),
                      FutureBuilder(
                          future: fetchStates(),
                          builder: ((context, snapshot) {
                            return DropdownButton(
                                value: selectedState,
                                items: states
                                    .map((dynamic e) => DropdownMenuItem(
                                        value: e['sigla'],
                                        child: Text(e['name'])))
                                    .toList(),
                                onChanged: ((value) {
                                  setState(() {
                                    selectedState = value as String;
                                  });
                                  fetchCities();
                                }));
                          })),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Sua Cidade"),
                      ),
                      TextField(
                          controller: city,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Sua cidade',
                          ),
                          autofillHints: cities),
                      // FutureBuilder(
                      //     future: fetchCities(),
                      //     builder: ((context, snapshot) {
                      //       return DropdownButton(
                      //           value: selectedCity,
                      //           items: cities
                      //               .map((String e) =>
                      //                   DropdownMenuItem(child: Text(e)))
                      //               .toList(),
                      //           onChanged: ((value) {
                      //             setState(() {
                      //               selectedCity = value as String;
                      //             });
                      //           }));
                      //     })),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Usuário"),
                      ),
                      StreamBuilder(
                        stream: ref,
                        builder: (context, snapshot) {
                          dynamic data = snapshot.data;
                          username.text = data["username"];
                          return TextField(
                            controller: username,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Seu usuário',
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Email"),
                      ),
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'example@example.com',
                        ),
                      ),
                      Center(
                          child: ElevatedButton(
                              onPressed: () async {
                                _showLoading();
                                user?.updateDisplayName(name.text);
                                user?.updateEmail(email.text);
                                String photoURL = "";

                                if (_recipeImage != null) {
                                  final storageRef = FirebaseStorage.instance
                                      .ref()
                                      .child('users/$imageUuid.jpg');
                                  final uploadTask = storageRef
                                      .putFile(File(_recipeImage!.path));
                                  await uploadTask.then((res) async => {
                                        photoURL =
                                            await res.ref.getDownloadURL()
                                      });
                                }
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user?.uid)
                                    .set({
                                  "username": username.text,
                                  'photoURL': photoURL,
                                });
                                _hideLoading();
                                Navigator.pop(context);
                              },
                              child: Text("Editar")))
                    ])),
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
      ])),
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
}
