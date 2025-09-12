import 'package:flutter/material.dart';
import 'pentagon_radar_chart.dart';

class ScoreRatingCard extends StatelessWidget {
  final int score;
  final double percentage;
  final Map<String, double> radarData;

  const ScoreRatingCard({
    super.key,
    required this.score,
    required this.percentage,
    required this.radarData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题
          const Text(
            '综合总评分',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          
          // 分数显示
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score.toString(),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00BCD4), // 青蓝色
                  height: 0.9,
                ),
              ),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  '/100',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 百分比文字
          Text(
            '击败了${percentage.toStringAsFixed(2)}%的线索',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          
          // 基础价值标题
          const Text(
            '基础价值',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          
          // 雷达图
          SizedBox(
            width: 300,
            height: 300,
            child: PentagonRadarChart(
              gridColor: const Color(0xFF00B0C7).withAlpha(50),
              data: radarData,
            ),
          ),
        ],
      ),
    );
  }
}