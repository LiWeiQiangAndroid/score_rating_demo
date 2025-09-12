import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 五维雷达图卡片组件
/// 
/// 一个功能完整的评分展示卡片，包含动画分数显示和五维雷达图可视化。
/// 该组件提供流畅的动画效果和高度的自定义能力，适用于数据分析和评分展示场景。
/// 
/// 主要特性:
/// - 🎯 动画分数递增效果，从0增长到目标分数
/// - 📊 五维雷达图动态展示，支持任意维度数据
/// - 🎨 完全自定义的颜色主题和尺寸控制
/// - ⚡ 高性能的Canvas绘制和动画优化
/// - 📱 响应式设计，支持不同屏幕尺寸
/// 
/// 使用场景:
/// - 用户评分展示（综合能力、学习成绩等）
/// - 产品评估报告（功能、性能、体验等维度）
/// - 数据分析仪表板（多维度指标可视化）
/// - 企业绩效展示（销售、服务、创新等方面）
/// 
/// 示例用法:
/// ```dart
/// ComprehensiveScoreCard(
///   totalScore: 95.0,
///   defeatPercentage: "99.99%",
///   primaryColor: Colors.blue,
///   radarData: {
///     '基础价值': 90.0,
///     '需求质量': 92.0,
///     '互动热度': 88.0,
///     '关联资源': 85.0,
///     '转化潜力': 87.0,
///   },
/// )
/// ```
class ComprehensiveScoreCard extends StatefulWidget {
  /// 总分数 (0.0-100.0)
  /// 
  /// 显示在卡片中央的主要评分，支持小数精度。
  /// 建议使用0-100的标准百分制分数以保持一致性。
  final double totalScore;

  /// 击败百分比字符串
  /// 
  /// 显示相对排名的文字描述，例如 "99.99%" 或 "95.6%"。
  /// 此参数为字符串类型，可以包含百分号和小数点。
  final String defeatPercentage;

  /// 雷达图数据映射
  /// 
  /// 包含各个评价维度及其对应分数的键值对。
  /// - Key: 维度名称（字符串），将显示为雷达图标签
  /// - Value: 该维度的分数（0.0-100.0），用于绘制雷达图形状
  /// 
  /// 注意：
  /// - 建议提供3-8个维度，5个维度视觉效果最佳
  /// - 所有分数建议使用相同的量纲（如都是0-100分）
  /// - 维度名称不宜过长，建议2-4个字符
  final Map<String, double> radarData;

  /// 主题色
  /// 
  /// 用于分数文字、雷达图数据区域和数据点的主要颜色。
  /// 这个颜色将决定整个卡片的色彩基调。
  final Color primaryColor;

  /// 卡片背景色
  /// 
  /// 整个卡片容器的背景颜色，默认为白色。
  /// 建议与应用整体色彩风格保持一致。
  final Color backgroundColor;

  /// 卡片宽度
  /// 
  /// 可选参数，指定卡片的固定宽度。
  /// 如果不设置，卡片将根据内容和父容器自适应宽度。
  final double? width;

  /// 卡片高度
  /// 
  /// 可选参数，指定卡片的固定高度。
  /// 如果不设置，卡片将根据内容自适应高度。
  final double? height;

  /// 创建五维雷达图卡片
  /// 
  /// 所有参数都有合理的默认值，可以快速创建一个功能完整的评分卡片。
  /// 
  /// 参数说明：
  /// - [totalScore] 必须在0.0-100.0范围内
  /// - [radarData] 建议包含3-8个维度数据
  /// - [primaryColor] 将影响整体视觉风格
  /// - [width] 和 [height] 可用于固定尺寸场景
  const ComprehensiveScoreCard({
    Key? key,
    this.totalScore = 95.0,
    this.defeatPercentage = "99.99%",
    this.radarData = const {
      '基础价值': 90.0,
      '需求质量': 92.0,
      '互动热度': 88.0,
      '关联资源': 85.0,
      '转化潜力': 87.0,
    },
    this.primaryColor = const Color(0xFF00BCD4),
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<ComprehensiveScoreCard> createState() => _ComprehensiveScoreCardState();
}

/// 五维雷达图卡片的状态管理类
/// 
/// 负责管理复杂的动画状态和生命周期，实现流畅的用户体验。
/// 使用 TickerProviderStateMixin 提供高精度的动画时钟源。
class _ComprehensiveScoreCardState extends State<ComprehensiveScoreCard>
    with TickerProviderStateMixin {
  /// 主动画控制器
  /// 
  /// 统一管理所有动画的时间轴，持续时长为2000毫秒。
  /// 通过这个控制器可以暂停、重启或反向播放所有动画。
  late AnimationController _animationController;
  
  /// 分数递增动画
  /// 
  /// 控制分数从0增长到目标值的动画效果。
  /// - 时间段：动画开始(0%) 到 60% 的时间段
  /// - 动画曲线：easeOutCubic（快速开始，缓慢结束）
  /// - 用途：营造数据统计的真实感和视觉冲击力
  late Animation<double> _scoreAnimation;
  
  /// 雷达图渐现动画
  /// 
  /// 控制雷达图从透明到不透明，从小到大的显示效果。
  /// - 时间段：30% 到 动画结束(100%) 的时间段
  /// - 动画曲线：easeOutCubic（与分数动画保持一致）
  /// - 用途：在分数动画进行时优雅地展示雷达图
  late Animation<double> _radarAnimation;

  @override
  void initState() {
    super.initState();
    
    // 初始化动画控制器
    // 使用2秒时长确保动画既不会太快（影响观感）也不会太慢（影响体验）
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this, // 使用当前State作为Ticker提供者
    );

    // 配置分数动画
    // 使用Interval确保分数动画在前60%时间完成，为雷达图留出展示时间
    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // 配置雷达图动画
    // 从30%时间点开始，与分数动画形成优雅的交叉过渡
    _radarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // 启动动画序列
    // 组件加载后立即开始播放动画，无需用户交互
    _animationController.forward();
  }

  @override
  void dispose() {
    // 清理资源，防止内存泄漏
    // 这是Flutter开发的重要最佳实践
    _animationController.dispose();
    super.dispose();
  }

  /// 构建卡片主体UI
  /// 
  /// 采用Container + Column的经典布局结构，确保内容垂直居中排列
  @override
  Widget build(BuildContext context) {
    return Container(
      // 尺寸控制
      width: widget.width,   // 可选的固定宽度
      height: widget.height, // 可选的固定高度
      padding: const EdgeInsets.all(24), // 内边距确保内容不贴边
      
      // 视觉装饰
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(20), // 圆角20px，更加圆润友好
        boxShadow: [
          // 精心调校的阴影效果，提升卡片的立体感和层次感
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // 8%透明度，确保阴影不会过重
            blurRadius: 20,    // 20px模糊半径，产生柔和的扩散效果
            offset: const Offset(0, 8), // 向下偏移8px，模拟自然光照
            spreadRadius: 0,   // 无扩散，保持阴影边缘清晰
          ),
        ],
      ),
      
      // 内容布局
      child: Column(
        mainAxisSize: MainAxisSize.min, // 高度自适应内容，避免不必要的空间占用
        children: [
          // 卡片标题 - 使用固定文字确保一致性
          const Text(
            '综合总评分',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,     // 半粗体，既突出又不过重
              color: Color(0xFF333333),        // 深灰色，确保良好的对比度
              letterSpacing: 0.5,             // 0.5px字间距，提升可读性
            ),
          ),

          const SizedBox(height: 32), // 标题与分数区域的间距

          // 动画分数显示区域
          _buildScoreSection(),

          const SizedBox(height: 40), // 分数与雷达图的间距

          // 动画雷达图区域
          _buildRadarChart(),
        ],
      ),
    );
  }

  /// 构建分数显示区域
  /// 
  /// 使用AnimatedBuilder实现响应式动画UI，分数会从0递增到目标值
  Widget _buildScoreSection() {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        // 根据动画进度计算当前显示的分数
        final animatedScore = widget.totalScore * _scoreAnimation.value;
        
        return Column(
          children: [
            // 分数显示 - 使用RichText实现不同样式的文字组合
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  // 主分数 - 大字体，高视觉权重
                  TextSpan(
                    text: animatedScore.toInt().toString(), // 取整显示，避免小数点
                    style: TextStyle(
                      fontSize: 72,                    // 超大字体，营造强烈视觉冲击
                      fontWeight: FontWeight.bold,     // 粗体加强重要性
                      color: widget.primaryColor,      // 使用主题色突出显示
                      height: 1.0,                     // 行高1.0，紧凑排列
                      letterSpacing: -2.0,             // 负字间距，让数字更紧凑
                    ),
                  ),
                  // 分数单位 - 小字体，低视觉权重
                  const TextSpan(
                    text: '/100',
                    style: TextStyle(
                      fontSize: 28,                    // 相对较小，不抢夺主分数的注意力
                      color: Color(0xFF999999),        // 浅灰色，降低视觉权重
                      fontWeight: FontWeight.w500,     // 中等粗细
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16), // 分数与描述间距

            // 击败百分比描述
            Text(
              '击败了${widget.defeatPercentage}的线索',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),     // 中灰色，适合辅助信息
                fontWeight: FontWeight.w400,  // 正常字重
              ),
            ),
          ],
        );
      },
    );
  }

  /// 构建雷达图显示区域
  /// 
  /// 使用CustomPaint进行高性能的图形绘制，支持复杂的动画效果
  Widget _buildRadarChart() {
    return SizedBox(
      height: 300, // 固定高度确保布局稳定
      width: 300,  // 固定宽度，保持正方形比例
      child: AnimatedBuilder(
        animation: _radarAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: ComprehensiveRadarPainter(
              data: widget.radarData,
              animationValue: _radarAnimation.value, // 传递动画进度给绘制器
              primaryColor: widget.primaryColor,
            ),
            size: const Size(300, 300), // 明确指定绘制区域大小
          );
        },
      ),
    );
  }
}

/// 雷达图绘制器
class ComprehensiveRadarPainter extends CustomPainter {
  final Map<String, double> data;
  final double animationValue;
  final Color primaryColor;

  ComprehensiveRadarPainter({
    required this.data,
    required this.animationValue,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 40;
    final sides = data.length;

    // 绘制背景网格
    _drawGrid(canvas, center, radius, sides);

    // 绘制数据区域
    if (animationValue > 0) {
      _drawDataArea(canvas, center, radius, sides);
    }

    // 绘制标签
    _drawLabels(canvas, center, radius, sides);
  }

  void _drawGrid(Canvas canvas, Offset center, double radius, int sides) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE8F5E8).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 绘制同心多边形网格
    for (int level = 1; level <= 5; level++) {
      final currentRadius = radius * level / 5;
      final path = Path();

      for (int i = 0; i < sides; i++) {
        final angle = -math.pi / 2 + (2 * math.pi * i / sides);
        final point = Offset(
          center.dx + currentRadius * math.cos(angle),
          center.dy + currentRadius * math.sin(angle),
        );

        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // 绘制从中心到各顶点的线
    final linePaint = Paint()
      ..color = const Color(0xFFE8F5E8).withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < sides; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / sides);
      final endPoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, endPoint, linePaint);
    }
  }

  void _drawDataArea(Canvas canvas, Offset center, double radius, int sides) {
    final path = Path();
    final dataPoints = <Offset>[];
    final dataList = data.values.toList();

    // 计算数据点位置
    for (int i = 0; i < sides; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / sides);
      final value = (dataList[i] / 100.0) * animationValue;
      final pointRadius = radius * value;

      final point = Offset(
        center.dx + pointRadius * math.cos(angle),
        center.dy + pointRadius * math.sin(angle),
      );
      dataPoints.add(point);

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    // 绘制填充区域
    final fillPaint = Paint()
      ..color = primaryColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 绘制边框
    final strokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    // canvas.drawPath(path, strokePaint);

    // 绘制数据点
    final pointPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    for (final point in dataPoints) {
      canvas.drawCircle(point, 3, pointPaint);
      ///圆点边框
      // canvas.drawCircle(
      //   point,
      //   3,
      //   Paint()
      //     ..color = Colors.white
      //     ..style = PaintingStyle.stroke
      //     ..strokeWidth = 2,
      // );
    }
  }

  void _drawLabels(Canvas canvas, Offset center, double radius, int sides) {
    final labelPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final labels = data.keys.toList();

    for (int i = 0; i < sides; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / sides);
      // final labelRadius = radius + 35;
      double labelRadius;
      if (i == 0) {
        // 顶部标签 - 距离稍近一些
        labelRadius = radius + 20;
      } else if (i == 1 || i == 4) {
        // 右上和左上标签 - 距离适中
        labelRadius = radius + 35;
      } else {
        // 右下和左下标签 - 距离
        labelRadius = radius + 20;
      }

      final labelCenter = Offset(
        center.dx + labelRadius * math.cos(angle),
        center.dy + labelRadius * math.sin(angle),
      );

      labelPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          color: Color(0xFF666666),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      );

      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(
          labelCenter.dx - labelPainter.width / 2,
          labelCenter.dy - labelPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}