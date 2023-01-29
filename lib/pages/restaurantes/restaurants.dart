import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/pages/components/tile.dart';
import 'package:vegan_app/pages/restaurantes/add.dart';
import 'package:vegan_app/pages/restaurantes/restaurant.dart';

class Restaurants extends StatefulWidget {
  @override
  _Restaurants createState() => _Restaurants();
}

class _Restaurants extends State<Restaurants> {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('restaurants');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Restaurantes",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Expanded(child: _buildBody(context, collectionReference))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //algo aqui
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addRestaurant()));
            },
            child: Icon(Icons.add)));
  }

  Widget _buildBody(BuildContext context, CollectionReference reference) {
    return StreamBuilder<QuerySnapshot>(
      stream: reference.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final documentId = data.id;
    final row = data.data() as Map<String, dynamic>;
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RestaurantDetail(documentId: documentId)));
        },
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
              padding: EdgeInsets.all(15),
              child: Tile(
                  documentId: documentId,
                  data: row,
                  flexDirection: "horizontal")),
        ));
  }
}
