// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  List<String> que;
  List<String> opt;
  List<String> ans;
  String type;
  Question({
    required this.que,
    required this.opt,
    required this.ans,
    required this.type,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      que: (map['que'] as List<dynamic>).map((e) => e as String).toList(),
      opt: (map['opt'] as List<dynamic>).map((e) => e as String).toList(),
      ans: (map['ans'] as List<dynamic>).map((e) => e as String).toList(),
      type: map['type'] as String,
    );
  }

  static Future<List<Question>> getQue(String chapterId, String levelId) async {
    final firestore = FirebaseFirestore.instance
        .collection("Learn")
        .doc(chapterId)
        .collection("Level")
        .doc(levelId)
        .collection("Question");
    try {
      List<Question> queList = [];
      final queMap = await firestore.get();
      for (var doc in queMap.docs) {
        queList.add(Question.fromMap(doc.data()));
      }
      return queList;
    } catch (e) {
      print("ERROR getQues: ${e.toString()}");
      return [];
    }
  }
}
