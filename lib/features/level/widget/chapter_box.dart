import 'package:flutter/material.dart';
import 'package:jawify/core/theme.dart';
import 'package:provider/provider.dart';

class ChapterBox extends StatelessWidget {
  const ChapterBox(
      {super.key,
      required this.chapter,
      required this.name,
      required this.jawi,
      required this.ontap,
      this.color});
  final Color? color;
  final String chapter;
  final String name;
  final String jawi;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    Color secColor = color ??
        Provider.of<ThemeProvider>(context).themeData.colorScheme.secondary;
    return InkWell(
      onTap: ontap,
      child: Container(
          padding: const EdgeInsets.all(10),
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [secColor, secColor.withGreen(100)]),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bahagian $chapter:",
                  style: const TextStyle(fontSize: 20),
                ),
                Text(name,
                    style:
                        const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const Spacer(),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      jawi,
                      style: const TextStyle(fontSize: 20),
                    ))
              ])),
    );
  }
}
