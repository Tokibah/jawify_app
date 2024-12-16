import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:jawify/core/theme.dart';
import 'package:jawify/features/dictionary/data/dictionary_service.dart';
import 'package:provider/provider.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  List<DictionaryButton> buttonList = [];

  void playAudio(String source) {
    final player = AudioPlayer();
    player.play(AssetSource(source));
  }

  void getButton() async {
    buttonList = await DictionaryButton.generateButton();
    setState(() {});
  }

  @override
  void initState() {
    getButton();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Huruf Jawi"),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          children: List.generate(buttonList.length, (index) {
            final button = buttonList[index];

            return InkWell(
              onTap: () {
                playAudio(button.audio);
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: themeProvider.themeData.colorScheme.secondary,
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(8, 8),
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? ThemeProvider.darkBack
                              : ThemeProvider.lightBack)
                    ],
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  button.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 50),
                )),
              ),
            );
          }),
        ));
  }
}
