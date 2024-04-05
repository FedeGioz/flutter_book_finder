import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LibroDetail.dart';
import 'libro.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Book Finder',
      home: MyHomePageBooks(),
    );
  }
}

class MyHomePageBooks extends StatefulWidget {
  const MyHomePageBooks({super.key});

  @override
  State<MyHomePageBooks> createState() => _MyHomePageBooksState();
}

class _MyHomePageBooksState extends State<MyHomePageBooks>{

  List<Libro> libri = [];

  TextEditingController ctrTitle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Finder',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ricerca'),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
      body: Column(children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Titolo',
              hintText: 'Titolo del libro',
              border: OutlineInputBorder(),
            ),
            controller: ctrTitle,
          ),
          ElevatedButton(
            child: const Text('Cerca'),
            onPressed: (){
              findBooks();
            }
          ),
          Expanded(
            child:
            ListView.builder(
                itemCount: libri.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    title: Text(libri[index].titolo),
                    subtitle: Text(libri[index].autore.toString()),
                    leading: Image.network(libri[index].immagine),
                    trailing: Icon(Icons.open_in_new),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => LibroDetail(libro: libri[index])));
                    }
                  );
                }
            )
          )
        ],
      ),
    ));
  }

  Future findBooks() async {
    const dominio = 'www.googleapis.com';
    const path = '/books/v1/volumes';
    Map<String, dynamic> parametri = {'q': ctrTitle.text};
    Uri uri = Uri.https(dominio, path, parametri);
    http.get(uri).then((result) {

      final booksData = json.decode(result.body);
      final bookDataItem = booksData['items'];

      List<Libro> libri = bookDataItem.map<Libro>((json) => Libro.fromJson(json)).toList();
      setState(() {
        this.libri = libri;
      });
    });
  }
}