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
  const addReceita({super.key});

  @override
  _Receita createState() => _Receita();
}

class _Receita extends State<addReceita> {
  var imageUuid = Uuid().v4();
  XFile? _recipeImage;
  final name = TextEditingController();
  final instructions = TextEditingController();
  List<String> ingredients = [];
  bool veggie = false;
  String tipo = "Geral";

  List<String> categories = <String>["Geral"];

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
                      minLines: 4,
                      maxLines: 20,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Ingredientes")),
                    TagEditor(
                      length: ingredients.length,
                      delimiters: [','],
                      hasAddButton: true,
                      inputDecoration: InputDecoration(
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
                          String photoURL = "";
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
                            ref.add({
                              "author_uid":
                                  FirebaseAuth.instance.currentUser?.uid,
                              "name": name.text,
                              "type": tipo,
                              "ingredients": ingredients,
                              "instructions": instructions.text,
                              "photoURL": photoURL,
                              "quantityReviews": 1,
                              "totalReviews": 1,
                              "averageReview": 1
                            }).then((value) async {
                              _hideLoading();
                              Navigator.pop(context);
                            });
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
