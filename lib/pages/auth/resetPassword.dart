import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';

import 'package:vegan_app/pages/app.dart';
import 'package:vegan_app/pages/auth/signin.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  _ResetPage createState() => _ResetPage();
}

class _ResetPage extends State<ResetPage> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Password reset email sent to ${emailController.text.trim()}'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? ""),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send password reset email'),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Resetar Senha"),
          backgroundColor: Globals.appBarBackgroundColor,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('assets/images/logo.png', width: 200),
                SingleChildScrollView(
                    child: Stack(alignment: Alignment.center, children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              "Digite seu email para que enviemos um email de recuperação de conta!",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Email")),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: Globals.inputDecorationStyling,
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            child: Text('Enviar'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _submitForm();
                              }
                            },
                          ),
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
            )));
  }
}
