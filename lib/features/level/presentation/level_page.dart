import 'package:flutter/material.dart';
import 'package:jawify/core/user_service.dart';
import 'package:jawify/features/frame/presentation/frame_layer.dart';
import 'package:jawify/features/level/data/chapter_service.dart';
import 'package:jawify/features/level/presentation/chapter_list_page.dart';
import 'package:jawify/features/level/presentation/ingame_page.dart';
import 'package:jawify/features/level/widget/chapter_box.dart';
import 'package:jawify/features/level/widget/level_box.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({super.key, required this.level, required this.user});
  final List<int> level;
  final Player user;

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  int chapIndex = 0;
  bool hasLoad = false;
  Chapter? chapter;

  void getChapter() async {
    chapter = await Chapter.getChapter(chapIndex);
    hasLoad = true;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    chapIndex = widget.level[0];
    getChapter();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return hasLoad
        ? Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 10),
              child: Column(children: [
                ChapterBox(
                  chapter: chapter!.chapter.toString(),
                  name: chapter!.name,
                  jawi: chapter!.jawi,
                  ontap: () async {
                    final tempIndex = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChapterListPage(chapProg: widget.level[0])));
                    if (tempIndex != null) {
                      chapIndex = tempIndex;
                      getChapter();
                    }
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(children: [
                    for (int i = 0; i < chapter!.levelList.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                            left: i % 2 == 1 ? 200.0 : 0.0,
                            right: i % 2 == 0 ? 200.0 : 0.0,
                            top: 10,
                            bottom: 30),
                        child: InkWell(
                          onTap: () async {
                            if (widget.user.life <= 0) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text("Tiada nyawa")));
                            } else if (widget.level[0] >= chapter!.chapter ||
                                widget.level[1] >= i) {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InGamePage(
                                          level: chapter!.levelList[i],
                                          currprog: [chapIndex, i],
                                          player: widget.user)));

                              await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FrameLayer()));
                            }
                          },
                          child: LevelBox(
                            prog: widget.level,
                            index: i,
                            chapter: chapter!.chapter,
                          ),
                        ),
                      )
                  ])),
                )
              ]),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
