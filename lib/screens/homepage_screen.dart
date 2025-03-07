import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_app/services/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // body: FutureBuilder(
      //   future: ApiServices.getNowPlaying(1),
      //   builder: (context, AsyncSnapshot snapshot) {
      //     return const Center(child: CircularProgressIndicator());
      //   },
      // ),
    );
  }
}
