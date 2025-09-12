import 'package:flutter/material.dart';
import 'dart:math';

class PentagonRadarChart extends StatelessWidget {
  final Map<String, double> data;
  final Color fillColor;
  final Color strokeColor;
  final Color gridColor;
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

class RadarChartPainter extends CustomPainter {
  final Map<String, double> data;
  final Color fillColor;
  final Color strokeColor;
  final Color gridColor;
  final Color labelColor;

  RadarChartPainter({
    required this.data,
    required this.fillColor,
    required this.strokeColor,
    required this.gridColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 30;
    
    // 绘制网格线
    _drawGrid(canvas, center, radius);
    
    // 绘制数据区域
    _drawDataArea(canvas, center, radius);
    
    // 绘制标签
    _drawLabels(canvas, center, radius);
  }

  void _drawGrid(Canvas canvas, Offset center, double radius) {
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 绘制五边形网格（3层）
    for (int layer = 1; layer <= 3; layer++) {
      final layerRadius = radius * (layer / 3);
      final path = _createPentagonPath(center, layerRadius);
      canvas.drawPath(path, gridPaint);
    }

    // 绘制从中心到各个顶点的线
    for (int i = 0; i < 5; i++) {
      final angle = -pi / 2 + (2 * pi * i / 5);
      final endPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(center, endPoint, gridPaint);
    }
  }

  void _drawDataArea(Canvas canvas, Offset center, double radius) {
    final fillPaint = Paint()
      ..color = fillColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final dataPoints = <Offset>[];
    final labels = data.keys.toList();
    
    for (int i = 0; i < labels.length; i++) {
      final value = data[labels[i]] ?? 0.0;
      final normalizedValue = value / 100.0; // 假设最大值是100
      final angle = -pi / 2 + (2 * pi * i / 5);
      
      final point = Offset(
        center.dx + radius * normalizedValue * cos(angle),
        center.dy + radius * normalizedValue * sin(angle),
      );
      dataPoints.add(point);
    }

    // 绘制填充区域
    if (dataPoints.isNotEmpty) {
      final path = Path();
      path.moveTo(dataPoints[0].dx, dataPoints[0].dy);
      for (int i = 1; i < dataPoints.length; i++) {
        path.lineTo(dataPoints[i].dx, dataPoints[i].dy);
      }
      path.close();
      
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    }

    // 绘制数据点
    final pointPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;
    
    for (final point in dataPoints) {
      canvas.drawCircle(point, 3, pointPaint);
    }
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    final labels = data.keys.toList();
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < labels.length; i++) {
      final angle = -pi / 2 + (2 * pi * i / 5);
      final labelRadius = radius + 20;
      
      final labelPosition = Offset(
        center.dx + labelRadius * cos(angle),
        center.dy + labelRadius * sin(angle),
      );

      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: labelColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );
      
      textPainter.layout();
      
      // 调整文本位置，使其居中
      final textOffset = Offset(
        labelPosition.dx - textPainter.width / 2,
        labelPosition.dy - textPainter.height / 2,
      );
      
      textPainter.paint(canvas, textOffset);
    }
  }

  Path _createPentagonPath(Offset center, double radius) {
    final path = Path();
    
    for (int i = 0; i < 5; i++) {
      final angle = -pi / 2 + (2 * pi * i / 5);
      final point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}