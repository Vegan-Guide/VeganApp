import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void checkReview(
    String collection, double newRatingReceived, List reviews, id) async {
  CollectionReference ref = FirebaseFirestore.instance.collection(collection);
  final doc = ref.doc(id);
  await doc.get().then((value) => {
        value.reference.snapshots().forEach((element) {
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
          data['reviews'] = reviewsList;
          doc.set(data);
        })
      });
}
