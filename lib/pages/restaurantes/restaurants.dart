import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/tile.dart';
import 'package:vegan_app/pages/restaurantes/add.dart';
import 'package:vegan_app/pages/restaurantes/restaurant.dart';

class Restaurants extends StatefulWidget {
  final searchText;
  final dynamic userData;

  const Restaurants({this.searchText, this.userData});

  @override
  _Restaurants createState() => _Restaurants();
}

class _Restaurants extends State<Restaurants> {
  @override
  void initState() {
    super.initState();
  }

  final searchValue = TextEditingController();

  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('restaurants');

  Future<void> refreshPage() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.searchText != null) {
      searchValue.text = widget.searchText;
    }

    if (widget.searchText != null) {
      return Scaffold(
          appBar: AppBar(
            // title: Text("Restaurantes"),
            backgroundColor: Globals.appBarBackgroundColor,
          ),
          body: RefreshIndicator(
            child: Column(
              children: bodyContent(searchValue, context, widget.userData),
            ),
            onRefresh: () {
              return refreshPage();
            },
          ));
    }
    return Scaffold(
        body: RefreshIndicator(
          child: SingleChildScrollView(
              child: Column(
            children: bodyContent(searchValue, context, widget.userData),
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

  List<Widget> bodyContent(searchValue, context, userData) {
    return <Widget>[
      Padding(
        padding: EdgeInsets.all(10),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
          ),
          controller: searchValue,
          onSubmitted: (value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Restaurants(searchText: searchValue.text)));
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Restaurantes Próximos de você",
          style: TextStyle(fontSize: 25),
        ),
      ),
      _buildNear(context, collectionReference, userData),
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Ver Todos",
          style: TextStyle(fontSize: 25),
        ),
      ),
      _buildBody(context, collectionReference)
    ];
  }

  Widget _buildBody(BuildContext context, CollectionReference reference) {
    return StreamBuilder<QuerySnapshot>(
      stream: reference.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildNear(
      BuildContext context, CollectionReference reference, dynamic userData) {
    return StreamBuilder<QuerySnapshot>(
      stream: reference.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildListNear(context, snapshot.data!.docs, userData);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListNear(
      BuildContext context, List<DocumentSnapshot> snapshot, dynamic userData) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 20.0),
            children: snapshot
                .map((data) =>
                    _buildListItemNear(context, data, widget.userData))
                .toList()));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final documentId = data.id;
    final row = data.data() as Map<String, dynamic>;
    if (searchValue.text.isNotEmpty &&
        row['name'].toLowerCase().contains(searchValue.text.toLowerCase()) ==
            false) {
      return Container();
    }
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RestaurantDetail(documentId: documentId)));
        },
        child: Tile(
          documentId: documentId,
          data: row,
          flexDirection: "horizontal",
          collection: "restaurants",
        ));
  }

  Widget _buildListItemNear(
      BuildContext context, DocumentSnapshot data, userData) {
    final documentId = data.id;
    final row = data.data() as Map<String, dynamic>;
    final userLatitude = userData['address']['latitude'];
    final userLongitude = userData['address']['longitude'];
    print(row['address']['latitude']);
    print(userLatitude);
    if (((row['address']['latitude'] - userLatitude).abs() > 0.3) ||
        ((row['address']['longitude'] - userLongitude).abs() > 0.3)) {
      return Container();
    }
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RestaurantDetail(documentId: documentId)));
        },
        child: Tile(
          documentId: documentId,
          data: row,
          flexDirection: "vertical",
          collection: "restaurants",
        ));
  }
}
