import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vegan_app/pages/restaurantes/add.dart';
import 'package:vegan_app/pages/restaurantes/restaurantTile.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({super.key});

  _Restaurants createState() => _Restaurants();
}

class _Restaurants extends State<Restaurants>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> restaurants = [];

  Future getRestaurants() async {
    await FirebaseFirestore.instance
        .collection('restaurants')
        .get()
        .then(((values) => values.docs.forEach((value) {
              print(value);
              restaurants.add(value.reference.id);
            })));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
          Center(child: Text("Restaurantes", style: TextStyle(fontSize: 25))),
          FutureBuilder(
            future: getRestaurants(),
            builder: (context, snapshot) {
              return Expanded(
                  child: ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: getRestaurant(
                      documentId: restaurants[index],
                      tileWidth: 0.9,
                      flexDirection: "horizontal",
                    ),
                  );
                },
              ));
            },
          ),
        ])),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //algo aqui
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addRestaurant()));
            },
            child: Icon(Icons.add)));
  }
}
