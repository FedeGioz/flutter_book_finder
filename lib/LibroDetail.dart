import 'dart:js_interop';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'libro.dart';
import 'package:url_launcher/url_launcher.dart';

class LibroDetail extends StatelessWidget {
  const LibroDetail({super.key, required this.libro});

  final Libro libro;

  @override
  Widget build(BuildContext context) {
    RatingBarIndicator? indicator;
    if(libro.rating != -1){
      indicator =
        RatingBarIndicator(
            rating: libro.rating,
            itemCount: 5,
            itemSize: 30.0,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            )
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Dettaglio: ${libro.titolo}"),
      ),
      body: SingleChildScrollView(child: Center(
        child: Column(
          children: [
            Image.network(libro.immagine),
            SizedBox(height: 10,),
            Text(libro.titolo),
            SizedBox(height: 10,),
            Text(libro.autore.toString()),
            SizedBox(height: 10,),
            Container(child: indicator,),
            SizedBox(height: 10,),
            Container(
              child: Text(libro.descrizione, textAlign: TextAlign.justify,),
              constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
            ),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: _launchUrl, child: Text("Acquista"))
          ],
        ),
      ),
    ));
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(libro.link))) {
      throw Exception('Could not launch ${libro.link}');
    }
  }
}