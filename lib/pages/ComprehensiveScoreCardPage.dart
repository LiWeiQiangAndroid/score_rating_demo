import 'package:flutter/material.dart';
import 'package:score_rating_demo/widgets/ComprehensiveScoreCard.dart';

/// 综合评分演示页面
/// 
/// 展示ComprehensiveScoreCard组件的各种使用方式和样式配置。
/// 该页面包含多个不同样式的评分卡片示例，以及组件特点说明。
/// 
/// 功能特点:
/// - 展示默认样式的评分卡片
/// - 演示自定义主题色的效果
/// - 提供不同数据的多个示例
/// - 包含组件特点和使用说明
class ComprehensiveScoreCardPage extends StatelessWidget {
  const ComprehensiveScoreCardPage({Key? key}) : super(key: key);

  /// 构建页面UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // 淡灰色背景，营造层次感
      appBar: AppBar(
        title: const Text(
          '五维雷达图组件示例',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600, // 半粗体
          ),
        ),
        backgroundColor: Colors.white, // 白色AppBar
        foregroundColor: const Color(0xFF333333), // 深灰色文字
        elevation: 0, // 无阴影，现代化设计
        centerTitle: true, // 标题居中
      ),
      body: SingleChildScrollView( // 可滚动布局
        padding: const EdgeInsets.all(20), // 整体内边距20px
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
          children: [
            // 第一个示例区域标题
            const Text(
              '默认样式',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600, // 半粗体
                color: Color(0xFF333333), // 深灰色
              ),
            ),
            const SizedBox(height: 16), // 标题与内容间距
            
            // 默认样式的评分卡片
            // 使用所有默认参数，展示组件的基础效果
            const ComprehensiveScoreCard(width: 500),
            
            const SizedBox(height: 32), // 示例间距
            
            // 第二个示例区域标题
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
            // 展示绿色主题和不同的分数数据
            const ComprehensiveScoreCard(
              totalScore: 88.0, // 自定义总分
              defeatPercentage: "95.6%", // 自定义击败百分比
              primaryColor: Color(0xFF4CAF50), // 绿色主题
              radarData: {
                // 自定义雷达图数据，展示不同的数值分布
                '基础价值': 85.0,
                '需求质量': 90.0,
                '互动热度': 82.0,
                '关联资源': 88.0,
                '转化潜力': 91.0,
              },
            ),
            
            const SizedBox(height: 32),
            
            // 第三个示例区域标题
            const Text(
              '紫色主题',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            
            // 紫色主题示例
            // 展示紫色主题配色和淡紫色背景的组合效果
            const ComprehensiveScoreCard(
              totalScore: 76.0, // 较低的分数示例
              defeatPercentage: "80.2%",
              primaryColor: Color(0xFF9C27B0), // 紫色主题
              backgroundColor: Color(0xFFFAF9FF), // 淡紫色背景
              radarData: {
                // 相对较低的分数数据，展示不同层次的视觉效果
                '基础价值': 78.0,
                '需求质量': 85.0,
                '互动热度': 70.0,
                '关联资源': 75.0,
                '转化潜力': 72.0,
              },
            ),
            
            const SizedBox(height: 32),
            
            // 组件特点说明区域
            Container(
              padding: const EdgeInsets.all(20), // 内边距20px
              decoration: BoxDecoration(
                color: Colors.white, // 白色背景
                borderRadius: BorderRadius.circular(12), // 圆角12px
                boxShadow: [
                  // 轻微阴影效果，提升层次感
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), // 5%透明度
                    blurRadius: 10, // 模糊半径10px
                    offset: const Offset(0, 2), // 向下偏移2px
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 特点区域标题
                  const Text(
                    '组件特点',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12), // 标题与列表间距
                  
                  // 各个特点项目，使用辅助方法构建
                  _buildFeatureItem('💯', '动画效果', '分数和雷达图都有流畅的进入动画'),
                  _buildFeatureItem('🎨', '主题定制', '支持自定义主色调和背景色'),
                  _buildFeatureItem('📊', '五维雷达图', '清晰展示各维度评分情况'),
                  _buildFeatureItem('📱', '响应式设计', '适配不同屏幕尺寸'),
                  _buildFeatureItem('🔧', '易于集成', '简单的API，易于在项目中使用'),
                ],
              ),
            ),
            
            const SizedBox(height: 20), // 底部间距
          ],
        ),
      ),
    );
  }

  /// 构建特点说明项目
  /// 
  /// 用于构建组件特点列表中的单个项目，包含图标、标题和描述
  /// [icon] 表示该特点的emoji图标
  /// [title] 特点的标题
  /// [description] 特点的详细描述
  /// 
  /// 返回一个包含图标和文字信息的Widget
  Widget _buildFeatureItem(String icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // 上下内边距8px
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 顶部对齐
        children: [
          // emoji图标
          Text(
            icon,
            style: const TextStyle(fontSize: 16), // 16px字体大小
          ),
          const SizedBox(width: 12), // 图标与文字间距
          
          // 文字内容区域
          Expanded( // 占用剩余空间
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
              children: [
                // 特点标题
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600, // 半粗体，突出标题
                    color: Color(0xFF333333), // 深灰色
                  ),
                ),
                const SizedBox(height: 2), // 标题与描述间的小间距
                
                // 特点描述
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13, // 相对较小的字体
                    color: Color(0xFF666666), // 中灰色，降低视觉权重
                    height: 1.4, // 行高1.4，提升可读性
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