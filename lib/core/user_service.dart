import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:jawify/features/level/data/chapter_service.dart';

final firestore = FirebaseFirestore.instance
    .collection("Player")
    .doc(FirebaseAuth.instance.currentUser!.email);

class Player {
  String username;
  String email;
  String date;
  List<int> level;
  int quiz;
  int streak;
  int gem;
  int life;

  Player({
    required this.username,
    required this.email,
    required this.date,
    required this.level,
    required this.quiz,
    required this.streak,
    required this.gem,
    required this.life,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'date': date,
      'level': level,
      'quiz': quiz,
      'streak': streak,
      'gem': gem,
      'life': life,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      username: map['username'] as String,
      email: map['email'] as String,
      date: map['date'] as String,
      level: (map['level'] as List<dynamic>).map((e) => e as int).toList(),
      quiz: map['quiz'] as int,
      streak: map['streak'] as int,
      gem: map['gem'] as int,
      life: map['life'] as int,
    );
  }

  static Future<void> addUser(
      String username, String email, String password, int index) async {
    try {
      List<Chapter> chapList = await Chapter.getAllChapter();
      Chapter? chap = await Chapter.getChapter(chapList.length - 1);

      List<int> level = [];
      if (index == 0) {
        level = [0, 0];
      } else if (index == 1) {
        level = [((chapList.length - 1) ~/ 2), 0];
      } else {
        level = [chapList.length - 1, chap!.levelList.length - 1];
      }

      final newPlayer = Player(
          username: username,
          email: email,
          date: DateFormat('d MMMM yyyy').format(DateTime.now()),
          level: level,
          quiz: 0,
          streak: 1,
          gem: 10,
          life: 5);

      await FirebaseFirestore.instance
          .collection("Player")
          .doc(email)
          .set(newPlayer.toMap());
    } catch (e) {
      print("ERROR AddUser: ${e.toString()}");
    }
  }

  static Future<Player?> getPlayer() async {
    try {
      final playerMap = await firestore.get();
      return Player.fromMap(playerMap.data()!);
    } catch (e) {
      print("ERROR getPlayer: ${e.toString()}");
      return null;
    }
  }

  static Future<void> updatelife(int? life) async {
    try {
      if (life == null) return;
      await firestore.update({'life': life});
    } catch (e) {
      print("ERROR updateUser: ${e.toString()}");
    }
  }

  static Future<void> updateDaily(int streak, int life) async {
    try {
      await firestore.update({'life': life, 'streak': streak});
    } catch (e) {
      print("ERROR updateDaily: ${e.toString()}");
    }
  }

  static Future<void> updateCompLevel(
      int life, int gems, List<int> level, List<int> reList) async {
    try {
      Chapter? chapter = await Chapter.getChapter(level[0]);
      List<Chapter> chapList = await Chapter.getAllChapter();

      if (level[0] < reList[0] || level[1] < reList[1]) {
        level = reList;
      } else if (level[1] < chapter!.levelList.length - 1) {
        level[1]++;
      } else {
        if (level[0] >= chapList.length - 1) {
          level = level;
        } else {
          level[0]++;
          level[1] = 0;
        }
      }
      await firestore.update({'life': life, 'gem': gems, 'level': level});
    } catch (e) {
      print("ERROR uupdateCompLevel: ${e.toString()}");
    }
  }
}
