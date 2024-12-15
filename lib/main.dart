import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jawify/core/theme.dart';
import 'package:jawify/features/auth/presentation/login_page.dart';
import 'package:jawify/features/frame/presentation/frame_layer.dart';
import 'package:jawify/firebase_options.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails error) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(70),
        child: Column(children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.red),
            child: const Icon(Icons.warning, size: 50),
          ),
          const Text(
            "ERROR has occured when the app try to run. Please contact our team immediately\n -Jawify team",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          )
        ]),
      ),
    );
  };

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MobileAds.instance.initialize();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then(
    (value) => runApp(ChangeNotifierProvider(
        create: (context) => ThemeProvider(), child: const Jawify())),
  );
}

class Jawify extends StatelessWidget {
  const Jawify({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return ScreenUtilInit(
      designSize: const Size(412, 732),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GlobalLoaderOverlay(
          overlayWidgetBuilder: (progress) {
            return const Center(
              child: SpinKitFadingCube(color: Colors.amber, size: 50),
            );
          },
          overlayColor: Colors.grey,
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: Provider.of<ThemeProvider>(context).themeData,
              home: user == null ? const LoginPage() : const FrameLayer()),
        );
      }
    );
  }
}
