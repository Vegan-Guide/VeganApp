import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class addRestaurant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: [
          Center(
              child: Text(
            "Adicionar Restaurante",
            style: TextStyle(fontSize: 20),
          )),
          Center(child: Text("Adicionar Restaurante")),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nome do Restaurante',
            ),
          )
        ],
      ),
    );
  }
}
