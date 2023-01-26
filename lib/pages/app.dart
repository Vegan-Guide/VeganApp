import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

import 'package:flutter/material.dart';

import 'package:vegan_app/pages/configuration.dart';
import 'package:vegan_app/pages/home.dart';
import 'package:vegan_app/pages/restaurantes/restaurants.dart';
import 'package:vegan_app/pages/receitas/receitas.dart';

class App extends StatefulWidget {
  const App({super.key, loggedin: false});

  @override
  State<App> createState() => _LoginState();
}

class _LoginState extends State<App> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int _selectedIndex = 0;
  @override
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Restaurants(),
    Receitas()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        appBar: AppBar(
          title: Text("Vegan Guide"),
          actions: [Center(child: Text("PESQUISA"))],
          backgroundColor: Color.fromARGB(255, 94, 177, 112),
        ),
        drawer: Drawer(
            backgroundColor: Color.fromARGB(255, 94, 177, 112),
            width: MediaQuery.of(context).size.width * 0.7,
            child: ConfigPage()),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              backgroundColor: Color.fromARGB(255, 82, 153, 97),
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              backgroundColor: Color.fromARGB(255, 82, 153, 97),
              label: "Restaurantes",
              icon: Icon(Icons.restaurant),
            ),
            BottomNavigationBarItem(
              backgroundColor: Color.fromARGB(255, 82, 153, 97),
              label: "Receitas",
              icon: Icon(Icons.restaurant_menu),
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 198, 223, 209),
          backgroundColor: Color.fromARGB(255, 94, 177, 112),
          onTap: _onItemTapped,
        ));
  }
}
