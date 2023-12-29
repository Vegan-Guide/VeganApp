import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';

import 'package:vegan_app/pages/app.dart';
import 'package:vegan_app/pages/auth/resetPassword.dart';
import 'package:vegan_app/pages/auth/signin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _Login createState() => _Login();
}

class _Login extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) => {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => App()))
              });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? ""),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to login'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        // iconTheme: IconThemeData(
        //     color: Globals
        //         .drawerIconColor), //add this line heretitle: Text("Login")),
        body: Stack(alignment: Alignment.center, children: [
      SingleChildScrollView(
          padding: EdgeInsets.only(top: 50, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/images/logo2.png',
                  width: MediaQuery.of(context).size.width * 0.8),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration:
                                    Globals.inputDecorationStyling('Email')),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration:
                                    Globals.inputDecorationStyling('Senha')),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => ResetPage())));
                          },
                          child: Text(
                            "Esqueci minha senha",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Globals.primaryColor),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                            Globals.secondaryColor,
                          )),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _submitForm();
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          )),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Ainda não se registrou? ",
                              style: TextStyle(color: Globals.primaryColor),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => SignInPage())));
                              },
                              child: Text(
                                "Faça uma conta agora!",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Globals.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
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
}
