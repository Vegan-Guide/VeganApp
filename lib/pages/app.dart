import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vegan_app/globals/globalVariables.dart';

import 'package:vegan_app/pages/configuration.dart';
import 'package:vegan_app/pages/home.dart';
import 'package:vegan_app/pages/news/newsList.dart';
import 'package:vegan_app/pages/restaurantes/restaurants.dart';
import 'package:vegan_app/pages/receitas/receitas.dart';
import 'package:vegan_app/pages/search.dart';

class App extends StatefulWidget {
  const App({super.key, loggedin = false});

  @override
  State<App> createState() => _LoginState();
}

class _LoginState extends State<App> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late dynamic userData = null;
  int _selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDocumentData();
  }

  Future<void> _getDocumentData() async {
    final ref = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    final data = ref.data()!;
    setState(() {
      userData = data;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> _widgetOptions = <Widget>[
      HomePage(userData: userData),
      NewsList(userData: userData),
      Restaurants(userData: userData),
      Receitas(userData: userData)
    ];
    final searchValue = TextEditingController();

    // TODO: implement build
    return Scaffold(
        body: (userData == null)
            ? Container(
                child: CircularProgressIndicator(),
              )
            : IndexedStack(
                children: _widgetOptions,
                index: _selectedIndex,
              ),
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Globals.drawerIconColor), //add this line here
          actions: [
            Container(
              margin: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Expanded(
                child: Container(
                    height: 50.0,
                    child: TextField(
                      decoration: Globals.inputDecorationStyling('Pesquisar'),
                      controller: searchValue,
                      onSubmitted: (value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage(
                                    userData: userData,
                                    searchText:
                                        searchValue.text.toUpperCase())));
                      },
                    )),
              ),
            )
          ],
          backgroundColor: Globals.appBarBackgroundColor,
        ),
        drawer: Drawer(
            backgroundColor: Globals.drawerBackgroundColor,
            width: MediaQuery.of(context).size.width * 0.75,
            child: ConfigPage(userData: userData)),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Notícias",
              icon: Icon(Icons.newspaper),
            ),
            BottomNavigationBarItem(
              label: "Restaurantes",
              icon: Icon(Icons.restaurant),
            ),
            BottomNavigationBarItem(
              label: "Receitas",
              icon: Icon(Icons.restaurant_menu),
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Globals.selectedNavBarIcon,
          unselectedItemColor: Globals.unselectedNavBarIcon,
          // backgroundColor: Globals.navBarBackgroundColor,
          onTap: _onItemTapped,
        ));
  }
}
