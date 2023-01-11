import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';

import 'home.dart';
import 'configuration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, loggedin: false});

  @override
  State<MyApp> createState() => _LoginState();
}

class _LoginState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Color.fromARGB(255, 94, 177, 112),
          ),
        ),
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                  title: Text("VeganApp"),
                  bottom: TabBar(tabs: [
                    Tab(
                      text: "Home",
                      icon: Icon(Icons.home),
                    ),
                    Tab(text: "Restaurantes", icon: Icon(Icons.restaurant)),
                    Tab(text: "Receitas", icon: Icon(Icons.restaurant_menu)),
                    Tab(
                      text: "Configurações",
                      icon: Icon(Icons.build),
                    )
                  ])),
              body: TabBarView(children: [
                Center(child: HomePage()),
                Center(child: Text("Restaurantes")),
                Center(child: Text("Receitas")),
                Center(child: ConfigPage())
              ]),
            )));
  }
}
