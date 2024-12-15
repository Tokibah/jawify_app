import 'package:flutter/material.dart';
import 'package:jawify/core/theme.dart';
import 'package:provider/provider.dart';

class LevelBox extends StatelessWidget {
  const LevelBox(
      {super.key,
      required this.prog,
      required this.index,
      required this.chapter});
  final List<int> prog;
  final int index;
  final int chapter;

  @override
  Widget build(BuildContext context) {
    bool isUnlock = prog[0] >= chapter || prog[1] >= index;
    Color mainColor =
        Provider.of<ThemeProvider>(context).themeData.colorScheme.primary;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
        height: 115,
        width: 120,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: const Offset(2, 9),
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? ThemeProvider.darkBack
                      : ThemeProvider.lightBack)
            ],
            color: isUnlock ? mainColor : Colors.grey,
            borderRadius: BorderRadius.circular(100)),
        child: const Center(child: Icon(Icons.menu_book, size: 50)));
  }
}
