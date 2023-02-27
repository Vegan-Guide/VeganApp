import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';

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
    final searchValue = TextEditingController();

    // TODO: implement build
    return Scaffold(
        body: IndexedStack(
          children: _widgetOptions,
          index: _selectedIndex,
        ),
        // Center(
        //   child: _widgetOptions.elementAt(_selectedIndex),
        // ),
        appBar: AppBar(
          title: Text(""),
          actions: [
            Container(
              margin: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Expanded(
                child: Container(
                    height: 50.0,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Pesquisar',
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
                        suffixIcon: Icon(Icons.search),
                      ),
                      controller: searchValue,
                      onSubmitted: (value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Receitas(searchText: searchValue.text)));
                      },
                    )),
              ),
            )
          ],
          backgroundColor: Globals.appBarBackgroundColor,
        ),
        drawer: Drawer(
            backgroundColor: Globals.appBarBackgroundColor,
            width: MediaQuery.of(context).size.width * 0.75,
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
          selectedItemColor: Color.fromARGB(255, 39, 196, 55),
          unselectedItemColor: Color.fromARGB(255, 110, 133, 112),
          backgroundColor: Color.fromARGB(255, 219, 219, 219),
          onTap: _onItemTapped,
        ));
  }
}
