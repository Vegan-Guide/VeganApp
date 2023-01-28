import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Rating extends StatefulWidget {
  final type;
  final collection;
  final documentId;
  final totalReviews;

  Rating(
      {this.type = "listItem",
      required this.collection,
      required this.documentId,
      required this.totalReviews});
  @override
  _Rating createState() => _Rating();
}

class _Rating extends State<Rating> {
  @override
  Widget build(BuildContext context) {
    int myIndex = widget.totalReviews.indexWhere((element) =>
        element["userId"] == FirebaseAuth.instance.currentUser?.uid);
    double minRating = 1.0;
    double myReview =
        (myIndex >= 0) ? widget.totalReviews[myIndex]['rating'] : minRating;
    double totalRating = (widget.totalReviews.length > 0)
        ? widget.totalReviews
            .map((e) => e["rating"])
            .reduce((value, element) => value + element)
        : minRating;
    double initialRating = (widget.type == "detail")
        ? ((myIndex >= 0) ? (myReview) : minRating)
        : (totalRating /
            (widget.totalReviews.length > 0 ? widget.totalReviews.length : 1));
    // TODO: implement build
    return RatingBar.builder(
      initialRating: initialRating,
      minRating: minRating,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemSize: (widget.type == "listItem") ? 20.0 : 30.0,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
        size: 5.0,
      ),
      ignoreGestures: (widget.type == "listItem"),
      onRatingUpdate: (newRating) async {
        if (initialRating != newRating && newRating != myReview) {
          await checkReview(widget.collection, newRating, widget.totalReviews,
              widget.documentId);
          initialRating = newRating;
        }
      },
    );
  }

  Future<void> checkReview(
      String collection, double newRatingReceived, List reviews, id) async {
    CollectionReference ref = FirebaseFirestore.instance.collection(collection);
    final doc = ref.doc(id);

    var data1 = doc.get().then((value) => value.data());

    print("data1");
    print(data1);

    await doc.get().then((value) async => {
          await value.reference.snapshots().forEach((element) async {
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;
            List reviewsList = data['reviews'] ?? [];
            if (reviewsList.length > 0) {
              final index = reviewsList.indexWhere((review) =>
                  review["userId"] == FirebaseAuth.instance.currentUser?.uid);
              if (index >= 0) {
                reviewsList[index]["rating"] = newRatingReceived;
              } else {
                reviewsList.add({
                  "userId": FirebaseAuth.instance.currentUser?.uid,
                  "rating": newRatingReceived
                });
              }
            } else {
              reviewsList.add({
                "userId": FirebaseAuth.instance.currentUser?.uid,
                "rating": newRatingReceived
              });
            }
            print("reviewsList");
            print(reviewsList);
            data['reviews'] = reviewsList;
            await doc.set(data);
            setState(() {});
          })
        });
  }
}
