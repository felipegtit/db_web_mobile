import 'package:db_web_mobile/responsive_layout.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';
import 'mobilehomepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color(0xFFF1FAEE),
      debugShowCheckedModeBanner: false,
      home: ResponsiveLayout(mobileBody: MobileHomePage(), webBody: Homepage()),
      theme: ThemeData(primaryColor: const Color(0xFFFA8DADC)),
    );
  }
}
