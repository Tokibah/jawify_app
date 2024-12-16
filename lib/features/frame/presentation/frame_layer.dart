import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:jawify/core/page_transition_slide.dart';
import 'package:jawify/core/user_service.dart';
import 'package:jawify/features/auth/presentation/login_page.dart';
import 'package:jawify/features/dictionary/presentation/dictionary_page.dart';
import 'package:jawify/features/frame/widget/bottombar.dart';
import 'package:jawify/features/frame/widget/topbar.dart';
import 'package:jawify/features/level/presentation/level_page.dart';
import 'package:jawify/features/profile/presentation/profile_page.dart';
import 'package:jawify/features/game/presentation/game_page.dart';
import 'package:jawify/features/ranking/presentation/ranking_page.dart';
import 'package:jawify/features/shop/presentation/shop_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrameLayer extends StatefulWidget {
  const FrameLayer({super.key});

  @override
  State<FrameLayer> createState() => _FrameLayerState();
}

class _FrameLayerState extends State<FrameLayer> {
  Player? player;
  final user = FirebaseAuth.instance.currentUser;

  final ValueNotifier<int> _currentPageview = ValueNotifier<int>(0);
  final PageController pageController = PageController();

  Future<void> emailVerifyNofi() async {
    await user?.reload();
    if (user != null && !user!.emailVerified) {
      showDialog(
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
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Icon(Icons.email, size: 50),
                    ),
                  ),
                  const Text(
                    "Pautan pengaktifan emel telah dihantar ke emel anda\njika sudah sila reset aplikasi",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Teruskan",
                      style: TextStyle(color: Colors.grey),
                    )),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await FirebaseAuth.instance.currentUser
                            ?.sendEmailVerification();
                      },
                      child: const Text(
                        "Minta pautan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                )
              ],
            );
          });
    }
  }

  void listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }

  void getData() async {
    player = await Player.getPlayer();
    setState(() {});
  }

  void checkDailyLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    final lastLoginDate = prefs.getString("LoginKey");
    if (lastLoginDate != null) {
      DateTime lastDate = DateTime.parse(lastLoginDate);
      if (DateFormat('yyyy-MM-dd').format(lastDate) != today) {
        if (now.difference(lastDate).inDays == 1) {
          await Player.updateDaily(player!.streak + 1, 5);
        } else {
          await Player.updateDaily(1, 5);
        }
        await prefs.setString("LoginKey", today);
      }
    } else {
      await prefs.setString("LoginKey", today);
    }
  }

  @override
  void initState() {
    listenToAuthChanges();
    getData();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkDailyLogin();
      emailVerifyNofi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return player != null
        ? Scaffold(
            body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Stack(children: [
              PageView(
                controller: pageController,
                onPageChanged: (index) => _currentPageview.value = index,
                children: [
                  LevelPage(level: player!.level, user: player!),
                  const QuizPage(),
                  const RankingPage(),
                  const ShopPage(),
                  ProfilePage(
                      username: player!.username,
                      email: player!.email,
                      date: player!.date)
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Topbar(
                        streak: player!.streak,
                        gem: player!.gem,
                        life: player!.life)),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        SlideRoute(
                                            page: const DictionaryPage()));
                                  },
                                  child: const Icon(Icons.book))),
                        ),
                        BottomBar(
                          pageNotifier: _currentPageview,
                          onPageSelected: (index) {
                            pageController.animateToPage(index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                        ),
                      ]),
                ),
              )
            ]),
          ))
        : const Center(
            child: SpinKitFadingCube(color: Colors.amber, size: 50),
          );
  }
}
