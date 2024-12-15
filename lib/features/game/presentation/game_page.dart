import 'package:flutter/material.dart';
import 'package:jawify/core/theme.dart';
import 'package:jawify/features/game/presentation/flashcard_page.dart';
import 'package:jawify/features/game/widget/game_box.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    Color mainColor =
        Provider.of<ThemeProvider>(context).themeData.colorScheme.secondary;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        const SizedBox(height: 75),
        Image.asset(
          "assets/images/quiz.png",
          height: 180,
        ),
        const Divider(
          endIndent: 20,
          indent: 20,
        ),
        GameBox(
          title: "Kad Kilat",
          image:
              "https://images.vexels.com/content/3534/preview/colorful-abstract-design-background-23b0c0.png",
          color: mainColor,
          ontap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const FlashCardPage()));
          },
        ),
        GameBox(ontap: () {}),
        GameBox(ontap: () {})
      ]),
    ));
  }
}
