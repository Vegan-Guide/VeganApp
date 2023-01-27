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
  List<String> ingredients = [];
  bool veggie = false;
  String tipo = "";

  List<String> categories = <String>[];

  Future getCategories() async {
    print("getting categories");
    await FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((value) => value.docs.forEach((element) async {
              await getCategorieName(element.reference.id);
              tipo = categories.first;
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

  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance.collection("recipes");

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text("Adicionar Receita")),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child: Text(
                    "Adicionar Receita",
                    style: TextStyle(fontSize: 20),
                  )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
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
                      Center(child: Text("Ingrediente")),
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
                            ref.add({
                              "name": name.text,
                              "type": tipo,
                              "ingredients": ingredients
                            }).then((value) {
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Adicionar"))
                    ],
                  ),
                ])));
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
