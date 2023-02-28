import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/components/favorite.dart';
import 'package:vegan_app/pages/components/photo.dart';
import 'package:vegan_app/pages/components/rating.dart';

class RestaurantDetail extends StatefulWidget {
  final String documentId;

  RestaurantDetail({required this.documentId});

  @override
  _RestaurantDetail createState() => _RestaurantDetail();
}

class _RestaurantDetail extends State<RestaurantDetail> {
  @override
  Widget build(BuildContext context) {
    //get collection data
    CollectionReference restaurants =
        FirebaseFirestore.instance.collection('restaurants');
    DocumentReference doc = restaurants.doc(widget.documentId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurante"),
        backgroundColor: Globals.appBarBackgroundColor,
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: doc.get(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              List totalReviews = data["reviews"] ?? [];
              List favorites = data["favorites"] ?? [];
              return SingleChildScrollView(
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
                        FotoContainer(
                            context: context,
                            data: data,
                            width: MediaQuery.of(context).size.width),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  margin: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "Nome: ${(data['name'] ?? "")}",
                                        style: TextStyle(fontSize: 25),
                                      )),
                                      Container(
                                        child: ((data['isVegan'] ?? false)
                                            ? Icon(Icons.eco)
                                            : Text("")),
                                      )
                                    ],
                                  )),
                              Container(
                                  child: Favorite(
                                      favorites: favorites,
                                      doc: doc,
                                      data: data))
                            ]),
                        Row(
                          children: [
                            Text("Rating médio: "),
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Rating(
                                    collection: "restaurants",
                                    totalReviews: totalReviews,
                                    documentId: widget.documentId)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Tipo: ${(data['type'] ?? "Não Informado")}"),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                        "Endereço: ${(data['address']['street'] ?? "")}, ${(data['address']['name'] ?? "")} - ${(data['address']['subAdministrativeArea'] ?? "")}, ${(data['address']['administrativeArea'] ?? "")} - ${(data['address']['isoCountryCode'] ?? "")}"),
                  ),
                  Row(
                    children: [
                      Text("Seu rating: "),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Rating(
                              type: "detail",
                              collection: "restaurants",
                              totalReviews: totalReviews,
                              documentId: widget.documentId)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Reviews"),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        title: Text("Review 1"),
                      ),
                      ListTile(
                        title: Text("Review 2"),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Escreva sua review"),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Digite aqui...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      minLines: 4,
                      maxLines: 20,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        //ação
                      },
                      child: Text("Enviar Comentário"))
                ],
              ));
            }
            return Text("Loading...");
          })),
    );
  }
}
