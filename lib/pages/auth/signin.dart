import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _signIn createState() => _signIn();
}

class _signIn extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final userRef = FirebaseFirestore.instance.collection('users');

  final username = TextEditingController();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Registrar"),
          backgroundColor: Globals.appBarBackgroundColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text("Registrar", style: TextStyle(fontSize: 25)),
              Center(
                  child: Stack(alignment: Alignment.center, children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(10), child: Text("Nome")),
                        TextField(
                          controller: name,
                          decoration: Globals.inputDecorationStyling,
                        ),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Usuário")),
                        TextField(
                          controller: username,
                          decoration: Globals.inputDecorationStyling,
                        ),
                        Padding(
                            padding: EdgeInsets.all(10), child: Text("Email")),
                        TextField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: Globals.inputDecorationStyling,
                        ),
                        Padding(
                            padding: EdgeInsets.all(10), child: Text("Senha")),
                        TextField(
                          controller: password,
                          obscureText: true,
                          decoration: Globals.inputDecorationStyling,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              CreateUser(context);
                            },
                            child: Text("Registrar"))
                      ],
                    )),
                _isLoading
                    ? Container(
                        color: Colors.black26,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container()
              ]))
            ],
          ),
        ));
  }

  Future CreateUser(context) async {
    List<String> users = [];
    await userRef
        .where("username", isEqualTo: username.text)
        .get()
        .then((values) => values.docs.forEach((element) {
              users.add(element.reference.id);
            }));
    if (users.length == 0) {
      //fazer registro
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) => {
                value.user?.updateDisplayName(name.text).then((value2) {
                  userRef.add({
                    "id": value.user?.uid,
                    "bio": "",
                    "photoURL": null,
                    "username": username.text
                  }).then((value) => Navigator.pop(context));
                })
              });
    }
  }
}
