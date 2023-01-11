import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: Center(
              child: Text(
            "Banner",
            style: TextStyle(fontSize: 50),
          )),
          decoration: new BoxDecoration(color: Colors.greenAccent),
        ),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Buscar',
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: Column(children: [
            Align(
              alignment: Alignment.center,
              child: Text("Top Receitas", style: TextStyle(fontSize: 25)),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                      width: 200,
                      height: 100,
                      child: Center(child: Text("Receita 1"))),
                  Container(
                    width: 200,
                    height: 100,
                    child: Center(child: Text("Receita 2")),
                  ),
                  Container(
                    width: 200,
                    height: 100,
                    child: Center(child: Text("Receita 3")),
                  )
                ],
              ),
            )
          ]),
        )
      ],
    ));
  }
}
