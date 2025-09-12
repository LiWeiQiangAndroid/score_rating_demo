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
              // 第一个评分卡片 - 默认样式
              const ScoreRatingCard(
                score: 95,
                percentage: 99.99,
                radarData: {
                  '基础价值': 92,
                  '需求质量': 85,
                  '互动热度': 90,
                  '关联资源': 80,
                  '转化潜力': 88,
                },
              ),
              const SizedBox(height: 40),

              // 第二个评分卡片 - 自定义标题和颜色
              const ScoreRatingCard(
                score: 76,
                percentage: 85.32,
                title: '客户满意度评分',
                percentageText: '超越了{percentage}%的同类产品',
                radarTitle: '核心指标',
                primaryColor: Color(0xFF4CAF50),
                // 绿色主题
                radarData: {
                  '基础价值': 82,
                  '需求质量': 70,
                  '互动热度': 65,
                  '关联资源': 80,
                  '转化潜力': 75,
                },
              ),
              const SizedBox(height: 40),

              // 第三个评分卡片 - 深色主题
              ScoreRatingCard(
                score: 58,
                percentage: 42.16,
                title: '性能评估报告',
                percentageText: '当前排名超过{percentage}%',
                radarTitle: '关键维度',
                backgroundColor: const Color(0xFF263238),
                // 深色背景
                textColor: Colors.white,
                secondaryTextColor: Colors.white70,
                primaryColor: const Color(0xFFFF9800),
                // 橙色主题
                radarFillColor: const Color(0xFFFF9800).withAlpha(120),
                radarGridColor: const Color(0xFFFF9800).withAlpha(80),
                radarData: const {
                  '基础价值': 65,
                  '需求质量': 50,
                  '互动热度': 45,
                  '关联资源': 60,
                  '转化潜力': 55,
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
