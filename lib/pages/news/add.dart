import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:vegan_app/globals/globalVariables.dart';

class addNews extends StatefulWidget {
  const addNews({super.key});

  @override
  _news createState() => _news();
}

class _news extends State<addNews> {
  var imageUuid = Uuid().v4();
  XFile? _newsImage;

  final title = TextEditingController();
  final subtitle = TextEditingController();
  final content = TextEditingController();
  bool _isLoading = false;
  String errorMessage = "";

  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance.collection("news");

    // TODO: implement build
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Globals.drawerIconColor), //add this line here
        title: Text("Adicionar Notícia"),
        backgroundColor: Globals.appBarBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                      child: Text(
                    errorMessage,
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                      child: Text(
                    "Adicionar Notícia",
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Título"),
                          ),
                          TextField(
                              controller: title,
                              decoration: Globals.inputDecorationStyling),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final file = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  setState(() {
                                    _newsImage = file;
                                  });
                                },
                                child: Text('Escolher Imagem'),
                              ),
                              Container(
                                height: 100.0,
                                width: 100.0,
                                child: _newsImage == null
                                    ? Center(child: Text('No Image'))
                                    : Image.file(File(_newsImage!.path)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text("Subtitulo"),
                            ),
                          ),
                          TextField(
                              controller: subtitle,
                              decoration: Globals.inputDecorationStyling),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text("Texto"),
                            ),
                          ),
                          TextField(
                              controller: content,
                              decoration: Globals.inputDecorationStyling),
                          ElevatedButton(
                              onPressed: () async {
                                //algo
                                String photoURL = "";
                                if (title.text != "" &&
                                    subtitle.text != "" &&
                                    content != "") {
                                  errorMessage = "";
                                  _showLoading();
                                  if (_newsImage != null) {
                                    final storageRef = FirebaseStorage.instance
                                        .ref()
                                        .child('restaurants/$imageUuid.jpg');
                                    final uploadTask = storageRef
                                        .putFile(File(_newsImage!.path));
                                    await uploadTask.then((res) async => {
                                          photoURL =
                                              await res.ref.getDownloadURL()
                                        });
                                  }
                                  print("creating document");
                                  await ref.add({
                                    "author_uid":
                                        FirebaseAuth.instance.currentUser?.uid,
                                    "title": title.text,
                                    "subtitle": subtitle.text,
                                    "content": content.text,
                                    "photoURL": photoURL,
                                    "quantityReviews": 1,
                                    "totalReviews": 1,
                                    "created_at":
                                        Timestamp.fromDate(DateTime.now())
                                  }).then((value) {
                                    _hideLoading();
                                    Navigator.pop(context);
                                  });
                                } else {
                                  setState(() {
                                    errorMessage =
                                        "Por favor, preencha todos os campos";
                                  });
                                }
                              },
                              child: Text("Adicionar"))
                        ],
                      ),
                    ),
                    _isLoading
                        ? Container(
                            color: Colors.black26,
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container()
                  ],
                )
              ]),
        ),
      ),
    );
  }

  void _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }
}
