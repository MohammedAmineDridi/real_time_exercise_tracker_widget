import 'package:sport_exercise_tracker_widget/utils/enums.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class KeyPoint {
  final PoseLandmarkType type;
  KeyPoint(this.type);
}

class Angle {
  final String? angleName;
  final KeyPoint a;
  final KeyPoint b; // vertex point
  final KeyPoint c;

  Angle({this.angleName, required this.a, required this.b, required this.c});
}

class Exercise {
  final ExerciseName name;
  final ExerciseDifficultyLevel difficultyLevel;
  final List<Angle> angles;

  Exercise({
    required this.name,
    required this.angles,
    this.difficultyLevel = ExerciseDifficultyLevel.easy,
  });


  Exercise copyWith(
      {ExerciseName? name,
      List<Angle>? angles,
      ExerciseDifficultyLevel? difficultyLevel,
      }) {
    return Exercise(
      name: name ?? this.name,
      angles: angles ?? this.angles,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
    );
  }
}
