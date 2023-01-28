import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:material_tag_editor/tag_editor.dart';

class addReceita extends StatefulWidget {
  const addReceita({super.key});

  @override
  _Receita createState() => _Receita();
}

class _Receita extends State<addReceita> {
  @override
  final name = TextEditingController();
  final instructions = TextEditingController();
  List<String> ingredients = [];
  bool veggie = false;
  String tipo = "Geral";

  List<String> categories = <String>["Geral"];

  Future getCategories() async {
    print("getting categories");
    await FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((value) => value.docs.forEach((element) async {
              await getCategorieName(element.reference.id);
              if (tipo == "") {
                tipo = categories.first;
              }
            }));
    print("categories list");
    print(categories);
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

  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance.collection("recipes");

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text("Adicionar Receita")),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: Text(
                      "Adicionar Receita",
                      style: TextStyle(fontSize: 20),
                    )),
                    Form(
                      key: _formKey,
                      child: Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            validator: (value) => value!.isEmpty
                                ? "Nome da Receita não pode estar Vazio"
                                : null,
                            controller: name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Nome',
                            ),
                          ),
                          Center(
                            child: Text("Tipo da receita"),
                          ),
                          FutureBuilder(
                              future: getCategories(),
                              builder: ((context, snapshot) {
                                return DropdownButton(
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
                          TextFormField(
                            validator: (value) => value!.isEmpty
                                ? "Dê o passo a passo para que sua receita faça sucesso!"
                                : null,
                            controller: instructions,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Instruções',
                            ),
                            minLines: 4,
                            maxLines: 20,
                          ),
                          Center(child: Text("Ingredientes")),
                          TagEditor(
                            length: ingredients.length,
                            delimiters: [',', ' '],
                            hasAddButton: true,
                            inputDecoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Hint Text...',
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
                              onPressed: () {
                                //algo
                                if (name.text != "" &&
                                    instructions.text != "") {
                                  ref.add({
                                    "createdBy":
                                        FirebaseAuth.instance.currentUser?.uid,
                                    "name": name.text,
                                    "type": tipo,
                                    "ingredients": ingredients,
                                    "instructions": instructions.text,
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
                    )
                  ]),
            )));
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
