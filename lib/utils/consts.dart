import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';


// ------------------------- keypoints params (Lines & Circles) ------------------------

// ------------- Keypoints Circles
class KeyPointsCircleStyle {
  final Color color;
  final double radius;
  const KeyPointsCircleStyle({required this.color, required this.radius});
}
const Color keyPointCircleColor = Colors.redAccent;
const double keyPointCircleRadius = 5.0;
const KeyPointsCircleStyle keyPointsDefaultCircleStyle = KeyPointsCircleStyle(color: keyPointCircleColor,radius: keyPointCircleRadius);

// ------------- Keypoints Lines
class KeyPointsLineStyle {
  final Color color;
  final double strokeWidth;
  const KeyPointsLineStyle({required this.color, required this.strokeWidth});
}
const Color keyPointLinesColor = Colors.greenAccent;
const double keyPointLineStrokeWidth = 2.0;
const KeyPointsLineStyle keyPointsDefaultLineStyle = KeyPointsLineStyle(color:keyPointLinesColor,strokeWidth: keyPointLineStrokeWidth);

// ------------- Angle Text
const Color angleTextColor = Colors.yellowAccent;
const double angleTextFontSize = 14.0;
const TextStyle angleDefaultTextStyle = TextStyle(color: angleTextColor, fontSize: angleTextFontSize);

// ------------------------------------ Min Required Angles ------------------------------------

// min required Angle : is the min reached angle to count the exerice rep++

// curl min angles (init angle = 180 deg)
const double curlExerciseMinRequiredAngle = 90.0;

// Squat min angles (init angle = 180 deg)
const double squatExerciseMinRequiredAngle = 90.0;

// legRaise min angles (init angle = 180 deg 'leg in init position')
const double legRaiseExerciseMinRequiredAngle = 90.0;

// legRaise min angles (init angle = 180 deg 'leg in init position')
const double lateralRaiseExerciseMinRequiredAngle = 60.0;

// ------------------------------------ difficultyAngleOffset Angles ------------------------------------

const double squatExerciseEasyDifficultyAngleOffset = 20.0;
const double squatExerciseMediumDifficultyAngleOffset = 40.0;
const double squatExerciseHardDifficultyAngleOffset = 60.0;

const double curlExerciseEasyDifficultyAngleOffset = 20.0;
const double curlExerciseMediumDifficultyAngleOffset = 40.0;
const double curlExerciseHardDifficultyAngleOffset = 60.0;

const double legRaiseExerciseEasyDifficultyAngleOffset = 20.0;
const double legRaiseExerciseMediumDifficultyAngleOffset = 40.0;
const double legRaiseExerciseHardDifficultyAngleOffset = 60.0;

const double lateralRaiseExerciseEasyDifficultyAngleOffset = 10.0;
const double lateralRaiseExerciseMediumDifficultyAngleOffset = 20.0;
const double lateralRaiseExerciseHardDifficultyAngleOffset = 30.0;

// ------------------------------------ Angles Names ------------------------------------

const Map<PoseLandmarkType,String> angleNames = {
  // for curl exercise
  PoseLandmarkType.leftElbow : "leftElbowAngle",
  PoseLandmarkType.rightElbow : "rightElbowAngle",
  // for squat & legRaise exercise
  PoseLandmarkType.leftKnee : "leftKneeAngle",
  PoseLandmarkType.rightKnee : "rightKneeAngle",
  // for lateral raise exercise
  PoseLandmarkType.leftShoulder : "leftShoulderAngle",
  PoseLandmarkType.rightShoulder : "rightShoulderAngle",
};

/// This used for (Timing Filtering) :
/// Prevents counting reps that are performed too fast by enforcing a minimum duration for each movement
const int minMovementDurationMs = 1000;
const int maxMovementDurationMs = 5000;