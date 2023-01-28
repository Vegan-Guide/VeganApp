import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/pages/components/rating.dart';

import 'package:vegan_app/pages/restaurantes/restaurant.dart';

class getRestaurant extends StatelessWidget {
  final String documentId;
  final double tileWidth;
  final String flexDirection;

  getRestaurant(
      {required this.documentId,
      required this.tileWidth,
      required this.flexDirection});

  @override
  Widget build(BuildContext context) {
    //get collection data
    CollectionReference restaurants =
        FirebaseFirestore.instance.collection('restaurants');

    return FutureBuilder<DocumentSnapshot>(
        future: restaurants.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              margin: EdgeInsets.all(5.00),
              width: ((tileWidth < 1.00)
                  ? MediaQuery.of(context).size.width * tileWidth
                  : tileWidth),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 236, 236, 236),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(0, 0, 0, 0).withAlpha(10),
                    blurRadius: 2,
                    offset: Offset(2, 4), // Shadow position
                  ),
                ],
              ),
              child: InkWell(
                splashColor: Color.fromARGB(255, 212, 255, 226).withAlpha(100),
                onTap: () {
                  debugPrint('Card tapped.');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RestaurantDetail(documentId: documentId)));
                },
                child: Tile(data['name'], data["reviews"]),
              ),
            );
          }
          return Text("Loading...");
        }));
  }

  Widget Tile(name, reviews) {
    if (flexDirection == "vertical") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(5),
            color: Colors.white,
            width: 100,
            height: 100,
            child: Center(child: Text("FOTO")),
          ),
          Text(name),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(5),
            color: Colors.white,
            width: 100,
            height: 100,
            child: Center(child: Text("FOTO")),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(name),
              Rating(
                  collection: "restaurants",
                  documentId: documentId,
                  totalReviews: reviews ?? [])
            ],
          )),
        ],
      );
    }
  }
}
