import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stargram/pages/login_page.dart';
import 'package:stargram/pages/main_page.dart';
import 'package:stargram/pages/register_page.dart';

void main() {
  runApp(StargramApp());
}

class StargramApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Stargram",
      initialRoute: "/login",
      routes: {
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/home": (context) => MainPage()
      },
    );
  }
}
