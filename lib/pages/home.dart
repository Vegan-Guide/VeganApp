import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/fullList.dart';

import 'package:vegan_app/pages/restaurantes/restaurant.dart';
import 'package:vegan_app/pages/components/listView.dart';

class HomePage extends StatefulWidget {
  final userData;
  const HomePage({this.userData});
  @override
  _Home createState() => _Home();
}

@override
class _Home extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    final Query<Map<String, dynamic>> recipesReference = FirebaseFirestore
        .instance
        .collection('recipes')
        .orderBy("averageReview", descending: true)
        .orderBy("totalReviews", descending: true);

    final Query<Map<String, dynamic>> recipesReferenceLimited =
        recipesReference.limit(10);

    final Query<Map<String, dynamic>> restaurantsReference = FirebaseFirestore
        .instance
        .collection('restaurants')
        .where("address.isoCountryCode",
            isEqualTo: widget.userData["address"]["isoCountryCode"])
        .where("address.subAdministrativeArea",
            isEqualTo: widget.userData["address"]["subAdministrativeArea"])
        .orderBy("averageReview", descending: true)
        .orderBy("totalReviews", descending: true);

    final Query<Map<String, dynamic>> restaurantsReferenceLimited =
        restaurantsReference.limit(10);

    return SingleChildScrollView(
        child: Column(children: [
      Image.asset('assets/images/banner.jpg',
          width: MediaQuery.of(context).size.width),
      Column(
        children: [
          TitleRow("Top Receitas", "recipes", recipesReference, false),
          listViewResult(
              userData: widget.userData,
              collectionRef: recipesReferenceLimited,
              collection: "recipes",
              type: "vertical",
              scrollDirection: Axis.horizontal)
        ],
      ),
      Column(
        children: [
          TitleRow("Restaurantes para voce conhecer!", "restaurants",
              restaurantsReference, false),
          listViewResult(
              userData: widget.userData,
              collectionRef: restaurantsReferenceLimited,
              collection: "restaurants",
              type: "vertical",
              scrollDirection: Axis.horizontal)
        ],
      ),
      Column(children: [
        TitleRow("Restaurantes pertos de você!", "restaurants",
            restaurantsReference, true),
        listViewResult(
            userData: widget.userData,
            collectionRef: restaurantsReferenceLimited,
            collection: "restaurants",
            type: "vertical",
            scrollDirection: Axis.horizontal,
            near: true)
      ]),
      Column(
        children: [
          Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "Experiências na sua região",
                style: TextStyle(fontSize: 20),
              )),
          NearComments(restaurantsReferenceLimited)
        ],
      ),
    ]));
  }

  Widget TitleRow(String title, String collection, collectionRef, bool near) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 5),
            child: Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
          )),
          GestureDetector(
            child: Container(
              child: Text("Ver mais"),
              padding: EdgeInsets.all(5),
              decoration: Globals.tagDecoration,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullList(
                          userData: widget.userData,
                          collection: collection,
                          collectionRef: collectionRef,
                          near: near)));
            },
          )
        ],
      ),
    );
  }
}

Widget CommentRatingBar(double rating) {
  return RatingBar.builder(
    initialRating: rating,
    minRating: 0,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemSize: 20,
    itemCount: 5,
    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
    itemBuilder: (context, _) => Icon(
      Icons.star,
      color: Colors.amber,
      size: 5.0,
    ),
    onRatingUpdate: (value) {
      //r
    },
    ignoreGestures: true,
  );
}

Widget NearComments(CollectionReference) {
  return StreamBuilder<QuerySnapshot>(
    stream: CollectionReference.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        final ratings = snapshot.data!.docs
            .where((element) => element['reviews'].length > 0)
            .expand((i) => i['reviews'].map((j) => ({
                  "docId": i.id,
                  "rating": j['rating'],
                  "userId": j['userId']
                })))
            .toList();
        final comments = snapshot.data!.docs
            .where((element) => element['comments'].length > 0)
            .expand((i) => i['comments'].map((j) => ({
                  "docId": i.id,
                  "comment": j['comment'],
                  "name": j['name'],
                  "userId": j['userId']
                })))
            .toList();
        var ratingComment = comments.map(
          (e) {
            final rating = ratings.firstWhere(
                (element) =>
                    element['docId'] == e['docId'] &&
                    element['userId'] == e['userId'],
                orElse: () => -1);
            var doc = e;
            doc['rating'] = rating == -1 ? rating : rating['rating'];
            return doc;
          },
        ).where((element) => element["rating"] >= 0);
        final orderedRatings = List.from(ratingComment)
          ..sort((a, b) => a['rating'].compareTo(b['rating']));
        return Container(
            margin: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  orderedRatings.length > 10 ? 10 : orderedRatings.length,
              itemBuilder: (context, index) {
                final row = orderedRatings[index];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RestaurantDetail(documentId: row['docId'])));
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(row['name']),
                            ),
                            CommentRatingBar(row['rating']),
                            Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Expanded(
                                  child: Text(row['comment']),
                                ))
                          ]),
                    ));
              },
            ));
      } else {
        return Text("Nada encontrado :(");
      }
    },
  );
}
