import 'dart:io';

import 'package:flutter/cupertino.dart';
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
  String tipo = "Geral";
  int quantityReviews = 1;
  int totalReviews = 1;
  int averageReview = 1;

  List<String> categories = <String>["Geral"];

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

    name.text = snapshot?['name'] ?? "";
    instructions.text = snapshot?['instructions'] ?? "";
    time.text = snapshot?['time'] ?? "";
    veggie = snapshot?['veggie'] ?? false;
    tipo = snapshot?['tipo'] ?? "";
    final ingredientsList = snapshot?['ingredients'] as List;

    if (ingredientsList.length > 0) {
      setState(() {
        ingredients = ingredientsList;
      });
    }
    quantityReviews = snapshot?['quantityReviews'] ?? 1;
    totalReviews = snapshot?['totalReviews'] ?? 1;
    averageReview = snapshot?['averageReview'] ?? 1;
    photoURL = snapshot?['photoURL'] ?? "";
  }

  Future getCategories() async {
    await FirebaseFirestore.instance
        .collection('categories')
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
        FirebaseFirestore.instance.collection('categories');
    final doc = ref.doc(id);
    final docGet = doc.get();
    return await docGet.then((value) => {
          value.reference.snapshots().forEach((element) {
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;
            String name = data["name"];
            if (categories.contains(name) == false) {
              setState(() {
                categories.add(name);
              });
            }
            print(categories);
            return data["name"];
          })
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
        title: Text("Adicionar Receita"),
        backgroundColor: Globals.appBarBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Stack(children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Form(
                key: _formKey,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.all(10), child: Text("Nome")),
                    TextFormField(
                      validator: (value) => value!.isEmpty
                          ? "Nome da Receita não pode estar Vazio"
                          : null,
                      controller: name,
                      decoration: Globals.inputDecorationStyling,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                              ? Center(child: Text('No Image'))
                              : Image.file(File(_recipeImage!.path)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Tipo da receita"),
                    ),
                    FutureBuilder(
                        future: getCategories(),
                        builder: ((context, snapshot) {
                          return DropdownButtonFormField(
                              decoration: Globals.inputDecorationStyling,
                              items: categories
                                  .map<DropdownMenuItem<String>>((String e) =>
                                      DropdownMenuItem(
                                          value: e, child: Text(e)))
                                  .toList(),
                              value: tipo,
                              onChanged: (value) {
                                setState(() {
                                  tipo = value!;
                                });
                              });
                        })),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Instruções"),
                    ),
                    TextFormField(
                      validator: (value) => value!.isEmpty
                          ? "Dê o passo a passo para que sua receita faça sucesso!"
                          : null,
                      controller: instructions,
                      decoration: Globals.inputDecorationStyling,
                      minLines: 4,
                      maxLines: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Tempo de Preparo (min)"),
                    ),
                    TextFormField(
                      validator: (value) => value!.isEmpty
                          ? "Coloque o tempo de preparo por favor!"
                          : null,
                      controller: time,
                      decoration: Globals.inputDecorationStyling,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Ingredientes")),
                    TagEditor(
                      length: ingredients.length,
                      delimiters: [','],
                      hasAddButton: true,
                      inputDecoration: Globals.inputDecorationStyling,
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
                    ElevatedButton(
                        onPressed: () async {
                          //algo
                          _showLoading();
                          if (name.text != "" && instructions.text != "") {
                            if (_recipeImage != null) {
                              final storageRef = FirebaseStorage.instance
                                  .ref()
                                  .child('recipes/$imageUuid.jpg');
                              final uploadTask =
                                  storageRef.putFile(File(_recipeImage!.path));
                              await uploadTask.then((res) async =>
                                  {photoURL = await res.ref.getDownloadURL()});
                            }
                            print("adicionando no FB");
                            final payload = {
                              "author_uid":
                                  FirebaseAuth.instance.currentUser?.uid,
                              "name": name.text,
                              "type": tipo,
                              "ingredients": ingredients,
                              "instructions": instructions.text,
                              "time": time.text,
                              "photoURL": photoURL,
                              "quantityReviews": quantityReviews,
                              "totalReviews": totalReviews,
                              "averageReview": averageReview,
                              "created_at": Timestamp.fromDate(DateTime.now())
                            };
                            if (widget.doc_id != null) {
                              ref.doc(widget.doc_id).update(payload);
                              _hideLoading();
                              Navigator.pop(context);
                            } else {
                              ref.add(payload).then((value) async {
                                _hideLoading();
                                Navigator.pop(context);
                              });
                            }
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
