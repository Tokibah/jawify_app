import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jawify/core/theme.dart';
import 'package:jawify/core/user_service.dart';
import 'package:jawify/features/level/data/level_service.dart';
import 'package:jawify/features/level/data/question_service.dart';
import 'package:provider/provider.dart';

class InGamePage extends StatefulWidget {
  const InGamePage({
    super.key,
    required this.level,
    required this.currprog,
    required this.player,
  });
  final Level level;
  final List<int> currprog;
  final Player player;

  @override
  State<InGamePage> createState() => _InGamePageState();
}

class _InGamePageState extends State<InGamePage> {
  ScaffoldMessengerState? _scaffoldState;
  Question? question;
  int queIndex = 0;
  int currLife = 0;
  List<String> currAns = [];
  String? selectedOption;
  List<String> selectedOrder = [];
  bool isSnack = false;
  final _audioPlayer = AudioPlayer();

  void showContent() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(widget.level.title),
              content: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(widget.level.explain),
                  SizedBox(
                      height: 500,
                      width: double.infinity,
                      child: InteractiveViewer(
                          child: Image.asset(
                        widget.level.content,
                        fit: BoxFit.contain,
                      )))
                ]),
              ),
            ));
  }

  @override
  void initState() {
    currLife = widget.player.life;
    question = widget.level.quesList[queIndex];
    question!.opt.shuffle();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showContent();
    });
  }

  @override
  void didChangeDependencies() {
    _scaffoldState = ScaffoldMessenger.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scaffoldState?.clearSnackBars();
    super.dispose();
  }

  void nextQuestion() async {
    if (currLife == 0) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Icon(Icons.warning, size: 50),
                    ),
                  ),
                  const Text(
                    "Anda kehabisan nyawa, cuba lagi besok",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Kembali ke laman utama",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                )
              ],
            );
          });
      completeGame();
    }
    setState(() {
      queIndex++;
      question = widget.level.quesList[queIndex];
      question!.opt.shuffle();
      selectedOption = '';
      selectedOrder.clear();
    });
  }

  Future<void> completeGame() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(20)),
              child: const Center(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                    Icons.diamond,
                    color: Colors.blue,
                    size: 40,
                  ),
                  Text(
                    "+10",
                    style: TextStyle(fontSize: 30),
                  )
                ]),
              ),
            ),
            actions: [
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Kembali ke laman utama",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              )
            ],
          );
        });
    await Player.updateCompLevel(
      currLife,
      widget.player.gem + 10,
      widget.currprog,
      widget.player.level,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void showMess(bool iscorrect, String ans) {
    setState(() {
      isSnack = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(days: 1),
      action: SnackBarAction(
        label: "BAIK!",
        onPressed: () {
          setState(() {
            isSnack = false;
          });
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          if (queIndex >= widget.level.quesList.length - 1) {
            completeGame();
          } else {
            nextQuestion();
          }
        },
      ),
      backgroundColor: iscorrect ? Colors.green : Colors.red,
      content: Text(
        iscorrect
            ? "JAWAPAN BETUL!"
            : "JAWAPAN SALAH\njawapan yang betul adalah ${ans.toString()}",
        style: const TextStyle(fontSize: 30),
      ),
    ));
  }

  void playWrong() {
    _audioPlayer.play(AssetSource("audios/wrong.wav"));
  }

  void playCorrect() {
    _audioPlayer.play(AssetSource("audios/correct.wav"));
  }

  void checkChoose(String an) {
    setState(() {
      selectedOption = an;
    });

    currAns.add(an);
    if (const ListEquality().equals(currAns, question!.ans)) {
      playCorrect();
      showMess(true, '');
    } else {
      playWrong();
      showMess(false, question!.ans.toString());
      currLife--;
    }

    currAns.clear();
  }

  void checkOrder(String an) {
    setState(() {
      if (selectedOrder.contains(an)) {
        selectedOrder.remove(an);
      } else {
        selectedOrder.add(an);
      }
    });

    if (selectedOrder.length == question!.ans.length) {
      if (const ListEquality().equals(selectedOrder, question!.ans)) {
        playCorrect();
        showMess(true, '');
      } else {
        playWrong();
        showMess(false, question!.ans.toString());
        currLife--;
      }
      selectedOrder.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor =
        Provider.of<ThemeProvider>(context).themeData.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if (!isSnack) Navigator.pop(context, currLife);
              },
              icon: const Icon(Icons.arrow_back)),
          title: Text(widget.level.title),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(children: [
                const Icon(Icons.local_hospital, size: 30, color: Colors.red),
                Text(currLife.toString(),
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
              ]),
            ),
          ]),
      body: AbsorbPointer(
        absorbing: isSnack,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text(
                question!.type == "choose"
                    ? "Pilih jawapan yang betul"
                    : "Tekan jawapan mengikut urutan yang betul",
                style: const TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 200,
                child: Center(
                  child: Wrap(children: [
                    for (var q in question!.que)
                      Container(
                        height: 100,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: mainColor),
                        child: Center(
                          child: Text(
                            q,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                  ]),
                ),
              ),
              Center(
                child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (var o in question!.opt)
                        InkWell(
                          onTap: () {
                            question!.type == "choose"
                                ? checkChoose(o)
                                : checkOrder(o);
                          },
                          child: Container(
                            height: 150,
                            width: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: question!.type == "choose"
                                  ? (selectedOption == o
                                      ? Colors.green
                                      : Colors.grey)
                                  : (selectedOrder.contains(o)
                                      ? Colors.green
                                      : Colors.grey),
                              border: Border.all(),
                            ),
                            child: Center(
                              child: Text(
                                o,
                                style: const TextStyle(fontSize: 60),
                              ),
                            ),
                          ),
                        ),
                    ]),
              )
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.menu_book),
          onPressed: () {
            showContent();
          }),
    );
  }
}
