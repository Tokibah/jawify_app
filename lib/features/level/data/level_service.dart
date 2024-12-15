// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawify/features/level/data/question_service.dart';

class Level {
  String title;
  String explain;
  String content;
  String fact;
  List<Question> quesList;
  Level({
    required this.title,
    required this.explain,
    required this.content,
    required this.fact,
    this.quesList = const [],
  });

  factory Level.fromMap(Map<String, dynamic> map) {
    return Level(
      title: map['title'] as String,
      explain: map['explain'] as String,
      content: map['content'] as String,
      fact: map['fact'] as String,
    );
  }

  static Future<List<Level>> getLevel(String chapID) async {
    final firestore = FirebaseFirestore.instance
        .collection("Learn")
        .doc(chapID)
        .collection("Level")
        .orderBy("level");
    try {
      List<Level> levelList = [];
      final levelMap = await firestore.get();
      for (var doc in levelMap.docs) {
        List<Question> queList = await Question.getQue(chapID, doc.id);
        Level level = Level.fromMap(doc.data());
        level.quesList = queList;

        levelList.add(level);
      }

      return levelList;
    } catch (e) {
      print("ERROR getLevel: ${e.toString()}");
      return [];
    }
  }
}
