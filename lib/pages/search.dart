import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/fullList.dart';
import 'package:vegan_app/pages/components/listView.dart';

class SearchPage extends StatefulWidget {
  final userData;
  final searchText;

  const SearchPage({this.userData, this.searchText});

  @override
  _SearchPage createState() => _SearchPage();
}

@override
class _SearchPage extends State<SearchPage> {
  Widget build(BuildContext context) {
    final Query<Map<String, dynamic>> recipesReference = FirebaseFirestore
        .instance
        .collection('recipes')
        .where("name", isGreaterThanOrEqualTo: widget.searchText)
        .where("name", isLessThan: widget.searchText + "z")
        .orderBy("name")
        .orderBy("averageReview", descending: true)
        .orderBy("totalReviews", descending: true);

    final Query<Map<String, dynamic>> restaurantsReference = FirebaseFirestore
        .instance
        .collection('restaurants')
        .where("address.isoCountryCode",
            isEqualTo: widget.userData["address"]["isoCountryCode"])
        .where("address.subAdministrativeArea",
            isEqualTo: widget.userData["address"]["subAdministrativeArea"])
        .where("name", isGreaterThanOrEqualTo: widget.searchText)
        .where("name", isLessThan: widget.searchText + "z")
        .orderBy("name")
        .orderBy("averageReview", descending: true)
        .orderBy("totalReviews", descending: true);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: Globals.drawerIconColor), //add this line here
            backgroundColor: Globals.appBarBackgroundColor,
            title: Text(widget.searchText),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Restaurantes'),
                Tab(text: 'Receitas'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                  child: listViewResult(
                      userData: widget.userData,
                      collectionRef: restaurantsReference,
                      collection: "restaurants")),
              Container(
                  child: listViewResult(
                      userData: widget.userData,
                      collectionRef: recipesReference,
                      collection: "recipes")),
            ],
          ),
        ));
  }
}
