import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Restaurants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(children: [
          Center(
            child: Text(
              "Restaurantes",
              style: TextStyle(fontSize: 25),
            ),
          )
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //algo aqui
            },
            child: Icon(Icons.add)));
  }
}
