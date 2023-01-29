import 'package:flutter/material.dart';
import 'package:vegan_app/pages/components/rating.dart';

class Tile extends StatelessWidget {
  final documentId;
  final data;
  final String flexDirection;

  Tile(
      {required this.documentId,
      required this.data,
      required this.flexDirection});

  @override
  Widget build(BuildContext context) {
    if (flexDirection == "vertical") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(2),
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            width: 100,
            height: 100,
            child: Center(child: Text("FOTO")),
          ),
          Text(data["name"]),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            width: 100,
            height: 100,
            child: Center(child: Text("FOTO")),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(data["name"]),
              Rating(
                  collection: "recipes",
                  documentId: documentId,
                  totalReviews: data['reviews'] ?? [])
            ],
          )),
        ],
      );
    }
  }
}
