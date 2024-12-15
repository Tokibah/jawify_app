import 'package:flutter/material.dart';
import 'package:jawify/core/theme.dart';
import 'package:jawify/core/user_service.dart';
import 'package:jawify/features/frame/presentation/frame_layer.dart';
import 'package:provider/provider.dart';

class ProficientPage extends StatelessWidget {
  const ProficientPage(
      {super.key,
      required this.username,
      required this.email,
      required this.password});

  final String username;
  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    List<String> text = ["PERMULA", "BERPENGALAMAN", "MAHIR"];
    List<String> image = [
      "assets/images/profi_1.png",
      "assets/images/profi_2.png",
      "assets/images/profi_3.png"
    ];

    void showConfirmation(int index, String proficiency) {
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
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Icon(Icons.question_mark, size: 50),
                    ),
                  ),
                  Text(
                    "Tahap kemahiran anda dalam jawi adalah\n$proficiency",
                    style: const TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "TIDAK",
                      style: TextStyle(color: Colors.black),
                    )),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () async {
                        await Player.addUser(username, email, password, index);
                        await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FrameLayer()));
                      },
                      child: const Text(
                        "MULA BELAJAR!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                )
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Tahap kemahiran anda",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Image.asset(
              "assets/images/waving.png",
              height: 170,
            ),
            SizedBox(
              height: 410,
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showConfirmation(index, text[index]);
                      },
                      child: Container(
                          margin: const EdgeInsets.all(7),
                          height: 125,
                          decoration: BoxDecoration(
                              color: Provider.of<ThemeProvider>(context)
                                  .themeData
                                  .colorScheme
                                  .primary,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  opacity: 0.3,
                                  fit: BoxFit.cover,
                                  image: AssetImage(image[index]))),
                          child: Center(
                            child: Text(
                              text[index],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          )),
                    );
                  }),
            )
          ]),
        ),
      ),
    );
  }
}
