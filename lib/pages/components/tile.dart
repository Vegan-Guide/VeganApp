import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/rating.dart';

class Tile extends StatelessWidget {
  final documentId;
  final data;
  final String flexDirection;
  final String collection;

  Tile(
      {required this.documentId,
      required this.data,
      required this.flexDirection,
      required this.collection});

  @override
  Widget build(BuildContext context) {
    if (flexDirection == "vertical") {
      return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Globals.tileBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(2, 2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FotoContainer(data),
              Text(data["name"]),
            ],
          ));
    } else {
      return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Globals.tileBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(2, 2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
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
                Text(data["name"]),
                Row(
                  children: [
                    Rating(
                        collection: collection,
                        documentId: documentId,
                        totalReviews: data['reviews'] ?? []),
                    Text(
                        " (${data['reviews'] != null ? data['reviews'].length : 0})")
                  ],
                )
              ],
            )),
          ],
        ),
      );
    }
  }
}

Widget FotoContainer(data) {
  if (data.keys.contains("photoURL") && data["photoURL"] != "") {
    print("${data["photoURL"]}");
    print(data["photoURL"]);
    return Container(
      padding: EdgeInsets.all(2),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: 100,
      height: 100,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(data["photoURL"], fit: BoxFit.cover)),
    );
  } else {
    return Container(
      padding: EdgeInsets.all(2),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      width: 100,
      height: 100,
      child: Center(child: Text("FOTO")),
    );
  }
}
