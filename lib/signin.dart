import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(SignInPage());
}

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: [
          Text("Registrar", style: TextStyle(fontSize: 25)),
          Center(
              child: Column(
            children: [
              Text("Nome"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Seu Nome',
                ),
              ),
              Text("Email"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'example@example.com',
                ),
              ),
              Text("Password"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '********',
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    //fazer login
                  },
                  child: Text("Login"))
            ],
          ))
        ],
      ),
    );
  }
}
