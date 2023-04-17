import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/pages/components/listView.dart';
import 'package:vegan_app/pages/restaurantes/add.dart';
import 'package:vegan_app/pages/restaurantes/filter.dart';

class Restaurants extends StatefulWidget {
  final searchText;
  final dynamic userData;

  const Restaurants({this.searchText, this.userData});

  @override
  _Restaurants createState() => _Restaurants();
}

class _Restaurants extends State<Restaurants>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> refreshPage() async {
    setState(() {});
  }

  double rating = 0.0;

  Widget build(BuildContext context) {
    List ratingList = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5];
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> _collectionRef = _firestore
        .collection('restaurants')
        .where('address.isoCountryCode',
            isEqualTo: widget.userData['address']['isoCountryCode'])
        .where('address.subAdministrativeArea',
            isEqualTo: widget.userData['address']['subAdministrativeArea']);

    if (rating > 0) {
      double roundToHalf(double number) {
        return (number * 2).roundToDouble() / 2;
      }

      final index =
          ratingList.indexWhere((element) => element == roundToHalf(rating));
      final customList =
          ratingList.where((element) => element >= ratingList[index]).toList();
      _collectionRef =
          _collectionRef.where("averageReview", whereIn: customList);
    }

    _collectionRef = _collectionRef.orderBy("totalReviews", descending: true);

    return Scaffold(
        body: RefreshIndicator(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Restaurantes",
                      style: TextStyle(fontSize: 25),
                    ),
                    GestureDetector(
                        onTap: () async {
                          dynamic result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => filterRestaurant(
                                        rating: rating,
                                      )));
                          setState(() {
                            rating = (result['rating']) ?? 0.0;
                          });
                        },
                        child: Icon(Icons.filter_alt))
                  ],
                ),
              ),
              listViewResult(
                  userData: widget.userData,
                  collectionRef: _collectionRef,
                  collection: "restaurants")
            ],
          )),
          onRefresh: () {
            return refreshPage();
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //algo aqui
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addRestaurant()));
            },
            child: Icon(Icons.add)));
  }
}
