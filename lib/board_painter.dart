import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = const Color(0xFF30343F); // board color

    Rect rect = Rect.fromCenter(center: size.center(const Offset(0, 0)), width: size.width, height: size.height);
    Radius radius = const Radius.circular(10);
    //canvas.drawRect(Rect.fromCenter(center: size.center(const Offset(0, 0)), width: size.width, height: size.height), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}