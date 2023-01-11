import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vegan_app/pages/receitas/add.dart';

class Receitas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(children: [
          Center(
            child: Text(
              "Receitas",
              style: TextStyle(fontSize: 25),
            ),
          )
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //algo aqui
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addReceita()));
            },
            child: Icon(Icons.add)));
  }
}
