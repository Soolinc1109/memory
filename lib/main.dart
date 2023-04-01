import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memorys/provider/user_provider.dart';
import 'package:memorys/view/account/account_page.dart';
import 'package:memorys/view/bottomnavigationbar/screen.dart';
import 'package:memorys/view/main_page.dart';
import 'package:memorys/view/startup/login_page.dart';
import 'package:memorys/view/startup/login_state.dart';
import 'package:memorys/view/time_line/time_line_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginState()),

        StreamProvider<User?>(
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),

        // UserProviderを追加
        ChangeNotifierProvider(create: (context) => UserProvider()),
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
    final firebaseUser = Provider.of<User?>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: firebaseUser != null ? MainPage() : LoginPage(),
    );
  }
}
