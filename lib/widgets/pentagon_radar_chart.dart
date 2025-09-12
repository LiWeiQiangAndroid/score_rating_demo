import 'package:flutter/material.dart';
import 'dart:math';

/// 五边形雷达图组件
///
/// 用于展示多维度数据的可视化图表，支持自定义颜色和样式
class PentagonRadarChart extends StatelessWidget {
  /// 雷达图数据，key为维度名称，value为该维度的数值(0-100)
  final Map<String, double> data;

  /// 数据区域填充颜色
  final Color fillColor;

  /// 数据区域边框颜色
  final Color strokeColor;

  /// 网格线颜色
  final Color gridColor;

  /// 标签文字颜色
  final Color labelColor;

  const PentagonRadarChart({
    super.key,
    required this.data,
    this.fillColor = const Color(0xFF4DD0E1),
    this.strokeColor = const Color(0xFF00BCD4),
    this.gridColor = const Color(0xFFE0E0E0),
    this.labelColor = const Color(0xFF757575),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200),
      painter: RadarChartPainter(
        data: data,
        fillColor: fillColor,
        strokeColor: strokeColor,
        gridColor: gridColor,
        labelColor: labelColor,
      ),
    );
  }
}

/// 雷达图绘制器
///
/// 负责实际的雷达图绘制逻辑，包括网格、数据区域和标签的绘制
class RadarChartPainter extends CustomPainter {
  /// 雷达图数据
  final Map<String, double> data;

  /// 数据区域填充颜色
  final Color fillColor;

  /// 数据区域边框颜色
  final Color strokeColor;

  /// 网格线颜色
  final Color gridColor;

  /// 标签文字颜色
  final Color labelColor;

  RadarChartPainter({
    required this.data,
    required this.fillColor,
    required this.strokeColor,
    required this.gridColor,
    required this.labelColor,
  });

  /// 绘制雷达图的主方法
  ///
  /// [canvas] 画布对象
  /// [size] 绘制区域大小
  @override
  void paint(Canvas canvas, Size size) {
    // 计算图表中心点和半径
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 50; // 预留50像素的边距用于标签（增加边距）

    // 按顺序绘制图表的各个部分
    _drawGrid(canvas, center, radius);      // 绘制背景网格
    _drawDataArea(canvas, center, radius);  // 绘制数据区域
    _drawLabels(canvas, center, radius);    // 绘制维度标签
  }

  /// 绘制雷达图网格
  ///
  /// 包括3层五边形网格和从中心到各顶点的射线
  /// [canvas] 画布对象
  /// [center] 图表中心点坐标
  /// [radius] 最外层网格半径
  void _drawGrid(Canvas canvas, Offset center, double radius) {
    // 配置网格线的绘制样式
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 绘制3层同心五边形网格，从内到外
    for (int layer = 1; layer <= 5; layer++) {
      final layerRadius = radius * (layer / 5); // 按比例计算每层半径
      final path = _createPentagonPath(center, layerRadius);
      canvas.drawPath(path, gridPaint);
    }

    // 绘制从中心到各个顶点的射线（5条）
    for (int i = 0; i < 5; i++) {
      // 计算每个顶点的角度，从12点钟方向开始，顺时针分布
      final angle = -pi / 2 + (2 * pi * i / 5);
      final endPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(center, endPoint, gridPaint);
    }
  }

  /// 绘制数据区域
  ///
  /// 根据传入的数据绘制五边形数据区域，包括填充、边框和数据点
  /// [canvas] 画布对象
  /// [center] 图表中心点坐标
  /// [radius] 最大半径
  void _drawDataArea(Canvas canvas, Offset center, double radius) {
    // 配置填充区域的绘制样式（半透明）
    final fillPaint = Paint()
      ..color = fillColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // 配置边框线的绘制样式
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 存储所有数据点的坐标
    final dataPoints = <Offset>[];
    final labels = data.keys.toList();

    // 计算每个维度对应的数据点坐标
    for (int i = 0; i < labels.length; i++) {
      final value = data[labels[i]] ?? 0.0;
      final normalizedValue = value / 100.0; // 将数据归一化到0-1范围，假设最大值是100
      final angle = -pi / 2 + (2 * pi * i / 5); // 计算该维度对应的角度

      // 根据数值大小和角度计算实际坐标点
      final point = Offset(
        center.dx + radius * normalizedValue * cos(angle),
        center.dy + radius * normalizedValue * sin(angle),
      );
      dataPoints.add(point);
    }

    // 绘制数据区域的填充和边框
    if (dataPoints.isNotEmpty) {
      final path = Path();
      path.moveTo(dataPoints[0].dx, dataPoints[0].dy); // 移动到第一个点
      // 依次连接所有数据点
      for (int i = 1; i < dataPoints.length; i++) {
        path.lineTo(dataPoints[i].dx, dataPoints[i].dy);
      }
      path.close(); // 闭合路径形成多边形

      // 先绘制填充，再绘制边框
      canvas.drawPath(path, fillPaint);
      // canvas.drawPath(path, strokePaint);
    }

    // 在每个数据点上绘制小圆点
    final pointPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;

    for (final point in dataPoints) {
      canvas.drawCircle(point, 3, pointPaint); // 半径为3的实心圆
    }
  }

  /// 绘制维度标签
  ///
  /// 在雷达图外围绘制各个维度的文字标签
  /// [canvas] 画布对象
  /// [center] 图表中心点坐标
  /// [radius] 图表半径
  void _drawLabels(Canvas canvas, Offset center, double radius) {
    final labels = data.keys.toList();
    // 创建文本绘制器，用于计算和绘制文字
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // 为每个维度绘制标签
    for (int i = 0; i < labels.length; i++) {
      final angle = -pi / 2 + (2 * pi * i / 5); // 计算标签对应的角度

      // 根据标签位置调整距离，避免文字重叠或距离不当
      double labelDistance;
      if (i == 0) {
        // 顶部标签 - 距离稍近一些
        labelDistance = radius + 20;
      } else if (i == 1 || i == 4) {
        // 右上和左上标签 - 距离适中
        labelDistance = radius + 35;
      } else {
        // 右下和左下标签 - 距离稍远一些
        labelDistance = radius + 20;
      }

      // 计算标签的位置坐标
      final labelPosition = Offset(
        center.dx + labelDistance * cos(angle),
        center.dy + labelDistance * sin(angle),
      );

      // 配置文字样式
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: labelColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );

      textPainter.layout(); // 计算文字的布局信息

      // 调整文本位置，使文字在标签点上居中显示
      final textOffset = Offset(
        labelPosition.dx - textPainter.width / 2,
        labelPosition.dy - textPainter.height / 2,
      );

      // 在画布上绘制文字
      textPainter.paint(canvas, textOffset);
    }
  }

  /// 创建五边形路径
  ///
  /// 根据中心点和半径创建一个正五边形的路径对象
  /// [center] 五边形的中心点坐标
  /// [radius] 五边形的半径（从中心到顶点的距离）
  /// 返回: 描述五边形形状的Path对象
  Path _createPentagonPath(Offset center, double radius) {
    final path = Path();

    // 计算五边形的5个顶点坐标，从12点钟方向开始，顺时针分布
    for (int i = 0; i < 5; i++) {
      final angle = -pi / 2 + (2 * pi * i / 5); // 每个顶点间隔72度（2π/5）
      final point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy); // 移动到第一个点，不绘制线条
      } else {
        path.lineTo(point.dx, point.dy); // 从当前位置绘制直线到新点
      }
    }

    path.close(); // 闭合路径，连接最后一个点和第一个点
    return path;
  }

  /// 重绘判断方法
  ///
  /// 用于优化性能，判断是否需要重新绘制组件
  /// 这里简单返回true，在实际项目中可以根据数据变化来优化
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}