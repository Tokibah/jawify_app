import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jawify/core/auth_service.dart';

class ResetPassPage extends StatefulWidget {
  const ResetPassPage({super.key});

  @override
  State<ResetPassPage> createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  final emailCon = TextEditingController();
  bool isButtonEnabled = true;
  Timer? cooldownTimer;

  void sendResetEmail() {
    if (!isButtonEnabled) return;

    AuthService.resetPassword(context, emailCon.text);

    setState(() {
      isButtonEnabled = false;
    });

    cooldownTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        isButtonEnabled = true;
      });
    });
  }

  @override
  void dispose() {
    emailCon.dispose();
    cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: 330,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Terlupa kata laluan?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    )),
                const Text(
                    "Sila masukkan emel akaun anda dan kami akan menghantar pautan ke emel anda untuk proses penukaran kata laluan"),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/forgotpass.png",
                    height: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: emailCon,
                    decoration: const InputDecoration(hintText: "emel"),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: isButtonEnabled ? sendResetEmail : null,
                    child: Text(
                      isButtonEnabled ? "Hantar" : "Tunggu...",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
