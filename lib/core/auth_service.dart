import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jawify/features/frame/presentation/frame_layer.dart';
import 'package:jawify/features/frame/presentation/proficient_page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static final auth = FirebaseAuth.instance;

  static loginApple(BuildContext context) async {
    context.loaderOverlay.show();
    try {
      final cred = await SignInWithApple.getAppleIDCredential(
          scopes: [AppleIDAuthorizationScopes.email]);

      if (cred.identityToken == null) {
        showMsg(context, "Log masuk apple gagal");
        return;
      }

      final oAuth = OAuthProvider('apple.com').credential(
          idToken: cred.identityToken, accessToken: cred.authorizationCode);

      await auth.signInWithCredential(oAuth);
      successLogin(context, cred.email!);
    } catch (e) {
      showMsg(context, e.toString());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.loaderOverlay.hide();
    });
  }

  static loginGoogle(BuildContext context) async {
    context.loaderOverlay.show();
    try {
      final googleUser =
          await GoogleSignIn(scopes: ['email', 'profile']).signIn();
      context.loaderOverlay.hide();
      final googleAuth = await googleUser?.authentication;

      if (googleAuth?.idToken == null || googleAuth?.accessToken == null) {
        showMsg(context, "Log masuk google gagal");
        return;
      }

      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      await auth.signInWithCredential(cred);
      successLogin(context, googleUser!.email);
    } catch (e) {
      showMsg(context, e.toString());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.loaderOverlay.hide();
    });
  }

  static createUser(BuildContext context, String username, String email,
      String password) async {
    context.loaderOverlay.show();
    try {
      final ucd = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await ucd.user?.updateDisplayName(username);
      await auth.currentUser?.sendEmailVerification();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProficientPage(
                  username: username, email: email, password: password)));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showMsg(context,
            "kata laluan terlalu lemah (6 digit dan perlu ada nombor)");
      } else if (e.code == 'email-already-in-use') {
        showMsg(context, "emel sudah digunakan");
      } else {
        showMsg(context, e.code.toString());
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.loaderOverlay.hide();
    });
  }

  static login(BuildContext context, String email, String password) async {
    context.loaderOverlay.show();
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      successLogin(context, email);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        showMsg(context, "emel atau kata laluan salah");
      } else {
        showMsg(context, e.code.toString());
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.loaderOverlay.hide();
    });
  }

  static resetPassword(BuildContext context, String email) async {
    context.loaderOverlay.show();
    try {
      await auth.sendPasswordResetEmail(email: email);
      showMsg(context, "Password reset email has been sent");
    } on FirebaseAuthException catch (e) {
      showMsg(context, e.code.toString());
    }
    context.loaderOverlay.hide();
  }

  static showMsg(context, String mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        content: Text(mess)));
  }

  static successLogin(context, String email) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const FrameLayer()));
  }
}
