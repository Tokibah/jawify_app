import 'package:flutter/material.dart';
import 'package:jawify/features/ranking/data/ranking_service.dart';
import 'package:jawify/features/ranking/widget/rank_box.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<Ranking> rankList = [];

  void getRankList() async {
    rankList = await Ranking.getAllRank();
    setState(() {});
  }

  @override
  void initState() {
    getRankList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 75),
          Image.asset(
            "assets/images/ranking.png",
            height: 180,
          ),
          const Divider(
            endIndent: 20,
            indent: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 600,
              child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 350),
                  itemCount: rankList.length,
                  itemBuilder: (context, index) {
                    Ranking rank = rankList[index];
                    if (index == 0) {
                      return RankBox(
                        index: (index + 1).toString(),
                        name: rank.username,
                        gem: rank.gem.toString(),
                        color: Colors.yellow,
                      );
                    } else if (index == 1) {
                      return RankBox(
                          index: (index + 1).toString(),
                          name: rank.username,
                          gem: rank.gem.toString(),
                          color: Colors.grey);
                    } else if (index == 2) {
                      return RankBox(
                          index: (index + 1).toString(),
                          name: rank.username,
                          gem: rank.gem.toString(),
                          color: Colors.brown);
                    }
                    return RankBox(
                        index: (index + 1).toString(),
                        name: rank.username,
                        gem: rank.gem.toString());
                  }),
            ),
          )
        ]),
      ),
    );
  }
}
