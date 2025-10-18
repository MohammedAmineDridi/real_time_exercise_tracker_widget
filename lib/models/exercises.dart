import 'package:sport_exercise_tracker_widget/utils/consts.dart';
import 'package:sport_exercise_tracker_widget/utils/enums.dart';
import 'package:sport_exercise_tracker_widget/models/exercise_models.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Squat Exercise instance
final squatExercise = Exercise(
  name: ExerciseName.squat,
  angles: [
    // Left leg
    Angle(
      angleName: angleNames[PoseLandmarkType.leftKnee],
      a: KeyPoint(PoseLandmarkType.leftHip),
      b: KeyPoint(PoseLandmarkType.leftKnee),
      c: KeyPoint(PoseLandmarkType.leftAnkle),
    ),
    // Right leg
    Angle(
      angleName: angleNames[PoseLandmarkType.rightKnee],
      a: KeyPoint(PoseLandmarkType.rightHip),
      b: KeyPoint(PoseLandmarkType.rightKnee),
      c: KeyPoint(PoseLandmarkType.rightAnkle),
    ),
  ],
);

/// LegRaise Exercise instance
final legRaiseExercise = Exercise(
  name: ExerciseName.legRaise,
  angles: [
    // Left leg
    Angle(
      angleName: angleNames[PoseLandmarkType.leftKnee],
      a: KeyPoint(PoseLandmarkType.leftHip),
      b: KeyPoint(PoseLandmarkType.leftKnee),
      c: KeyPoint(PoseLandmarkType.leftAnkle),
    ),
    // Right leg
    Angle(
      angleName: angleNames[PoseLandmarkType.rightKnee],
      a: KeyPoint(PoseLandmarkType.rightHip),
      b: KeyPoint(PoseLandmarkType.rightKnee),
      c: KeyPoint(PoseLandmarkType.rightAnkle),
    ),
  ],
);

/// curl Exercise instance
final curlExercise = Exercise(
  name: ExerciseName.curl,
  angles: [
    // Left elbow
    Angle(
      angleName: angleNames[PoseLandmarkType.leftElbow],
      a: KeyPoint(PoseLandmarkType.leftShoulder),
      b: KeyPoint(PoseLandmarkType.leftElbow),
      c: KeyPoint(PoseLandmarkType.leftWrist),
    ),
    // Right elbow
    Angle(
      angleName: angleNames[PoseLandmarkType.rightElbow],
      a: KeyPoint(PoseLandmarkType.rightShoulder),
      b: KeyPoint(PoseLandmarkType.rightElbow),
      c: KeyPoint(PoseLandmarkType.rightWrist),
    ),
  ],
);

/// Lateral Raise Exercise instance
final lateralRaiseExercise = Exercise(
  name: ExerciseName.curl,
  angles: [
    // Left shoulder
    Angle(
      angleName: angleNames[PoseLandmarkType.leftShoulder],
      a: KeyPoint(PoseLandmarkType.leftElbow),
      b: KeyPoint(PoseLandmarkType.leftShoulder),
      c: KeyPoint(PoseLandmarkType.leftHip),
    ),
    // Right shoulder
    Angle(
      angleName: angleNames[PoseLandmarkType.rightShoulder],
      a: KeyPoint(PoseLandmarkType.rightElbow),
      b: KeyPoint(PoseLandmarkType.rightShoulder),
      c: KeyPoint(PoseLandmarkType.rightHip),
    ),
  ],
);