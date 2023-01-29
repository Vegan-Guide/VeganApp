import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Rating extends StatelessWidget {
  final documentId;
  final totalReviews;
  final myIndex;

  Rating(
      {required this.documentId,
      required this.totalReviews,
      required this.myIndex});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RatingBar.builder(
      initialRating: (myIndex >= 0) ? totalReviews[myIndex] : 1,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (newRating) {
        checkReview(newRating, totalReviews ?? [], documentId);
      },
    );
  }
}

void checkReview(newRatingReceived, List reviews, id) async {
  CollectionReference ref =
      FirebaseFirestore.instance.collection('restaurants');
  final doc = ref.doc(id);
  await doc.get().then((value) => {
        value.reference.snapshots().forEach((element) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          List reviewsList = data['reviews'] ?? [];
          print("reviewsList");
          print(reviewsList);
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
          data['reviews'] = reviewsList;
          doc.set(data);
        })
      });
}
