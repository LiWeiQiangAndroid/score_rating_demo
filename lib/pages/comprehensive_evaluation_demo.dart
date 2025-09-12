import 'package:flutter/material.dart';
import 'package:score_rating_demo/widgets/comprehensive_evaluation_card.dart';

class ComprehensiveEvaluationDemo extends StatelessWidget {
  const ComprehensiveEvaluationDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('综合评分卡片演示'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 第一个示例：高分评价
            ComprehensiveEvaluationCard(
              score: 95,
              subtitle: '击败了99.99%的线索',
              radarData: [
                RadarChartData(label: '需求质量', value: 0.9),
                RadarChartData(label: '互动热度', value: 0.8),
                RadarChartData(label: '关联资源', value: 0.7),
                RadarChartData(label: '转化潜力', value: 0.85),
                RadarChartData(label: '基础价值', value: 0.9),
              ],
            ),
            const SizedBox(height: 24),
            
            // 第二个示例：中等分数
            ComprehensiveEvaluationCard(
              score: 72,
              subtitle: '击败了78.5%的线索',
              radarData: [
                RadarChartData(label: '需求质量', value: 0.6),
                RadarChartData(label: '互动热度', value: 0.75),
                RadarChartData(label: '关联资源', value: 0.8),
                RadarChartData(label: '转化潜力', value: 0.65),
                RadarChartData(label: '基础价值', value: 0.7),
              ],
            ),
            const SizedBox(height: 24),
            
            // 第三个示例：低分评价
            ComprehensiveEvaluationCard(
              score: 45,
              subtitle: '击败了32.1%的线索',
              radarData: [
                RadarChartData(label: '需求质量', value: 0.4),
                RadarChartData(label: '互动热度', value: 0.3),
                RadarChartData(label: '关联资源', value: 0.5),
                RadarChartData(label: '转化潜力', value: 0.35),
                RadarChartData(label: '基础价值', value: 0.45),
              ],
            ),
            const SizedBox(height: 24),
            
            // 使用说明
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '使用说明',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• score: 评分数值 (0-100)\n'
                    '• subtitle: 副标题文本\n'
                    '• radarData: 雷达图数据列表\n'
                    '  - label: 维度标签\n'
                    '  - value: 数值 (0.0-1.0)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '综合评分卡片演示',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'PingFang SC',
      ),
      home: const ComprehensiveEvaluationDemo(),
    );
  }
}