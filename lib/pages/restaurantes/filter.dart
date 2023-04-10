import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:vegan_app/globals/globalVariables.dart';

List<String> list = <String>[
  "Geral",
  "Massa",
  "Salgados",
  "Hamburguer",
  "Asiático"
];

class filterRestaurant extends StatefulWidget {
  final double rating;
  const filterRestaurant({this.rating = 0.0});

  @override
  _FilterRestaurant createState() => _FilterRestaurant();
}

class _FilterRestaurant extends State<filterRestaurant> {
  Widget build(BuildContext context) {
    @override
    double minRating = 1;
    double currentRating = widget.rating;
    double initialRating = (widget.rating > 0.0) ? widget.rating : 1;

    // TODO: implement build
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Adicionar Restaurante"),
          backgroundColor: Globals.appBarBackgroundColor,
        ),
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "Filtro",
                    style: TextStyle(fontSize: 25),
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Rating mínimo"),
                  RatingBar.builder(
                    initialRating: initialRating,
                    minRating: minRating,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: 30.0,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 5.0,
                    ),
                    onRatingUpdate: (newRating) async {
                      currentRating = newRating;
                    },
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentRating = 0.0;
                      initialRating = 1;
                    });
                    final returnData = {'rating': currentRating};
                    Navigator.pop(context, returnData);
                  },
                  child: Text("Limpar")),
              ElevatedButton(
                  onPressed: () {
                    final returnData = {'rating': currentRating};
                    Navigator.pop(context, returnData);
                  },
                  child: Text("Aplicar")),
            ])
          ],
        ));
  }
}
