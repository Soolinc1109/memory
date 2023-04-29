import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memorys/provider/account_model.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/view/main_page.dart';
import 'package:memorys/view/startup/login_page.dart';
import 'package:memorys/view/startup/login_state.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 画面向きを縦画面に制限
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginState()),
        ChangeNotifierProvider(create: (context) => AccountModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColors.thirdColor, // primarySwatchからprimaryColorに変更
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // ロード中のインジケーター
          }

          if (snapshot.hasData) {
            return MainPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
