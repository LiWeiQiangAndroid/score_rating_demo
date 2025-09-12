import 'package:flutter/material.dart';
import 'dart:math' as math;

class ComprehensiveEvaluationCard extends StatelessWidget {
  final int score;
  final String subtitle;
  final List<RadarChartData> radarData;

  const ComprehensiveEvaluationCard({
    Key? key,
    required this.score,
    required this.subtitle,
    required this.radarData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          const Text(
            '综合总评分',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          
          // Score section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                score.toString(),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00BCD4),
                ),
              ),
              const Text(
                '/100',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 30),
          
          // Radar chart title
          const Text(
            '基础价值',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          
          // Radar chart
          SizedBox(
            height: 200,
            child: RadarChart(
              data: radarData,
            ),
          ),
        ],
      ),
    );
  }
}

class RadarChartData {
  final String label;
  final double value;

  RadarChartData({
    required this.label,
    required this.value,
  });
}

class RadarChart extends StatelessWidget {
  final List<RadarChartData> data;
  final double maxValue;

  const RadarChart({
    Key? key,
    required this.data,
    this.maxValue = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadarChartPainter(
        data: data,
        maxValue: maxValue,
      ),
      child: Container(),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final List<RadarChartData> data;
  final double maxValue;

  RadarChartPainter({
    required this.data,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width < size.height ? size.width : size.height) / 2 - 40;
    
    // Grid paint
    final gridPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Data paint
    final dataPaint = Paint()
      ..color = const Color(0xFF00BCD4).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final dataStrokePaint = Paint()
      ..color = const Color(0xFF00BCD4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw grid (pentagon)
    for (int i = 0; i < 3; i++) {
      final currentRadius = radius * (i + 1) / 3;
      _drawPentagon(canvas, center, currentRadius, gridPaint);
    }

    // Draw axes
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * 3.14159 / 5) - 3.14159 / 2;
      final endPoint = Offset(
        center.dx + radius * 1.2 * math.cos(angle),
        center.dy + radius * 1.2 * math.sin(angle),
      );
      canvas.drawLine(center, endPoint, gridPaint);
    }

    // Draw data polygon
    final dataPoints = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final angle = (i * 2 * 3.14159 / 5) - 3.14159 / 2;
      final value = data[i].value / maxValue;
      final point = Offset(
        center.dx + radius * value * math.cos(angle),
        center.dy + radius * value * math.sin(angle),
      );
      dataPoints.add(point);
    }

    // Fill data area
    final path = Path();
    if (dataPoints.isNotEmpty) {
      path.moveTo(dataPoints[0].dx, dataPoints[0].dy);
      for (int i = 1; i < dataPoints.length; i++) {
        path.lineTo(dataPoints[i].dx, dataPoints[i].dy);
      }
      path.close();
    }
    canvas.drawPath(path, dataPaint);
    canvas.drawPath(path, dataStrokePaint);

    // Draw data points
    for (final point in dataPoints) {
      canvas.drawCircle(point, 4, Paint()..color = const Color(0xFF00BCD4));
    }

    // Draw labels
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 0; i < data.length; i++) {
      final angle = (i * 2 * 3.14159 / 5) - 3.14159 / 2;
      final labelPoint = Offset(
        center.dx + radius * 1.3 * math.cos(angle),
        center.dy + radius * 1.3 * math.sin(angle),
      );
      
      textPainter.text = TextSpan(
        text: data[i].label,
        style: const TextStyle(
          color: Color(0xFF666666),
          fontSize: 12,
        ),
      );
      textPainter.layout();
      
      final offset = Offset(
        labelPoint.dx - textPainter.width / 2,
        labelPoint.dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, offset);
    }
  }

  void _drawPentagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * 3.14159 / 5) - 3.14159 / 2;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}