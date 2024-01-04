import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/rating.dart';
import 'dart:math' as math;

class Tile extends StatelessWidget {
  final dynamic userData;
  final documentId;
  final data;
  final String flexDirection;
  final String collection;

  Tile(
      {this.userData,
      required this.documentId,
      required this.data,
      required this.flexDirection,
      required this.collection});

  @override
  Widget build(BuildContext context) {
    double distance = 0.0;
    if (collection == 'restaurants' && userData != null) {
      final userLocation = userData["address"];
      final storeLocation = data['address'];
      distance = math.sqrt(math.pow(
                  ((userLocation['latitude']) - storeLocation['latitude']), 2) +
              math.pow((userLocation['longitude'] - storeLocation['longitude']),
                  2)) *
          111;
    }
    final String distanceString = distance.toStringAsFixed(2);

    if (flexDirection == "vertical") {
      return Container(
          margin: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FotoContainer(data),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    Globals.capitalize(data["name"]),
                    style: TextStyle(fontSize: 15),
                  )),
            ],
          ));
    } else {
      return Container(
          child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FotoContainer(data),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  Globals.capitalize(data["name"]),
                ),
                Row(
                  children: [
                    Rating(
                        collection: collection,
                        documentId: documentId,
                        totalReviews: data['reviews'] ?? []),
                    Text(
                        " (${data['reviews'] != null ? data['reviews'].length : 0})")
                  ],
                ),
                (collection == 'restaurants' && userData != null)
                    ? Text("$distanceString km")
                    : Text("${data['time']} min")
              ],
            )),
          ],
        ),
      ));
    }
  }
}

Widget FotoContainer(data) {
  if (data.keys.contains("photoURL") && data["photoURL"] != "") {
    return Container(
      padding: EdgeInsets.all(2),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      width: 100,
      height: 100,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            data["photoURL"],
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                // Image is fully loaded
                return child;
              } else {
                // Show a loading indicator while the image is loading
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              }
            },
          )),
    );
  } else {
    return Container(
      padding: EdgeInsets.all(2),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey),
      ),
      width: 100,
      height: 100,
      child: Center(child: Text("FOTO")),
    );
  }
}
