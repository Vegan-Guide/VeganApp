import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';
import 'package:vegan_app/pages/auth/login.dart';

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
        body: Stack(alignment: Alignment.center, children: [
      SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon/icon2.png',
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text("Explore todas as possibilidades do Vegan Guide",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Globals.primaryColor)),
          ),
          Center(
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.all(35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: TextField(
                            controller: name,
                            decoration: Globals.inputDecorationStyling('Nome'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: TextField(
                            controller: username,
                            decoration:
                                Globals.inputDecorationStyling('Usuário'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: TextField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: Globals.inputDecorationStyling('Email'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: TextField(
                            controller: password,
                            obscureText: true,
                            decoration: Globals.inputDecorationStyling('Senha'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                Globals.secondaryColor,
                              )),
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                CreateUser(context);
                              },
                              child: Text(
                                "Cadastrar-se",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Já possui uma conta? ",
                              style: TextStyle(color: Globals.primaryColor),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => LoginPage())));
                              },
                              child: Text(
                                "Faça o login agora!",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Globals.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ))),
          )
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
    ]));
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
