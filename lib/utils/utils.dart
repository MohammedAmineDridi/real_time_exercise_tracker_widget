import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class Utils {

  static double calculateAngle(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    final ab = Offset(a.x - b.x, a.y - b.y);
    final cb = Offset(c.x - b.x, c.y - b.y);
    final dot = ab.dx * cb.dx + ab.dy * cb.dy;
    final magAB = sqrt(ab.dx * ab.dx + ab.dy * ab.dy);
    final magCB = sqrt(cb.dx * cb.dx + cb.dy * cb.dy);
    final angleRad = acos(dot / (magAB * magCB));
    return angleRad * 180 / pi;
  }

  static void printf(String message) => debugPrint(message);
}