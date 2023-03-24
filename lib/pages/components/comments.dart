import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              hintText: 'Digite aqui...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            minLines: 4,
            maxLines: 20,
          ),
        ),
        ElevatedButton(
            onPressed: () {
              //ação
            },
            child: Text("Enviar Comentário")),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text("Comentários (${widget.comments.length})"),
        ),
        Container(
          height: MediaQuery.of(context).size.height > 400
              ? 400
              : MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            itemCount: widget.comments.length ?? 0,
            itemBuilder: (context, index) {
              if (!widget.comments.length) {
                return Center(
                  child: Text("Nenhum comentário ainda, faça o seu!"),
                );
              }
              final row = widget.comments[index];
              return ListTile(
                  title: Text(row['name'] ?? "Name"),
                  subtitle: Text(row['comment'] ?? "comment"));
            },
          ),
        )
      ],
    );
  }
}
