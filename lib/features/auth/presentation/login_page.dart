import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jawify/core/page_transition_slide.dart';
import 'package:jawify/features/auth/presentation/reset_pass_page.dart';
import 'package:jawify/core/auth_service.dart';
import 'package:jawify/features/auth/widget/auto_box.dart';
import 'package:jawify/features/auth/widget/login_box.dart';
import 'package:jawify/core/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  final List<String> picList = [
    "assets/images/login_1.jpg",
    "assets/images/login_2.jpg",
    "assets/images/login_3.jpg"
  ];

  final _usernameCon = TextEditingController();
  final _emailCon = TextEditingController();
  final _passCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameCon.dispose();
    _emailCon.dispose();
    _passCon.dispose();
    super.dispose();
  }

  void checkValid() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCon.text, password: _passCon.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: AutoBox(image: picList),
              ),
              Form(
                key: _formKey,
                child: Center(
                  child: SizedBox(
                    width: 330,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Text(
                          isLogin ? "LOG MASUK" : "DAFTAR MASUK",
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        if (!isLogin)
                          CusTextField(
                              hint: "nama pengguna",
                              controller: _usernameCon,
                              isObscure: false),
                        CusTextField(
                            hint: "emel",
                            controller: _emailCon,
                            isObscure: false),
                        CusTextField(
                            hint: "kata laluan",
                            controller: _passCon,
                            isObscure: true),
                        if (isLogin)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                                onPressed: () => Navigator.of(context).push(
                                    SlideRoute(page: const ResetPassPage())),
                                child: const Text(
                                  "Terlupa kata laluan?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                          ),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  isLogin
                                      ? AuthService.login(context,
                                          _emailCon.text, _passCon.text)
                                      : AuthService.createUser(
                                         
                                          context,
                                          _usernameCon.text,
                                          _emailCon.text,
                                          _passCon.text
                                          );
                                }
                              },
                              child: Text(
                                isLogin ? "LOG MASUK" : "DAFTAR",
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              )),
                        ),
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Divider(thickness: 2)),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("ATAU",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 2,
                                ),
                              )
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoginBox(
                                  logo: "assets/images/logo_apple.png",
                                  login: () => AuthService.loginApple(context)),
                              LoginBox(
                                  logo: "assets/images/logo_google.png",
                                  login: () => AuthService.loginGoogle(context))
                            ])
                      ]),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin
                        ? "Anda belum mendaftar masuk? "
                        : "Anda mempunyai akaun? ",
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _formKey.currentState?.reset();
                          _usernameCon.clear;
                          _emailCon.clear;
                          _passCon.clear;
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin ? "Daftar Masuk" : "Log Masuk",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
