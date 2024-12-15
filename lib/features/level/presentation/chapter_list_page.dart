import 'package:flutter/material.dart';
import 'package:jawify/features/level/data/chapter_service.dart';
import 'package:jawify/features/level/widget/chapter_box.dart';

class ChapterListPage extends StatefulWidget {
  const ChapterListPage({super.key, required this.chapProg});
  final int chapProg;

  @override
  State<ChapterListPage> createState() => _ChapterListPageState();
}

class _ChapterListPageState extends State<ChapterListPage> {
  List<Chapter> chapList = [];

  void getAllChap() async {
    chapList = await Chapter.getAllChapter();
    setState(() {});
  }

  @override
  void initState() {
    getAllChap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chapter List"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
              height: 200 * chapList.length.toDouble(),
              width: double.infinity,
              child: ListView.builder(
                  itemCount: chapList.length,
                  itemBuilder: (context, index) {
                    Chapter chapter = chapList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: ChapterBox(
                          chapter: chapter.chapter.toString(),
                          name: chapter.name,
                          jawi: chapter.jawi,
                          color: widget.chapProg >= index ? null : Colors.grey,
                          ontap: () {
                            widget.chapProg >= index
                                ? Navigator.pop(context, index)
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                            "Anda belum sampai ke tahap ini")));
                          }),
                    );
                  })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChapterBox(
                chapter: '', name: "Akan Datang", jawi: '', ontap: () {}),
          )
        ],
      ),
    );
  }
}
