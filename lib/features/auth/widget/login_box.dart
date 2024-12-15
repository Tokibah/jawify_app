import 'package:flutter/material.dart';

class LoginBox extends StatelessWidget {
  const LoginBox({super.key, required this.logo, required this.login});

  final String logo;
  final Function() login;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => login(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 50,
          width: 100,
          child: ElevatedButton(
              clipBehavior: Clip.antiAlias,
              onPressed: () => login,
              child: Image.asset(
                logo,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              )),
        ),
      ),
    );
  }
}
