// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance
    .collection("Player")
    .orderBy('gem', descending: true);

class Ranking {
  String username;
  int gem;
  Ranking({
    required this.username,
    required this.gem,
  });

  factory Ranking.fromMap(Map<String, dynamic> map) {
    return Ranking(
      username: map['username'] as String,
      gem: map['gem'] as int,
    );
  }

  static Future<List<Ranking>> getAllRank() async {
    try {
      List<Ranking> rankList = [];
      final rankMap = await firestore.get();
      for (var doc in rankMap.docs) {
        rankList.add(Ranking.fromMap(doc.data()));
      }
      return rankList;
    } catch (e) {
      print("ERROR getAllRank: ${e.toString()}");
      return [];
    }
  }
}
