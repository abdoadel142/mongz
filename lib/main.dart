import 'package:flutter/material.dart';
import 'package:mongz/Views/Login_Screen.dart';
import 'package:mongz/Views/first_page.dart';
import 'package:mongz/Views/map_screen.dart';
import 'package:mongz/Views/test.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Mongz",
        theme: ThemeData(
            primaryColor: Color(0xFFFF9600), accentColor: Color(0xFFFF9600)),
        debugShowCheckedModeBanner: false,
        initialRoute: LoginScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          Home.id: (context) => Home(),
          map_screen.id: (context) => map_screen(),
          firstPage.id: (context) => firstPage()
        });
  }
}
