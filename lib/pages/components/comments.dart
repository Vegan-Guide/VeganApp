import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vegan_app/globals/globalVariables.dart';

class Comments extends StatefulWidget {
  final collection;
  final documentId;
  final comments;
  Comments(
      {required this.collection,
      required this.documentId,
      required this.comments});

  @override
  _comments createState() => _comments();
}

class _comments extends State<Comments> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        CommentBox(),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text("Comentários (${widget.comments.length})"),
        ),
        Container(
          height: MediaQuery.of(context).size.height > 400
              ? 400
              : MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 20.0),
            itemCount: widget.comments.length,
            itemBuilder: (context, index) {
              if (widget.comments.length == 0) {
                return Center(
                  child: Text("Nenhum comentário ainda, faça o seu!"),
                );
              }
              final row = widget.comments[index];
              return Comment(row);
            },
          ),
        )
      ],
    );
  }

  Widget Comment(row) {
    return ListTile(
        title: Text(row['name'] ?? "Name"),
        subtitle: Text(row['comment'] ?? "comment"));
  }

  Widget CommentBox() {
    final index = (widget.comments.length > 0)
        ? widget.comments.indexWhere((review) =>
            review["userId"] == FirebaseAuth.instance.currentUser?.uid)
        : null;
    if (index != null) {
      return Column(
        children: [
          Padding(padding: EdgeInsets.all(10), child: Text("Seu comentário")),
          Comment(widget.comments[index])
        ],
      );
    }
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text("Escreva sua review"),
        ),
        Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(5),
          child: TextField(
            minLines: 4,
            maxLines: 20,
            controller: commentController,
            decoration: Globals.inputDecorationStyling('Digite Aqui...'),
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              //ação
              if (commentController.text != "") {
                await checkComment(widget.collection, commentController.text,
                    widget.documentId);
                setState(() {});
              }
            },
            child: Text("Enviar Comentário"))
      ],
    );
  }

  Future<void> checkComment(String collection, String comment, id) async {
    CollectionReference ref = FirebaseFirestore.instance.collection(collection);
    final doc = ref.doc(id);

    await doc.get().then((value) async => {
          await value.reference.snapshots().first.then(
            (element) async {
              Map<String, dynamic> data =
                  element.data() as Map<String, dynamic>;
              List commentsList = data['comments'] ?? [];
              final index = (commentsList.length > 0)
                  ? commentsList.indexWhere((review) =>
                      review["userId"] ==
                      FirebaseAuth.instance.currentUser?.uid)
                  : 0;
              if (commentsList.length > 0 && index >= 0) {
                commentsList[index]["comment"] = comment;
              } else {
                commentsList.add({
                  "userId": FirebaseAuth.instance.currentUser?.uid,
                  "name": FirebaseAuth.instance.currentUser?.displayName,
                  "comment": comment
                });
              }
              data['comments'] = commentsList;
              await doc.set(data);
            },
          )
        });
  }
}
