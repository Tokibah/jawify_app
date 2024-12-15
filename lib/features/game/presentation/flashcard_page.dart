import 'package:flutter/material.dart';
import 'package:jawify/core/theme.dart';
import 'package:jawify/features/game/data/flashcard_service.dart';
import 'package:provider/provider.dart';

class FlashCardPage extends StatefulWidget {
  const FlashCardPage({super.key});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  List<FlashCard> flashList = [];
  final _pagecontrol = PageController(viewportFraction: 0.8, initialPage: 100);
  ScaffoldMessengerState? _scaffoldState;

  void showAnswer(String ans) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
            child: Text(
      ans,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
    ))));
  }

  void getFlash() async {
    flashList = await FlashCard.getFlashCard();
    flashList.shuffle();
    setState(() {});
  }

  @override
  void initState() {
    getFlash();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _scaffoldState = ScaffoldMessenger.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scaffoldState?.clearSnackBars();
    _pagecontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maincolor =
        Provider.of<ThemeProvider>(context).themeData.colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "KAD KILAT",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: flashList.isNotEmpty
          ? SizedBox(
              height: 600,
              child: PageView.builder(
                  controller: _pagecontrol,
                  itemBuilder: (context, index) {
                    final flash = flashList[index % flashList.length];

                    return InkWell(
                      onTap: () {
                        showAnswer(flash.an);
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        height: 200,
                        decoration: BoxDecoration(
                            color: maincolor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(flash.qu, style: const TextStyle(fontSize: 60)),
                        ),
                      ),
                    );
                  }),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
