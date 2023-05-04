import 'package:academy_app/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/sliders.dart';

class CarouselSliderWidget extends StatelessWidget {
  const CarouselSliderWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final slides = Provider.of<Sliders>(context,listen: false).slides;
    print("slides:$slides");
    return Container(
      margin: const EdgeInsets.only(top: 15),
      width: context.screenWidth * 0.95,
      child: CarouselSlider.builder(
        itemCount: slides.length,
        itemBuilder: (ctx, index, realIdx) {
          return SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                slides[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 200,
          //aspectRatio: 16/9,
          viewportFraction: 0.8,
          initialPage: 0,
          //enableInfiniteScroll: true,
          //reverse: false,
          // autoPlay: true,
          // autoPlayInterval: Duration(seconds: 3),
          // autoPlayAnimationDuration: Duration(milliseconds: 800),
          // autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          // onPageChanged: callbackFunction,
          // scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
