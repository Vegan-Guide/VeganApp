import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/pages/receitas/filteredRecipes.dart';

class getCategorie extends StatelessWidget {
  final String documentId;

  getCategorie({required this.documentId});

  @override
  Widget build(BuildContext context) {
    //get collection data
    CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');

    return FutureBuilder<DocumentSnapshot>(
        future: categories.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              margin: EdgeInsets.all(2.00),
              padding: EdgeInsets.all(2.00),
              width: 100,
              child: InkWell(
                splashColor: Color.fromARGB(255, 212, 255, 226).withAlpha(100),
                onTap: () {
                  debugPrint('Card tapped.');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FilteredRecipes(category: data["name"])));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(0, 0, 0, 0).withAlpha(10),
                            blurRadius: 2,
                            offset: Offset(2, 4), // Shadow position
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(2),
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      width: 100,
                      height: 100,
                      child: Center(child: Text("FOTO")),
                    ),
                    Text(data["name"]),
                  ],
                ),
              ),
            );
          }
          return Text("Loading...");
        }));
  }
}
