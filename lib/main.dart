import 'package:flutter/material.dart';
import 'package:score_rating_demo/pages/ComprehensiveScoreCardPage.dart';
import 'pages/demo_page.dart';

void main() {
  runApp(const ScoreRatingApp());
}

class ScoreRatingApp extends StatelessWidget {
  const ScoreRatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '五维雷达图Demo',
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
