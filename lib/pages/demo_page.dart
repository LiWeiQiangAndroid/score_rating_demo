import 'package:flutter/material.dart';
import '../widgets/score_rating_card.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          '综合评分Demo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF00BCD4),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 第一个评分卡片
              ScoreRatingCard(
                score: 95,
                percentage: 99.99,
                radarData: const {
                  '需求质量': 85,
                  '互动热度': 90,
                  '关联资源': 80,
                  '转化潜力': 88,
                  '基础价值': 92,
                },
              ),
              const SizedBox(height: 40),
              
              // 第二个评分卡片（不同数据）
              ScoreRatingCard(
                score: 76,
                percentage: 85.32,
                radarData: const {
                  '需求质量': 70,
                  '互动热度': 65,
                  '关联资源': 80,
                  '转化潜力': 75,
                  '基础价值': 82,
                },
              ),
              const SizedBox(height: 40),
              
              // 第三个评分卡片（较低分数）
              ScoreRatingCard(
                score: 58,
                percentage: 42.16,
                radarData: const {
                  '需求质量': 50,
                  '互动热度': 45,
                  '关联资源': 60,
                  '转化潜力': 55,
                  '基础价值': 65,
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}