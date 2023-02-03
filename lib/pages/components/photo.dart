import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FotoContainer extends StatelessWidget {
  final context;
  final data;
  final width;

  FotoContainer(
      {required this.context, required this.data, required this.width});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("data");
    print(data);
    if (data["photoURL"] != "" && data["photoURL"] != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        width: (width == null) ? MediaQuery.of(context).size.width : width,
        child: Image.network(data["photoURL"], fit: BoxFit.cover),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Center(child: Text("FOTO")),
      );
    }
  }
}
