import 'package:flutter/material.dart';
import 'pentagon_radar_chart.dart';

/// 综合评分卡片组件
/// 
/// 用于展示评分信息和五边形雷达图，支持自定义颜色和文字样式
class ScoreRatingCard extends StatelessWidget {
  /// 评分数值
  final int score;
  
  /// 击败的百分比
  final double percentage;
  
  /// 雷达图数据
  final Map<String, double> radarData;
  
  /// 卡片标题
  final String title;
  
  /// 百分比描述文字
  final String percentageText;
  
  /// 雷达图标题
  final String radarTitle;
  
  /// 主题色（用于分数显示）
  final Color primaryColor;
  
  /// 卡片背景色
  final Color backgroundColor;
  
  /// 文字颜色
  final Color textColor;
  
  /// 次要文字颜色
  final Color secondaryTextColor;
  
  /// 雷达图填充颜色
  final Color? radarFillColor;
  
  /// 雷达图网格颜色
  final Color? radarGridColor;

  const ScoreRatingCard({
    super.key,
    required this.score,
    required this.percentage,
    required this.radarData,
    this.title = '综合总评分',
    this.percentageText = '击败了{percentage}%的线索',
    this.radarTitle = '基础价值',
    this.primaryColor = const Color(0xFF00BCD4),
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.secondaryTextColor = Colors.grey,
    this.radarFillColor,
    this.radarGridColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
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
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
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
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  height: 0.9,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '/100',
                  style: TextStyle(
                    fontSize: 20,
                    color: secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 百分比文字
          Text(
            percentageText.replaceAll('{percentage}', percentage.toStringAsFixed(2)),
            style: TextStyle(
              fontSize: 14,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 32),
          
          // 基础价值标题
          Text(
            radarTitle,
            style: TextStyle(
              fontSize: 16,
              color: secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          
          // 雷达图
          SizedBox(
            width: 400,
            height: 400,
            child: PentagonRadarChart(
              data: radarData,
              fillColor: radarFillColor ?? primaryColor.withAlpha(90),
              gridColor: radarGridColor ?? primaryColor.withAlpha(50),
              strokeColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}