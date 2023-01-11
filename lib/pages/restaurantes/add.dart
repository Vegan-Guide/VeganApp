import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:address_search_field/address_search_field.dart';

List<String> list = <String>["Geral", "Massa", "Salgados"];

class addRestaurant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("restaurants");

    final geoMethods = GeoMethods(
      googleApiKey: 'GOOGLE_API_KEY',
      language: 'pt-BR',
      countryCode: 'br',
      countryCodes: ['br'],
      country: 'Brazil',
      city: 'Sao Paulo',
    );
    final coords = Coords(-23.550087, -46.634066);

    // It will search in unite states, espain and colombia. It just can filter up to 5 countries.
    geoMethods.autocompletePlace(query: 'place streets or reference');

    geoMethods.geoLocatePlace(coords: coords);

    geoMethods.getPlaceGeometry(
      reference: 'place streets',
      placeId: 'ajFDN3662fNsa4hhs42FAjeb5n',
    );

    final controller = TextEditingController();
    var initialAddress = Address.fromCoords(coords: coords);

    final name = TextEditingController();
    var tipo = list.first;
    var veggie = false;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Adicionar Restaurante")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "Adicionar Restaurante",
            style: TextStyle(fontSize: 20),
          )),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nome',
            ),
          ),
          Center(
            child: Text("Tipo do Restaurante"),
          ),
          DropdownButton(
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            value: tipo,
            onChanged: (value) {
              tipo = value!;
            },
          ),
          Row(
            children: [
              Center(
                child: Text("Totalmente Vegano"),
              ),
              Checkbox(
                  value: veggie,
                  onChanged: (value) {
                    veggie = value!;
                  }),
            ],
          ),
          Center(
            child: Text("Endereço"),
          ),
          AddressLocator(
            coords: coords,
            geoMethods: geoMethods,
            controller: controller,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Endereco',
              ),
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => AddressSearchDialog(
                    controller: controller,
                    geoMethods: geoMethods,
                    onDone: (Address address) => initialAddress = address),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                //algo
                ref.set({
                  "name": name,
                  "type": tipo,
                  "isVegan": veggie,
                  "address": initialAddress
                }).then((value) {
                  Navigator.pop(context);
                });
              },
              child: Text("Adicionar"))
        ],
      ),
    );
  }
}
