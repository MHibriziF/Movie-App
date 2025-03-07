import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FullscreenSlider extends StatelessWidget {
  const FullscreenSlider({super.key});

  static String getImageSize(double width) {
    if (width <= 154) return "w154";
    if (width <= 185) return "w185";
    if (width <= 342) return "w342";
    if (width <= 500) return "w500";
    if (width <= 780) return "w780";
    if (width <= 1280) return "w1280";
    return "original";
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final width = getImageSize(MediaQuery.of(context).size.width);
    final imageUrl = "https://image.tmdb.org/t/p/$width";
    final List<String> imgList = [
      '$imageUrl/nv5DrlFpIYIPYhwvP2wg8VjdPwl.jpg',
      '$imageUrl/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
      '$imageUrl/aLVkiINlIeCkcZIzb7XHzPYgO6L.jpg',
      '$imageUrl/srwwY0QG8x3Q306cnfjT1ymRTgn.jpg',
      '$imageUrl/vGXptEdgZIhPg3cGlc7e8sNPC2e.jpg',
      '$imageUrl/2cxhvwyEwRlysAmRH4iodkvo0z5.jpg',
      '$imageUrl/lWh5OlerPR1c1cfn1ZLq0lpqFds.jpg',
      '$imageUrl/rS18oKisFLTRbd83E4PxSkygC4F.jpg',
      '$imageUrl/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: height,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        autoPlay: true,
      ),
      items: imgList.map((item) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                item,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter:
                    ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Blur intensity
                child: Container(
                  color: const Color.fromARGB(90, 0, 0, 0),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
