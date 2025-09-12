import 'package:flutter/material.dart';
import 'pentagon_radar_chart.dart';

/// 综合评分卡片组件
/// 
/// 用于展示评分信息和五边形雷达图，支持自定义颜色和文字样式。
/// 该组件包含分数显示、百分比对比文字以及多维度数据的雷达图可视化。
/// 
/// 特性:
/// - 分数动画从0递增到目标分数
/// - 雷达图数据区域渐进显示动画
/// - 支持自定义颜色和文字样式
/// - 响应式布局设计
/// 
/// 使用示例:
/// ```dart
/// ScoreRatingCard(
///   score: 95,
///   percentage: 99.99,
///   radarData: {
///     '基础价值': 92,
///     '需求质量': 85,
///     '互动热度': 90,
///     '关联资源': 80,
///     '转化潜力': 88,
///   },
/// )
/// ```
class ScoreRatingCard extends StatefulWidget {
  /// 评分数值 (0-100)
  final int score;
  
  /// 击败的百分比 (0.0-100.0)
  final double percentage;
  
  /// 雷达图数据
  /// 
  /// Key: 维度名称, Value: 该维度的数值 (0-100)
  /// 建议传入5个维度的数据以形成完整的五边形雷达图
  final Map<String, double> radarData;
  
  /// 卡片主标题
  /// 
  /// 显示在卡片顶部，用于说明此评分卡片的用途
  final String title;
  
  /// 百分比描述文字模板
  /// 
  /// 支持使用 {percentage} 占位符，会自动替换为实际的百分比数值
  /// 例如: '击败了{percentage}%的线索'
  final String percentageText;
  
  /// 雷达图区域标题
  /// 
  /// 显示在雷达图上方，用于说明雷达图展示的内容类型
  final String radarTitle;
  
  /// 主题色
  /// 
  /// 用于分数数字显示、雷达图边框等关键元素的颜色
  final Color primaryColor;
  
  /// 卡片背景色
  final Color backgroundColor;
  
  /// 主要文字颜色
  /// 
  /// 用于标题等重要文字的颜色
  final Color textColor;
  
  /// 次要文字颜色
  /// 
  /// 用于描述文字、单位等辅助文字的颜色
  final Color secondaryTextColor;
  
  /// 雷达图填充颜色
  /// 
  /// 可选参数，如果不设置则使用 primaryColor 的半透明版本
  final Color? radarFillColor;
  
  /// 雷达图网格颜色
  /// 
  /// 可选参数，如果不设置则使用 primaryColor 的淡色版本
  final Color? radarGridColor;

  /// 创建综合评分卡片组件
  /// 
  /// [score] 和 [percentage] 以及 [radarData] 为必需参数
  /// 其他参数均有默认值，可根据需要自定义
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
  State<ScoreRatingCard> createState() => _ScoreRatingCardState();
}

/// 综合评分卡片的状态管理类
/// 
/// 负责管理动画控制器和动画状态
class _ScoreRatingCardState extends State<ScoreRatingCard>
    with TickerProviderStateMixin {
  /// 主动画控制器
  /// 
  /// 控制整体动画的时间线，持续2秒
  late AnimationController _animationController;
  
  /// 分数动画
  /// 
  /// 控制分数从0递增到目标值的动画，占总时长的前60%
  late Animation<double> _scoreAnimation;
  
  /// 雷达图动画
  /// 
  /// 控制雷达图数据区域显示的动画，从总时长30%开始到结束
  late Animation<double> _radarAnimation;

  @override
  void initState() {
    super.initState();
    // 初始化动画控制器，总时长2秒
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // 分数动画：0%-60%时间段，使用缓出三次贝塞尔曲线
    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    
    // 雷达图动画：30%-100%时间段，使用缓出三次贝塞尔曲线
    _radarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    
    // 启动动画
    _animationController.forward();
  }

  @override
  void dispose() {
    // 释放动画控制器资源
    _animationController.dispose();
    super.dispose();
  }

  /// 构建组件UI
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24), // 内边距24px，确保内容不贴边
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(16), // 圆角16px，现代化卡片样式
        boxShadow: [
          // 添加阴影效果，提升卡片的层次感
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // 10%透明度的黑色阴影
            blurRadius: 20, // 模糊半径20px，产生柔和阴影
            offset: const Offset(0, 4), // 向下偏移4px，模拟光源从上方照射
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 列高度自适应内容
        children: [
          // 卡片标题区域
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600, // 半粗体，突出标题重要性
              color: widget.textColor,
            ),
          ),
          const SizedBox(height: 24), // 标题与分数间距
          
          // 分数显示区域（带动画）
          _buildAnimatedScoreSection(),
          
          const SizedBox(height: 16), // 分数与描述文字间距
          
          // 百分比对比文字（带动画）
          _buildAnimatedPercentageText(),
          
          const SizedBox(height: 32), // 描述文字与雷达图标题间距
          
          // 雷达图标题
          Text(
            widget.radarTitle,
            style: TextStyle(
              fontSize: 16,
              color: widget.secondaryTextColor,
              fontWeight: FontWeight.w500, // 中等粗细，区别于主标题
            ),
          ),
          const SizedBox(height: 24), // 雷达图标题与图表间距
          
          // 雷达图展示区域（带动画）
          _buildAnimatedRadarChart(),
        ],
      ),
    );
  }

  /// 构建带动画的分数显示区域
  /// 
  /// 包含动画分数显示效果
  Widget _buildAnimatedScoreSection() {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        // 计算当前动画进度对应的分数值
        final animatedScore = widget.score * _scoreAnimation.value;
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.center, // 水平居中
          crossAxisAlignment: CrossAxisAlignment.end, // 底部对齐，让数字和单位基线一致
          children: [
            // 主要分数数字（带动画）
            Text(
              animatedScore.toInt().toString(), // 取整显示
              style: TextStyle(
                fontSize: 64, // 大号字体，突出分数重要性
                fontWeight: FontWeight.bold, // 粗体加强视觉冲击力
                color: widget.primaryColor, // 使用主题色
                height: 0.9, // 调整行高，使数字更紧凑
              ),
            ),
            const SizedBox(width: 4), // 数字与单位间的小间距
            // 分数单位'/100'
            Padding(
              padding: const EdgeInsets.only(bottom: 8), // 向下偏移8px，与大数字对齐
              child: Text(
                '/100',
                style: TextStyle(
                  fontSize: 20, // 相对较小的字体
                  color: widget.secondaryTextColor, // 使用次要颜色，降低视觉权重
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 构建带动画的百分比文字
  /// 
  /// 百分比文字带有淡入动画效果
  Widget _buildAnimatedPercentageText() {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _scoreAnimation.value, // 透明度随动画变化
          child: Text(
            // 使用字符串替换功能，将占位符替换为实际数值
            widget.percentageText.replaceAll('{percentage}', widget.percentage.toStringAsFixed(2)),
            style: TextStyle(
              fontSize: 14,
              color: widget.secondaryTextColor, // 辅助信息使用次要颜色
            ),
          ),
        );
      },
    );
  }

  /// 构建带动画的雷达图
  /// 
  /// 雷达图带有缩放和数据渐进显示动画
  Widget _buildAnimatedRadarChart() {
    return AnimatedBuilder(
      animation: _radarAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.5 + 0.5 * _radarAnimation.value, // 从0.5倍缩放到1倍
          child: Opacity(
            opacity: _radarAnimation.value, // 透明度渐变
            child: SizedBox(
              width: 400, // 固定宽度400px
              height: 400, // 固定高度400px，保持正方形比例
              child: PentagonRadarChart(
                data: _getAnimatedRadarData(), // 使用动画数据
                // 如果未指定雷达图颜色，则使用主题色的不同透明度版本
                fillColor: widget.radarFillColor ?? widget.primaryColor.withAlpha(90), // 填充色：90透明度
                gridColor: widget.radarGridColor ?? widget.primaryColor.withAlpha(50), // 网格色：50透明度  
                strokeColor: widget.primaryColor, // 边框色：使用原始主题色
                labelTextStyle: TextStyle(
                  color: widget.textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 获取带动画进度的雷达图数据
  /// 
  /// 根据动画进度计算当前应显示的数据值
  Map<String, double> _getAnimatedRadarData() {
    final animatedData = <String, double>{};
    widget.radarData.forEach((key, value) {
      // 数据值随动画进度从0增长到目标值
      animatedData[key] = value * _radarAnimation.value;
    });
    return animatedData;
  }
}