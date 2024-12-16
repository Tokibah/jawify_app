import 'package:flutter/material.dart';
import 'package:jawify/core/theme.dart';
import 'package:provider/provider.dart';

class Topbar extends StatelessWidget {
  const Topbar(
      {super.key, required this.streak, required this.gem, required this.life});

  final int streak;
  final int gem;
  final int life;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Widget topIcon(
        {required IconData icon, required int number, required Color color}) {
      return Row(children: [
        Icon(
          icon,
          color: color,
          size: 30,
        ),
        Text(
          number.toString(),
          style: TextStyle(
              color: color, fontSize: 20, fontWeight: FontWeight.bold),
        )
      ]);
    }

    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: themeProvider.themeData.brightness == Brightness.light
            ? ThemeProvider.lightBack.withBlue(160)
            : ThemeProvider.darkBack.withBlue(50),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        topIcon(
            icon: Icons.local_fire_department,
            number: streak,
            color: Colors.orange),
        topIcon(icon: Icons.diamond, number: gem, color: Colors.blue),
        topIcon(icon: Icons.local_hospital, number: life, color: Colors.red)
      ]),
    );
  }
}
