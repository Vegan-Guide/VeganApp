import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:vegan_app/globals/globalVariables.dart';

class filterRecipe extends StatefulWidget {
  final min;
  final max;

  const filterRecipe({this.min, this.max});

  @override
  _filterRecipeState createState() => _filterRecipeState();
}

class _filterRecipeState extends State<filterRecipe> {
  // Reference to the Firestore collection containing ingredients
  CollectionReference _ingredientsCollection =
      FirebaseFirestore.instance.collection('ingredients');

  // List of ingredients retrieved from the ingredients collection
  List<String> _ingredients = <String>["Todos"];

  final ingredientsController = TextEditingController();
  final minTimeController = TextEditingController();
  final maxTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // Method to retrieve the list of ingredients from Firestore
  void _getIngredients() async {
    QuerySnapshot snapshot = await _ingredientsCollection.get();
    for (var doc in snapshot.docs) {
      dynamic data = doc.data();
      if (_ingredients.contains(data['name']) == false) {
        //
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.min != null) {
      minTimeController.text = widget.min;
    }
    if (widget.max != null) {
      maxTimeController.text = widget.max;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Filter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "Filtro",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical:
                      8.0), // Set the horizontal padding to 16 pixels and the vertical padding to 8 pixels
              child: TextField(
                controller: ingredientsController,
                onSubmitted: (value) {},
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Ingrediente...',
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
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Tempo de preparo"),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Min: "),
                ),
                Expanded(
                    child: TextField(
                        controller: minTimeController,
                        onSubmitted: (value) {},
                        decoration: Globals.inputDecorationStyling,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ])),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Max: "),
                ),
                Expanded(
                    child: TextField(
                        controller: maxTimeController,
                        onSubmitted: (value) {},
                        decoration: Globals.inputDecorationStyling,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ])),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      maxTimeController.text = "";
                      minTimeController.text = "";
                    },
                    child: Text("Limpar")),
                ElevatedButton(
                    onPressed: () {
                      final returnData = {
                        'min': minTimeController.text == ""
                            ? null
                            : minTimeController.text,
                        'max': maxTimeController.text == ""
                            ? null
                            : maxTimeController.text
                      };
                      Navigator.pop(context, returnData);
                    },
                    child: Text("Aplicar"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
