import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/pages/components/listView.dart';
import 'package:vegan_app/pages/restaurantes/add.dart';
import 'package:vegan_app/pages/restaurantes/filter.dart';

class Restaurants extends StatefulWidget {
  final searchText;
  final dynamic userData;

  const Restaurants({this.searchText, this.userData});

  @override
  _Restaurants createState() => _Restaurants();
}

class _Restaurants extends State<Restaurants> {
  @override
  Future<void> refreshPage() async {
    setState(() {});
  }

  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Query<Map<String, dynamic>> _collectionRef =
        _firestore.collection('restaurants');

    return Scaffold(
        body: RefreshIndicator(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Receitas",
                      style: TextStyle(fontSize: 25),
                    ),
                    GestureDetector(
                        onTap: () async {
                          dynamic result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => filterRestaurant()));
                          print("max");
                          print(result['max']);
                          setState(() {
                            //
                          });
                        },
                        child: Icon(Icons.filter_alt))
                  ],
                ),
              ),
              listViewResult(
                  collectionRef: _collectionRef, collection: "restaurants")
            ],
          )),
          onRefresh: () {
            return refreshPage();
            //
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
