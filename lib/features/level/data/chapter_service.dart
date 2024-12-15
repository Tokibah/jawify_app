// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawify/features/level/data/level_service.dart';

final firestore = FirebaseFirestore.instance.collection("Learn");

class Chapter {
  String name;
  String jawi;
  int chapter;
  List<Level> levelList;
  Chapter({
    required this.name,
    required this.jawi,
    required this.chapter,
    this.levelList = const [],
  });

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      name: map['name'] as String,
      jawi: map['jawi'] as String,
      chapter: map['chapter'] as int,
    );
  }

  static Future<Chapter?> getChapter(int chapIndex) async {
    try {
      final chapMap = await firestore.orderBy("chapter").get();

      Chapter chapter = Chapter.fromMap(chapMap.docs[chapIndex].data());
      List<Level> levelList = await Level.getLevel(chapMap.docs[chapIndex].id);
      chapter.levelList = levelList;

      return chapter;
    } catch (e) {
      print("ERROR getChapter: ${e.toString()}");
      return null;
    }
  }

  static Future<List<Chapter>> getAllChapter() async {
    try {
      List<Chapter> chapList = [];
      final chapMap = await firestore.orderBy("chapter").get();

      for (var doc in chapMap.docs) {
        chapList.add(Chapter.fromMap(doc.data()));
      }
      return chapList;
    } catch (e) {
      print("ERROR getAllChapter: ${e.toString()}");
      return [];
    }
  }
}
