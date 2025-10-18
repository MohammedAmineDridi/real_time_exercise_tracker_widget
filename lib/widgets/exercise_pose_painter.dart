import 'package:sport_exercise_tracker_widget/utils/consts.dart';
import 'package:sport_exercise_tracker_widget/utils/enums.dart';
import 'package:sport_exercise_tracker_widget/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../models/exercise_models.dart';
import '../services/exercise_repetition_counter_service.dart';

class ExercisePosePainterWidget extends CustomPainter {

  late Paint keypointPaint;
  late Paint linePaint;

  final List<Pose> poses;
  final CameraDirection cameraDirection;
  final Size widgetSize;
  final Size imageSize;
  final Exercise exercise;
  final ExerciseRepetitionCounterService exerciseRepetitionCounterService;
  final bool startExerciseRepsCounting;
  final bool resetExerciseRepsCounting;
  final bool showKeypointCircles;
  final bool showKeypointLines;
  final bool showAnglesText;
  final KeyPointsLineStyle keyPointsLineStyle;
  final KeyPointsCircleStyle keyPointsCircleStyle;
  final TextStyle anglesTextStyle;
  /// callback to notify repetition count changes
  final void Function(int reps)? onRepetitionCount;

  ExercisePosePainterWidget({
    required this.poses,
    required this.cameraDirection,
    required this.widgetSize,
    required this.imageSize,
    required this.exercise,
    required this.exerciseRepetitionCounterService,
    this.startExerciseRepsCounting = false,
    this.resetExerciseRepsCounting = false,
    this.showKeypointCircles = true,
    this.keyPointsCircleStyle = keyPointsDefaultCircleStyle,
    this.showKeypointLines = true,
    this.keyPointsLineStyle = keyPointsDefaultLineStyle,
    this.showAnglesText = true,
    this.anglesTextStyle = angleDefaultTextStyle,
    this.onRepetitionCount,
  }) {
    keypointPaint = Paint()
    ..color = keyPointsCircleStyle.color
    ..style = PaintingStyle.fill;

    linePaint = Paint()
    ..color = keyPointsLineStyle.color
    ..style = PaintingStyle.stroke
    ..strokeWidth = keyPointsLineStyle.strokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = widgetSize.width / imageSize.height;
    final scaleY = widgetSize.height / imageSize.width;

    List<double> anglesList = [];

    for (var pose in poses) {
      for (var angle in exercise.angles) {
        final a = pose.landmarks[angle.a.type];
        final b = pose.landmarks[angle.b.type];
        final c = pose.landmarks[angle.c.type];

        if (a != null && b != null && c != null) {
          final offsetA = _convert(a, scaleX, scaleY);
          final offsetB = _convert(b, scaleX, scaleY);
          final offsetC = _convert(c, scaleX, scaleY);

          // Draw Keypoints Circles
          if (showKeypointCircles) {
            canvas.drawCircle(offsetA, keyPointsCircleStyle.radius, keypointPaint);
            canvas.drawCircle(offsetB, keyPointsCircleStyle.radius, keypointPaint);
            canvas.drawCircle(offsetC, keyPointsCircleStyle.radius, keypointPaint);
          }

          // Draw Keypoints lines
          if (showKeypointLines) {
            canvas.drawLine(offsetA, offsetB, linePaint);
            canvas.drawLine(offsetB, offsetC, linePaint);
          }

          // Calculate Angle at vertex B
          final angleValue = Utils.calculateAngle(a, b, c);
          anglesList.add(angleValue);

          final textPainter = TextPainter(
            text: TextSpan(
              text: "${angleValue.toStringAsFixed(0)}°",
              style: anglesTextStyle,
            ),
            textDirection: TextDirection.ltr,
          );
          if (showAnglesText) {
            textPainter.layout();
            textPainter.paint(canvas, offsetB + const Offset(10, -10));
          }
        }
      }
    }
    
    if (anglesList.isNotEmpty && onRepetitionCount != null) {
      final reps = exerciseRepetitionCounterService.getExerciseReps(anglesList);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onRepetitionCount!(startExerciseRepsCounting ? reps : 0);
      });
    }

    if (resetExerciseRepsCounting) {
      exerciseRepetitionCounterService.reset();
    }
  }

  /// Converts MLKit landmark coordinates to widget coordinates
  Offset _convert(PoseLandmark landmark, double scaleX, double scaleY) {
  double dx, dy;

  if (cameraDirection == CameraDirection.front) {
    // Front camera: mirror horizontally
    dx = widgetSize.width - (landmark.y * scaleX);
    dy = (imageSize.width - landmark.x) * scaleY;
  } else {
    // Back camera: natural orientation, no mirror
    dx = widgetSize.width - (landmark.y * scaleX); // old :landmark.y * scaleX;
    dy = landmark.x * scaleY;
  }

  return Offset(dx, dy);
}

  @override
  bool shouldRepaint(covariant ExercisePosePainterWidget oldDelegate) {
    return oldDelegate.poses != poses ||
          oldDelegate.exercise != exercise ||
          oldDelegate.cameraDirection != cameraDirection;
  }
}