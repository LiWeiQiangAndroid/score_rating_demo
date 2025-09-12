import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 五维雷达图卡片组件
/// 包含总分显示和五维雷达图
class ComprehensiveScoreCard extends StatefulWidget {
  /// 总分数 (0-100)
  final double totalScore;

  /// 击败百分比
  final String defeatPercentage;

  /// 雷达图数据，五个维度的分数
  final Map<String, double> radarData;

  /// 主色调
  final Color primaryColor;

  /// 背景色
  final Color backgroundColor;

  /// 卡片宽度
  final double? width;

  /// 卡片高度
  final double? height;

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

class _ComprehensiveScoreCardState extends State<ComprehensiveScoreCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _radarAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _radarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
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
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 32),

          // 分数显示区域
          _buildScoreSection(),

          const SizedBox(height: 40),

          // 雷达图
          _buildRadarChart(),
        ],
      ),
    );
  }

  Widget _buildScoreSection() {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        final animatedScore = widget.totalScore * _scoreAnimation.value;
        return Column(
          children: [
            // 分数
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: animatedScore.toInt().toString(),
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: widget.primaryColor,
                      height: 1.0,
                      letterSpacing: -2.0,
                    ),
                  ),
                  const TextSpan(
                    text: '/100',
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFF999999),
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 击败描述
            Text(
              '击败了${widget.defeatPercentage}的线索',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRadarChart() {
    return SizedBox(
      height: 300,
      width: 300,
      child: AnimatedBuilder(
        animation: _radarAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: ComprehensiveRadarPainter(
              data: widget.radarData,
              animationValue: _radarAnimation.value,
              primaryColor: widget.primaryColor,
            ),
            size: const Size(300, 300),
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