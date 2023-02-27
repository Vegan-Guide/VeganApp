import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/tile.dart';
import 'package:vegan_app/pages/restaurantes/add.dart';
import 'package:vegan_app/pages/restaurantes/restaurant.dart';

class Restaurants extends StatefulWidget {
  final searchText;

  const Restaurants({this.searchText});

  @override
  _Restaurants createState() => _Restaurants();
}

class _Restaurants extends State<Restaurants>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
            title: Text("Restaurantes"),
            backgroundColor: Globals.appBarBackgroundColor,
          ),
          body: RefreshIndicator(
            child: Column(
              children: bodyContent(searchValue, context),
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
            children: bodyContent(searchValue, context),
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

  List<Widget> bodyContent(searchValue, context) {
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
          "Restaurantes",
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

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
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
}
