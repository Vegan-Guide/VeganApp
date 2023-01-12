import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:material_tag_editor/tag_editor.dart';

List<String> list = <String>[
  "Massa",
  "Pratos quentes",
  "Leite",
  "Pães",
  "Doces"
];

class addReceita extends StatefulWidget {
  const addReceita({super.key});

  @override
  _Receita createState() => _Receita();
}

class _Receita extends State<addReceita> {
  List<String> ingredients = [];
  _onDelete(index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("recipes");

    final name = TextEditingController();
    var tipo = list.first;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Adicionar Receita")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "Adicionar Receita",
            style: TextStyle(fontSize: 20),
          )),
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
          DropdownButton(
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            value: tipo,
            onChanged: (value) {
              tipo = value!;
            },
          ),
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
                ref.set({
                  "name": name,
                  "type": tipo,
                  "ingredients": ingredients.toString()
                }).then((value) {
                  Navigator.pop(context);
                });
              },
              child: Text("Adicionar"))
        ],
      ),
    );
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
