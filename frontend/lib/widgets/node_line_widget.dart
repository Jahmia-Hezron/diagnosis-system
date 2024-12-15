import 'package:flutter/material.dart';

class NodeLineWidget extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 4.0;

    // Draw line
    final startPoint = Offset(0, size.height / 2);
    final endPoint = Offset(size.width, size.height / 2);
    canvas.drawLine(startPoint, endPoint, linePaint);

    // Node positions and colors
    final nodes = [
      {'position': size.width * 0.1, 'color': Colors.green},
      {'position': size.width * 0.5, 'color': Colors.orange},
      {'position': size.width * 0.9, 'color': Colors.red},
    ];

    final nodePaint = Paint()..style = PaintingStyle.fill;

    // Draw nodes
    for (dynamic node in nodes) {
      nodePaint.color = node['color'];
      canvas.drawCircle(
          Offset(node['position'], size.height / 2), 8.0, nodePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
