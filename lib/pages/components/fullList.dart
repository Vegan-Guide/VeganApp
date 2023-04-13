import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/listView.dart';
import 'package:vegan_app/pages/restaurantes/add.dart';

class FullList extends StatefulWidget {
  final searchText;
  final dynamic userData;
  final String collection;
  final Query<Map<String, dynamic>> collectionRef;
  final bool near;

  const FullList(
      {this.searchText,
      this.userData,
      required this.collection,
      required this.collectionRef,
      this.near = false});

  @override
  _FullList createState() => _FullList();
}

class _FullList extends State<FullList> {
  Widget build(BuildContext context) {
    @override
    Future<void> refreshPage() async {
      setState(() {});
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Globals.appBarBackgroundColor,
        ),
        body: RefreshIndicator(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Ver Tudo",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              listViewResult(
                userData: widget.userData,
                collectionRef: widget.collectionRef,
                collection: widget.collection,
                near: widget.near,
              )
            ],
          )),
          onRefresh: () {
            return refreshPage();
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //algo aqui
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addRestaurant()));
            },
            child: Icon(Icons.add)));
  }
}
