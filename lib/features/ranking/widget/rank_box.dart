import 'package:flutter/material.dart';

class RankBox extends StatelessWidget {
  const RankBox(
      {super.key,
      required this.index,
      required this.name,
      required this.gem,
      this.color});
  final String index;
  final String name;
  final String gem;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: color != null
              ? LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [color!, color!.withBlue(150)])
              : null,
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all()),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            index,
            style: TextStyle(fontSize: 30),
          ),
        ),
        Expanded(
          child: Text(
            name,
            style: TextStyle(fontSize: 25),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 80,
          child: Row(
            children: [Icon(Icons.diamond), Text(gem)],
          ),
        )
      ]),
    );
  }
}
