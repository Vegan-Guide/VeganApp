import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/photo.dart';

class News extends StatefulWidget {
  final String documentId;

  News({required this.documentId});

  @override
  _News createState() => _News();
}

class _News extends State<News> {
  @override
  Widget build(BuildContext context) {
    //get collection data
    CollectionReference restaurants =
        FirebaseFirestore.instance.collection('news');
    DocumentReference doc = restaurants.doc(widget.documentId);

    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Globals.drawerIconColor), //add this line here
        title: Text("Notícia"),
        backgroundColor: Globals.appBarBackgroundColor,
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: doc.get(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              // List totalReviews = data["reviews"] ?? [];
              // List totalComments = data["comments"] ?? [];
              // List favorites = data["favorites"] ?? [];
              return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (data['photoURL'] != "" &&
                                        data['photoURL'] != null)
                                    ? FotoContainer(
                                        context: context,
                                        data: data,
                                        width:
                                            MediaQuery.of(context).size.width)
                                    : Container(),
                                Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Center(
                                      child: Text(data['title'],
                                          style: TextStyle(fontSize: 25))),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                      child: Text(data['subtitle'],
                                          style: TextStyle(fontSize: 15))),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                      data['created_at'].toDate().toString()),
                                ),
                                Text(data['content'] ?? ""),
                              ]))
                    ],
                  ));
            }
            return Text("Loading...");
          })),
    );
  }
}
