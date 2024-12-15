import 'dart:async';

import 'package:flutter/material.dart';

class AutoBox extends StatefulWidget {
  const AutoBox({super.key, required this.image});

  final List<String> image;
  @override
  State<AutoBox> createState() => _AutoBoxState();
}

class _AutoBoxState extends State<AutoBox> {
  final _pageCon = PageController(viewportFraction: 0.8);
  Timer? timer;
  int _currPage = 0;

  void startAuto() {
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_currPage < widget.image.length - 1) {
        ++_currPage;
      } else {
        _currPage = 0;
      }

      _pageCon.animateToPage(_currPage,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    });
  }

  @override
  void initState() {
    startAuto();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    _pageCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageCon,
      itemCount: widget.image.length,
      itemBuilder: (context, index) {
        String image = widget.image[index];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
              image:
                  DecorationImage(fit: BoxFit.cover, image: AssetImage(image))),
        );
      },
    );
  }
}
