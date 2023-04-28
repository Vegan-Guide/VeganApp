import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  final List favorites;
  final doc;
  final data;

  Favorite({required this.favorites, required this.doc, required this.data});

  _favorite createState() => _favorite();
}

class _favorite extends State<Favorite> {
  Color heartColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    if (widget.favorites.contains(FirebaseAuth.instance.currentUser?.uid)) {
      heartColor = Colors.red;
    }
    int favoritesLength = widget.favorites.length;
    // TODO: implement build
    return Column(
      children: [
        Text((favoritesLength < 1000)
            ? favoritesLength.toString()
            : "${(favoritesLength / 100).round().toString()}k"),
        Container(
          margin: EdgeInsets.all(10.0),
          child: FloatingActionButton(
            child: Icon(Icons.favorite, color: heartColor),
            backgroundColor: Colors.green.shade800,
            onPressed: () async {
              if (widget.favorites
                  .contains(FirebaseAuth.instance.currentUser?.uid)) {
                widget.favorites.remove(FirebaseAuth.instance.currentUser?.uid);
                setState(() {
                  heartColor = Colors.white;
                });
              } else {
                widget.favorites.add(FirebaseAuth.instance.currentUser?.uid);
                setState(() {
                  heartColor = Colors.red;
                });
              }
              widget.data["favorites"] = widget.favorites;
              await widget.doc.set(widget.data);
            },
          ),
        )
      ],
    );
  }
}
