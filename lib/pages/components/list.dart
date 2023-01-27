import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:vegan_app/pages/receitas/add.dart';
import 'package:vegan_app/pages/receitas/recipeTile.dart';

class Receitas extends StatefulWidget {
  final String collection;
  final Widget tile;

  const Receitas({required this.collection, required this.tile});

  _Receitas createState() => _Receitas();
}

class _Receitas extends State<Receitas> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> datalist = [];

  Future getData() async {
    await FirebaseFirestore.instance
        .collection(widget.collection)
        .get()
        .then(((values) => values.docs.forEach((value) {
              print(value);
              datalist.add(value.reference.id);
            })));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(children: [
          Center(child: Text("Receitas", style: TextStyle(fontSize: 25))),
          Expanded(
            child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: datalist.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: widget.tile,
                      // title: widget.tile(documentId: datalist[index]),
                    );
                  },
                );
              },
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
