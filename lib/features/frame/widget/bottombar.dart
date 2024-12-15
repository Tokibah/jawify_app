import 'package:flutter/material.dart';
import 'package:jawify/core/theme.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  const BottomBar(
      {super.key, required this.pageNotifier, required this.onPageSelected});

  final ValueNotifier<int> pageNotifier;
  final Function(int) onPageSelected;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ValueListenableBuilder(
        valueListenable: pageNotifier,
        builder: (context, currentPage, child) {
          Widget BotBarIcon({required IconData icon, required int index}) {
            return GestureDetector(
              onTap: () {
                onPageSelected(index);
              },
              child: Icon(
                icon,
                size: 30,
                color: index == currentPage
                    ? themeProvider.themeData.colorScheme.primary
                    : null,
              ),
            );
          }

          return Container(
            height: 80,
            decoration: BoxDecoration(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? ThemeProvider.lightBack.withBlue(160)
                    : ThemeProvider.darkBack.withBlue(50),
                borderRadius: BorderRadius.circular(40)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BotBarIcon(icon: Icons.home, index: 0),
                BotBarIcon(icon: Icons.quiz, index: 1),
                BotBarIcon(icon: Icons.leaderboard, index: 2),
                BotBarIcon(icon: Icons.shopping_cart_rounded, index: 3),
                BotBarIcon(icon: Icons.person, index: 4)
              ],
            ),
          );
        });
  }
}
