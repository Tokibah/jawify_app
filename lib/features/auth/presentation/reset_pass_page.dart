import 'package:flutter/material.dart';
import 'package:jawify/core/auth_service.dart';

class ResetPassPage extends StatelessWidget {
  const ResetPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCon = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Terlupa kata laluan?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                  onPressed: () {
                    AuthService.resetPassword(context, emailCon.text);
                  },
                  child: const Text(
                    "Hantar",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
