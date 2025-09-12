import 'package:flutter/material.dart';
import 'package:score_rating_demo/widgets/ComprehensiveScoreCard.dart';

/// 综合评分演示页面
class ScoreDemoPage extends StatelessWidget {
  const ScoreDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          '综合评分组件示例',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF333333),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '默认样式',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            
            // 默认样式的评分卡片
            const ComprehensiveScoreCard(),
            
            const SizedBox(height: 32),
            
            const Text(
              '自定义样式',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            
            // 自定义样式的评分卡片
            ComprehensiveScoreCard(
              totalScore: 88.0,
              defeatPercentage: "95.6%",
              primaryColor: const Color(0xFF4CAF50), // 绿色主题
              radarData: const {
                '基础价值': 85.0,
                '需求质量': 90.0,
                '互动热度': 82.0,
                '关联资源': 88.0,
                '转化潜力': 91.0,
              },
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              '紫色主题',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            
            // 紫色主题
            ComprehensiveScoreCard(
              totalScore: 76.0,
              defeatPercentage: "80.2%",
              primaryColor: const Color(0xFF9C27B0), // 紫色主题
              backgroundColor: const Color(0xFFFAF9FF),
              radarData: const {
                '基础价值': 78.0,
                '需求质量': 85.0,
                '互动热度': 70.0,
                '关联资源': 75.0,
                '转化潜力': 72.0,
              },
            ),
            
            const SizedBox(height: 32),
            
            // 使用说明
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '组件特点',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem('💯', '动画效果', '分数和雷达图都有流畅的进入动画'),
                  _buildFeatureItem('🎨', '主题定制', '支持自定义主色调和背景色'),
                  _buildFeatureItem('📊', '五维雷达图', '清晰展示各维度评分情况'),
                  _buildFeatureItem('📱', '响应式设计', '适配不同屏幕尺寸'),
                  _buildFeatureItem('🔧', '易于集成', '简单的API，易于在项目中使用'),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}