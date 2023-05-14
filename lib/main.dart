import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late List<dynamic> imagePaths = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    imagePaths = await getImageUrl();
    setState(() {});
  }

  Future<List<dynamic>> getImageUrl() async {
    var imagePaths = [];
    var result = await Apiservice().getdata(Apiservice().popular);
    for (var res in result['results']) {
      imagePaths.add(Apiservice().image_base + res['poster_path']);
    }
    return imagePaths;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Popular Movies',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                ),
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    //Image with round corner
                    for (var url in imagePaths) ImageWidget(image_url: url),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade200,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade300,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    this.image_url,
  });
  final image_url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Image(
          image: NetworkImage(image_url),
          width: 400,
          height: 500,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class Apiservice {
  String popular = "https://movies-api.nomadcoders.workers.dev/popular";
  String now_playing = "https://movies-api.nomadcoders.workers.dev/now-playing";
  String coming_soon = "https://movies-api.nomadcoders.workers.dev/coming-soon";
  String detail = "https://movies-api.nomadcoders.workers.dev/movie?id=1";
  String image_base = "https://image.tmdb.org/t/p/w500";

  //get data from api
  Future<dynamic> getdata(String url) async {
    var result = await http.get(Uri.parse(url));
    return json.decode(result.body);
  }
}
