import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/pages/restaurantes/restaurant.dart';

class getRestaurant extends StatelessWidget {
  final String documentId;

  getRestaurant({required this.documentId});

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
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RestaurantDetail(documentId: documentId)));
                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 154, 179, 162),
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(data['name']),
                        )
                      ],
                    ),
                  ),
                ));
          }
          return Text("Loading...");
        }));
  }
}
