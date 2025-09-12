import 'package:flutter/material.dart';
import 'pages/demo_page.dart';

void main() {
  runApp(const ScoreRatingApp());
}

class ScoreRatingApp extends StatelessWidget {
  const ScoreRatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '综合评分Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BCD4),
        ),
        useMaterial3: true,
        fontFamily: 'PingFang SC',
      ),
      home: const DemoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
