import 'package:flutter/material.dart';
import 'package:todo/screens/complete.dart';
import 'package:todo/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
      routes: <String, WidgetBuilder>{
        '/complete': (BuildContext context) => const Complete(),
      },
    );
  }
}
