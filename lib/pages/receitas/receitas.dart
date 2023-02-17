import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/pages/components/tile.dart';
import 'package:vegan_app/pages/receitas/add.dart';
import 'package:vegan_app/pages/receitas/recipe.dart';

class Receitas extends StatefulWidget {
  final category;
  final searchText;

  const Receitas({this.category, this.searchText});
  @override
  _Receitas createState() => _Receitas();
}

class _Receitas extends State<Receitas> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final searchValue = TextEditingController();

  Future<void> refreshPage() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> recipesReference = (widget.category != null)
        ? FirebaseFirestore.instance
            .collection('recipes')
            .where("type", isEqualTo: widget.category)
        : FirebaseFirestore.instance.collection('recipes');

    final CollectionReference categoryReference =
        FirebaseFirestore.instance.collection('categories');

    List<Widget> bodyContent = (widget.category != null)
        ? <Widget>[
            SearchBar(searchValue, context),
            _buildBody(context, recipesReference, false, widget.searchText)
          ].toList()
        : <Widget>[
            SearchBar(searchValue, context),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Categorias",
                  style: TextStyle(fontSize: 25),
                )),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Center(
                    child: _buildBody(
                        context, categoryReference, true, widget.searchText))),
            _buildBody(context, recipesReference, false, widget.searchText)
          ].toList();
    ;

    if ((widget.category != null || widget.searchText != null)) {
      return Scaffold(
        appBar: AppBar(title: Text("Receitas")),
        body: RefreshIndicator(
          child: SingleChildScrollView(child: Column(children: bodyContent)),
          onRefresh: () {
            return refreshPage();
          },
        ),
      );
    } else {
      return Scaffold(
          body: RefreshIndicator(
            child: SingleChildScrollView(child: Column(children: bodyContent)),
            onRefresh: () {
              return refreshPage();
            },
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                //algo aqui
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => addReceita()));
              },
              child: Icon(Icons.add)));
    }
  }

  Widget _buildBody(BuildContext context, reference, bool row, searchText) {
    return StreamBuilder<QuerySnapshot>(
      stream: reference.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data!.docs, row, searchText);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
      bool row, searchText) {
    return ListView.builder(
      shrinkWrap: true,
      physics: (row == false) ? NeverScrollableScrollPhysics() : null,
      scrollDirection: (row == false) ? Axis.vertical : Axis.horizontal,
      itemCount: snapshot.length,
      itemBuilder: (context, index) {
        final data = snapshot[index];
        return _buildListItem(context, data, row, searchText);
      },
      // children: snapshot
      //     .map((data) => _buildListItem(context, data, row, searchText))
      //     .toList(),
    );
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot data, bool isRow, searchText) {
    final documentId = data.id;
    final row = data.data() as Map<String, dynamic>;
    return (isRow == false)
        ? recipeContainer(context, documentId, row, searchText)
        : categoryContainer(context, documentId, row);
  }
}

Widget recipeContainer(context, documentId, row, searchText) {
  if (searchText != null &&
      searchText.isNotEmpty &&
      row['name'].toLowerCase().contains(searchText.toLowerCase()) == false) {
    return Container();
  }
  return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecipeDetail(documentId: documentId)));
      },
      child: Tile(
          documentId: documentId,
          data: row,
          flexDirection: "horizontal",
          collection: "recipes"));
}

Widget SearchBar(searchValue, context) {
  return TextField(
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.search),
    ),
    controller: searchValue,
    onSubmitted: (value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Receitas(searchText: searchValue.text)));
    },
  );
}

Widget categoryContainer(context, documentId, row) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Receitas(category: row['name'])));
    },
    child: Container(
      width: 110,
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 75,
            height: 75,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(row["photoURL"] ?? "FOTO")),
          ),
          Center(child: Text(row["name"] ?? "")),
        ],
      ),
    ),
  );
}
