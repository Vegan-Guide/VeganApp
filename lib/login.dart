import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: [
          Text("Login", style: TextStyle(fontSize: 25)),
          Center(
            child: Column(
              children: [
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
            )
          )
        ],
      ),
    );
  }
}
