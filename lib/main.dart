import 'package:flutter/material.dart';

import 'app/pages/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.indigo[800],
        accentColor: Colors.amber,
        accentColorBrightness: Brightness.dark,
      ),
      home: const OnBoardingScreen(),
    );
  }
}
