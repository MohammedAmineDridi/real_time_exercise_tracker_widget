import 'package:sport_exercise_tracker_widget/models/exercises.dart';
import 'package:sport_exercise_tracker_widget/utils/consts.dart';
import 'package:sport_exercise_tracker_widget/models/exercise_models.dart';

enum CameraDirection {
  front,
  back
}

enum CameraResolutionPreset {
  low,
  medium,
  high,
  veryHigh,
  ultraHigh,
  max,
}

enum ExerciseName {
  curl,
  squat,
  legRaise,
  lateralRaise
}

extension ExerciseNameX on ExerciseName {
  Exercise get exerciseEntity {
    switch (this) {
      case ExerciseName.squat:
        return squatExercise;
      case ExerciseName.legRaise:
        return legRaiseExercise;
      case ExerciseName.curl:
        return curlExercise;
      case ExerciseName.lateralRaise:
        return lateralRaiseExercise;
    }
  }
}

extension ExerciseNameExtension on ExerciseName {
  double get minRequiredAngle {
    switch (this) {
      case ExerciseName.curl:
        return curlExerciseMinRequiredAngle;
      case ExerciseName.squat:
        return squatExerciseMinRequiredAngle;
      case ExerciseName.legRaise:
        return legRaiseExerciseMinRequiredAngle;
      case ExerciseName.lateralRaise:
        return lateralRaiseExerciseMinRequiredAngle;
    }
  }
}

enum ExerciseDifficultyLevel {
  easy,
  medium,
  hard,
}

extension ExercisedifficultyAngleOffsetExtension on Exercise {
  double get difficultyAngleOffsetAngle {
    switch (name) {
      case ExerciseName.curl:
        switch (difficultyLevel) {
          case ExerciseDifficultyLevel.easy:
            return curlExerciseEasyDifficultyAngleOffset;
          case ExerciseDifficultyLevel.medium:
            return curlExerciseMediumDifficultyAngleOffset;
          case ExerciseDifficultyLevel.hard:
            return curlExerciseHardDifficultyAngleOffset;
        }
      case ExerciseName.squat:
        switch (difficultyLevel) {
          case ExerciseDifficultyLevel.easy:
            return squatExerciseEasyDifficultyAngleOffset;
          case ExerciseDifficultyLevel.medium:
            return squatExerciseMediumDifficultyAngleOffset;
          case ExerciseDifficultyLevel.hard:
            return squatExerciseHardDifficultyAngleOffset;
        }
      case ExerciseName.legRaise:
        switch (difficultyLevel) {
          case ExerciseDifficultyLevel.easy:
            return legRaiseExerciseEasyDifficultyAngleOffset;
          case ExerciseDifficultyLevel.medium:
            return legRaiseExerciseMediumDifficultyAngleOffset;
          case ExerciseDifficultyLevel.hard:
            return legRaiseExerciseHardDifficultyAngleOffset;
        }
      case ExerciseName.lateralRaise:
        switch (difficultyLevel) {
          case ExerciseDifficultyLevel.easy:
            return lateralRaiseExerciseEasyDifficultyAngleOffset;
          case ExerciseDifficultyLevel.medium:
            return lateralRaiseExerciseMediumDifficultyAngleOffset;
          case ExerciseDifficultyLevel.hard:
            return lateralRaiseExerciseHardDifficultyAngleOffset;
        }
    }
  }
}

/// states for the reps counting state machine
enum RepState {
  waitingStart,
  waitingDownward,
  waitingUpwardAfterDown,
  waitingUpward,
}