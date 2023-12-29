import 'dart:io';

import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:material_tag_editor/tag_editor.dart';

import 'package:image_picker/image_picker.dart';
import 'package:vegan_app/globals/globalVariables.dart';

class addReceita extends StatefulWidget {
  final doc_id;

  const addReceita({super.key, this.doc_id});

  @override
  _Receita createState() => _Receita();
}

class _Receita extends State<addReceita> {
  var imageUuid = Uuid().v4();
  XFile? _recipeImage;
  final name = TextEditingController();
  final instructions = TextEditingController();
  final time = TextEditingController();
  List ingredients = [];
  bool veggie = false;
  String photoURL = "";
  String tipo = "DmOLr9KKx12DTeSf17GB";
  double quantityReviews = 1.0;
  double totalReviews = 1.0;
  double averageReview = 1.0;

  final Query<Map<String, dynamic>> categoryReference =
      FirebaseFirestore.instance.collection('categories');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.doc_id != null) {
      getDocument();
    }
  }

  Future getDocument() async {
    DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore
        .instance
        .collection('recipes')
        .doc(widget.doc_id)
        .get();
    Map<String, dynamic>? snapshot = document.data();

    print("snapshot");
    print(snapshot);

    setState(() {
      name.text = snapshot?['name'] ?? "";
      instructions.text = snapshot?['instructions'] ?? "";
      time.text = snapshot?['time'].toString() ?? "";
      veggie = snapshot?['veggie'] ?? false;
      tipo = snapshot?['type'] ?? tipo;
      ingredients = snapshot?['ingredients'] as List;
      quantityReviews = double.parse(snapshot?['quantityReviews']);
      totalReviews = double.parse(snapshot?['totalReviews']);
      averageReview = double.parse(snapshot?['averageReview']);
      photoURL = snapshot?['photoURL'] ?? "";
    });
  }

  _onDelete(index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  final _formKey = new GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance.collection("recipes");

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Globals.drawerIconColor), //add this line here
        title: Text("Adicionar Receita"),
        backgroundColor: Globals.appBarBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Stack(children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Center(
                    child: Text(
                  "Adicionar Receita",
                  style: TextStyle(fontSize: 20),
                )),
              ),
              Form(
                key: _formKey,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        validator: (value) => value!.isEmpty
                            ? "Nome da Receita não pode estar Vazio"
                            : null,
                        controller: name,
                        decoration: Globals.inputDecorationStyling("Nome"),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final file = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              setState(() {
                                _recipeImage = file;
                              });
                            }
                          },
                          child: Text('Subir arquivo'),
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
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Tipo da receita"),
                    ),
                    StreamBuilder(
                      stream: categoryReference.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (snapshot.data!.size == 0) {
                          return Center(
                            child: Text("Desculpa, nada encontrado :("),
                          );
                        }
                        return DropdownButtonFormField(
                          validator: (value) => value!.isEmpty
                              ? "Selecione o tipo de receita!"
                              : null,
                          value: tipo,
                          decoration:
                              Globals.inputDecorationStyling('Digite Aqui...'),
                          items: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return DropdownMenuItem(
                                child: Text(data['name']), value: document.id);
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              tipo = value!;
                            });
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        validator: (value) => value!.isEmpty
                            ? "Dê o passo a passo para que sua receita faça sucesso!"
                            : null,
                        controller: instructions,
                        decoration:
                            Globals.inputDecorationStyling("Instruções"),
                        minLines: 4,
                        maxLines: 20,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        validator: (value) => value!.isEmpty
                            ? "Coloque o tempo de preparo por favor!"
                            : null,
                        controller: time,
                        decoration: Globals.inputDecorationStyling(
                            "Tempo de Preparo (min)"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TagEditor(
                        length: ingredients.length,
                        delimiters: [','],
                        hasAddButton: true,
                        inputDecoration:
                            Globals.inputDecorationStyling("Ingredientes"),
                        onTagChanged: (newValue) {
                          setState(() {
                            ingredients.add(newValue);
                          });
                        },
                        tagBuilder: (context, index) => _Chip(
                          index: index,
                          label: ingredients[index],
                          onDeleted: _onDelete,
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          //algo
                          _showLoading();
                          if (_formKey.currentState!.validate()) {
                            if (_recipeImage != null) {
                              final storageRef = FirebaseStorage.instance
                                  .ref()
                                  .child('recipes/$imageUuid.jpg');
                              final uploadTask =
                                  storageRef.putFile(File(_recipeImage!.path));
                              await uploadTask.then((res) async =>
                                  {photoURL = await res.ref.getDownloadURL()});
                            }
                            dynamic payload = {
                              "author_uid":
                                  FirebaseAuth.instance.currentUser?.uid,
                              "name": name.text.toUpperCase(),
                              "type": tipo,
                              "ingredients": ingredients,
                              "instructions": instructions.text,
                              "time": int.parse(time.text),
                              "photoURL": photoURL
                            };
                            if (widget.doc_id != null) {
                              print("edit");
                              ref.doc(widget.doc_id).update(payload);
                            } else {
                              print("create");
                              payload["reviews"] = [];
                              payload["comments"] = [];
                              payload["quantityReviews"] = quantityReviews;
                              payload["totalReviews"] = totalReviews;
                              payload["averageReview"] = averageReview;
                              payload["created_at"] =
                                  Timestamp.fromDate(DateTime.now());

                              ref.add(payload).then((value) async {
                                _hideLoading();
                                Navigator.pop(context);
                              });
                              _hideLoading();
                            }
                            _hideLoading();
                            Navigator.pop(context);
                          } else {
                            _hideLoading();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Termine de preencher os campos antes de salvar"),
                              ),
                            );
                          }
                        },
                        child: Text("Adicionar"))
                  ],
                )),
              )
            ]),
            _isLoading
                ? Container(
                    color: Colors.black26,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container()
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
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
