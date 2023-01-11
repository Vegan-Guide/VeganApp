import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

List<String> list = <String>[
  "Massa",
  "Pratos quentes",
  "Leite",
  "Pães",
  "Doces"
];

class addReceita extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("recipes");

    final name = TextEditingController();
    final ingredient = TextEditingController();
    var tipo = list.first;
    var ingredients = [];

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
          Row(children: [
            Expanded(
              child: TextField(
                controller: ingredient,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'nome do Ingrediente',
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  ingredients.add(ingredient.text);
                  ingredient.clear();
                },
                child: Icon(Icons.add))
          ]),
          Center(child: Text(ingredients.join(", "))),
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
