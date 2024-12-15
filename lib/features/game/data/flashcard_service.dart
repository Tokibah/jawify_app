// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance.collection("Flash");

class FlashCard {
  String qu;
  String an;
  FlashCard({
    required this.qu,
    required this.an,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'qu': qu,
      'an': an,
    };
  }

  factory FlashCard.fromMap(Map<String, dynamic> map) {
    return FlashCard(
      qu: map['qu'] as String,
      an: map['an'] as String,
    );
  }

  static Future<List<FlashCard>> getFlashCard() async {
    try {
      List<FlashCard> flashList = [];
      final flashMap = await firestore.get();
      for (var doc in flashMap.docs) {
        flashList.add(FlashCard.fromMap(doc.data()));
      }
      return flashList;
    } catch (e) {
      print("ERROR getFlashCard: ${e.toString()}");
      return [];
    }
  }
}
