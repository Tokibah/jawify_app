import 'package:flutter/material.dart';

class GameBox extends StatelessWidget {
  const GameBox(
      {super.key,
      this.image =
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5SHt53qV1_JKCb2-p3926isqbiI4iRNNIAw&s",
      this.title = "Akan Datang",
      this.color = Colors.grey,
      required this.ontap});

  final String image;
  final String title;
  final Color color;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
          margin: const EdgeInsets.all(10),
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(color, BlendMode.hue),
                  fit: BoxFit.cover,
                  image: NetworkImage(image)),
              color: Colors.grey,
              border: Border.all(),
              borderRadius: BorderRadius.circular(20)),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              height: 50,
              width: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color, color.withGreen(100)])),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )),
    );
  }
}
