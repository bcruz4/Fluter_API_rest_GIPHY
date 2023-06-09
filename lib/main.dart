// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/gif.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: unused_field
  late Future<List<Gif>> _listadoGifs;
  Future<List<Gif>> _getGifs() async {
    final url = Uri.parse(
        'https://api.giphy.com/v1/gifs/trending?api_key=KlU6LdPlSxkY9Z1C4XMdvrZbPIRuWgLG&limit=5&rating=g');
    final response = await http.get(url);

    //creamos la lista
    List<Gif> gifs = [];

    if (response.statusCode == 200) {
      // body, para corregir errores de escritura enviados por la api
      String body = utf8.decode(response.bodyBytes);
      //convertir body en json
      final jsonData = jsonDecode(body);

      //ingresar a los datos del json mediante [] en cadena ['dato']['dato']....
      //print(jsonData['data'][0]);

      for (var item in jsonData["data"]) {
        //notar que deben de coincidir con los valores de gif.dart title y url
        gifs.add(
            Gif(title: item["title"], url: item["images"]["downsized"]["url"]));
      }
      return gifs;
      //print(gifs);

      // print('⚡Response status: ${response.statusCode}');
      // print('⚡Response body: ${response.body}');
    } else {
      throw Exception('Fallo la conexión');
    }
    // Agregar esta línea si es necesario por si llegar a tener valores nulos
    //return [];
  }

  @override
  // esta funcion se ejecuta al abrir la aplicacion o la ventna
  void initState() {
    super.initState();
    _listadoGifs = _getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: FutureBuilder(
          future: _listadoGifs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final gifs = _listGifs(snapshot.data!);
              return GridView.count(
                crossAxisCount: 2,
                children: gifs,
              );
            } else if (snapshot.hasError) {
              return const Text('Error');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  //crear una lista de gifs
  //recibe los datos de children: _listGifs(snapshot.data),
  List<Widget> _listGifs(List<Gif> data) {
    List<Widget> gifs = [];
    for (var gif in data) {
      gifs.add(
        Card(
          child: Column(
            children: [
              //agregar la imagen
              Image.network(gif.url),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(gif.title),
              ),
            ],
          ),
        ),
      );
    }
    return gifs;
  }
}
