import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vegan_app/globals/globalVariables.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  void initState() {
    super.initState();
    _getDocumentData();
  }

  String imageUrl = "";
  XFile? _profileImage;
  bool _isLoading = false;

  final initialAddress = TextEditingController();
  dynamic address;
  List possibleAddresses = [];
  late double latitude;
  late double longitude;
  dynamic docData;

  final user = FirebaseAuth.instance.currentUser;

  final name = TextEditingController();
  final email = TextEditingController();
  final username = TextEditingController();

  Future<void> _getDocumentData() async {
    final ref = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    final data = ref.data()!;
    setState(() {
      docData = data;
      imageUrl = data['photoURL'];
      initialAddress.text =
          data['address']['street'] + ", " + data['address']['name'];
      address = data["address"];
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> ref = FirebaseFirestore
        .instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots();

    if (user?.displayName != null) {
      name.text = (user?.displayName).toString();
    }
    if (user?.email != null) {
      email.text = (user?.email).toString();
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Globals.drawerIconColor), //add this line here
        title: Text("Editar perfil"),
        backgroundColor: Globals.appBarBackgroundColor,
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                "Perfil",
                style: TextStyle(fontSize: 25),
              ),
            )),
        Stack(
          children: [
            Card(
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              height: 100.0,
                              width: 100.0,
                              child: _profileImage == null
                                  ? (imageUrl == "")
                                      ? Container(
                                          height: 100.0,
                                          child: CircularProgressIndicator())
                                      : CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          height: 200.0,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        )
                                  : Card(
                                      child:
                                          Image.file(File(_profileImage!.path)),
                                    )),
                          ElevatedButton(
                            onPressed: () async {
                              final file = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              setState(() {
                                _profileImage = file;
                              });
                            },
                            child: Text('Subir arquivo'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: TextField(
                          controller: name,
                          decoration: Globals.inputDecorationStyling('Nome'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: initialAddress,
                          onChanged: ((value) {
                            getLocation(value);
                          }),
                          decoration:
                              Globals.inputDecorationStyling("Endereço: "),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: possibleAddresses.length,
                          itemBuilder: (context, index) {
                            final row = possibleAddresses[index];
                            if (possibleAddresses.length > 0) {
                              return Card(
                                  child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          address = row.toJson();
                                          address['latitude'] = latitude;
                                          address['longitude'] = longitude;
                                          possibleAddresses = [];
                                        });
                                      },
                                      title: Text(row.street +
                                          ", " +
                                          row.subLocality +
                                          " - " +
                                          row.subAdministrativeArea +
                                          ", " +
                                          row.administrativeArea +
                                          " - " +
                                          row.isoCountryCode)));
                            } else {
                              return Card(
                                  child: ListTile(
                                title: Text("Nenhum endereço encontrado"),
                              ));
                            }
                          }),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: StreamBuilder(
                          stream: ref,
                          builder: (context, snapshot) {
                            dynamic data = snapshot.data;
                            username.text = data["username"];
                            return TextField(
                                controller: username,
                                decoration:
                                    Globals.inputDecorationStyling("Usuário"));
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: TextField(
                          controller: email,
                          decoration: Globals.inputDecorationStyling("Email"),
                        ),
                      ),
                      Center(
                          child: ElevatedButton(
                              onPressed: () async {
                                _showLoading();
                                user?.updateDisplayName(name.text);
                                user?.updateEmail(email.text);
                                String photoURL = "";

                                if (_profileImage != null) {
                                  final storageRef = FirebaseStorage.instance
                                      .ref()
                                      .child(
                                          'users/${FirebaseAuth.instance.currentUser?.uid}.jpg');
                                  final uploadTask = storageRef
                                      .putFile(File(_profileImage!.path));
                                  await uploadTask.then((res) async => {
                                        photoURL =
                                            await res.ref.getDownloadURL()
                                      });
                                }
                                docData["username"] = username.text;
                                if (photoURL != "") {
                                  docData['photoURL'] = photoURL;
                                }
                                if (initialAddress.text != "") {
                                  docData["address"] = address;
                                }
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user?.uid)
                                    .set(docData);
                                _hideLoading();
                                Navigator.pop(context);
                              },
                              child: Text("Editar")))
                    ])),
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
      ])),
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

  void getLocation(address) async {
    List<Location> coordenates =
        await locationFromAddress(address, localeIdentifier: 'pt');
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordenates[0].latitude, coordenates[0].longitude);
    // print("placemarks");
    // print(placemarks);
    setState(() {
      latitude = coordenates[0].latitude;
      longitude = coordenates[0].longitude;
      possibleAddresses = placemarks;
    });
  }
}
