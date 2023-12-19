import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/news/add.dart';
import 'package:vegan_app/pages/news/news.dart';

class NewsList extends StatefulWidget {
  final userData;
  final searchText;

  const NewsList({this.userData, this.searchText});
  @override
  _NewsList createState() => _NewsList();
}

class _NewsList extends State<NewsList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final searchValue = TextEditingController();

  Future<void> refreshPage() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> newsReference =
        FirebaseFirestore.instance.collection('news');

    List<Widget> bodyContent = <Widget>[
      SearchBar(searchValue, context),
      _buildBody(context, newsReference, false, widget.searchText)
    ].toList();
    ;

    if (widget.searchText != null) {
      final String searched = widget.searchText;
      searchValue.text = widget.searchText;
      bodyContent.insert(
          3,
          Text(
            searched.toUpperCase(),
            style: TextStyle(fontSize: 25),
          ));
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Globals.drawerIconColor), //add this line here
          title: Text("Notícias"),
          backgroundColor: Globals.appBarBackgroundColor,
        ),
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
          floatingActionButton: (widget.userData['permission'] == 0)
              ? FloatingActionButton(
                  onPressed: () {
                    //algo aqui
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => addNews()));
                  },
                  child: Icon(Icons.add))
              : Container());
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
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: snapshot.length,
      itemBuilder: (context, index) {
        final data = snapshot[index];
        return _buildListItem(context, data, row, searchText);
      },
    );
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot data, bool isRow, searchText) {
    final documentId = data.id;
    final row = data.data() as Map<String, dynamic>;
    return newsContainer(context, documentId, row, searchText);
  }
}

Widget newsContainer(context, documentId, row, searchText) {
  if ((searchText != null && searchText.isNotEmpty) &&
      ((row['title'] != null &&
              row['title'].toLowerCase().contains(searchText.toLowerCase()) ==
                  false) ||
          (row['subtitle'] != null &&
              row['subtitle']
                      .toLowerCase()
                      .contains(searchText.toLowerCase()) ==
                  false) ||
          (row['content'] != null &&
              row['content'].toLowerCase().contains(searchText.toLowerCase()) ==
                  false))) {
    return Container();
  }
  return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => News(documentId: documentId)));
      },
      child: Card(
        child: ListTile(
          leading: Container(
            width: 100,
            child: Center(child: Text("foto")),
          ),
          title: Text(row['title'] ?? ""),
          subtitle: Text(row['subtitle'] ?? ""),
        ),
      ));
}

Widget SearchBar(searchValue, context) {
  return Padding(
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
                      NewsList(searchText: searchValue.text)));
        },
      ));
}
