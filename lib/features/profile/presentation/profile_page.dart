import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jawify/core/theme.dart';
import 'package:jawify/features/auth/presentation/login_page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {super.key,
      required this.username,
      required this.email,
      required this.date});

  final String username;
  final String email;
  final String date;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 150,
          child: Stack(children: [
            Image.asset(
              "assets/images/profile_back.png",
              fit: BoxFit.cover,
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            themeProvider.toggleMode();
                          });
                        },
                        child: Icon(themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Icons.light_mode
                            : Icons.dark_mode)),
                  ),
                )),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                widget.username,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              widget.email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              "Sertai pada ${widget.date}",
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: SizedBox(
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () async {
                        context.loaderOverlay.show();
                        await FirebaseAuth.instance.signOut();
                        themeProvider.setLight();
                        context.loaderOverlay.hide();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        "LOG OUT",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      )),
                ),
              ),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
              child: Column(
                children: [
                  Container(
                    height: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all()),
                    child: const Center(
                      child: Icon(Icons.thumb_up, size: 60),
                    ),
                  ),
                  const Text(
                    "Sekiranya ada masalah sila laporkan ke kumpulan kami\nMuhammad Shahizz Ifwat\nAriff Iskandar\nAzfar",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            )
          ]),
        ),
      ]),
    );
  }
}
