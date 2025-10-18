/*
************************* EXERCISE REPETITION COUNTER LOGIC *************************

This service counts exercise repetitions based on the user's joint angles.

Definitions:
- minAngle: the minimum angle required for a valid repetition (depends on exercise type).
- AddedAngle: it's an added angle value for the minAngle to make the exercise easy,medium or hard based on difficulty level
- currentAngle: the user's real-time joint angle measured from the camera/pose detection.

Workflow:

1. Starting State (waitingStart):
   - If currentAngle > minAngle + difficultyAngleOffset
       → User is starting from "up" position.
       → Transition to waitingDownward state (wait for downward movement).
   - If currentAngle < minAngle - difficultyAngleOffset
       → User is starting from "down" position.
       → Transition to waitingUpward state (wait for upward movement).

2. Downward Phase (waitingDownward):
   - Wait until currentAngle < minAngle - difficultyAngleOffset
       → User has moved down enough.
       → Mark _readyToCount = true.
       → Transition to waitingUpwardAfterDown state (wait for upward movement).

3. Upward Phase After Down (waitingUpwardAfterDown):
   - Wait until currentAngle > minAngle + difficultyAngleOffset AND _readyToCount == true
       → User completed one repetition.
       → Increment reps counter (_reps++).
       → Reset _readyToCount = false.
       → Transition back to waitingDownward (ready for next repetition).

4. Upward Phase (waitingUpward):
   - If currentAngle > minAngle + difficultyAngleOffset
       → User has returned to starting position from "down".
       → Transition back to waitingStart.

Notes:
- The repetition is counted only when a full downward → upward (or vice versa) cycle occurs beyond the difficultyAngleOffset.
- The difficultyAngleOffset prevents false positives due to small movements or angle fluctuations.
- The algorithm supports starting in either up or down position.
- we had a (Timing Filter) that detect a random angles deflections (wrong exercise mouvements for eg)

Logic of (Timing Filter) : 

CASE 1 : If 'up' or 'down' too fast (< 200 ms for example) => ignore the mouvement
CASE 2 : If 'up' or 'down' too slow (> maxMovementDurationMs, e.g. 5000 ms)  => treat it as invalid or user paused, do NOT count the repetition (maybe user stopped the exercise)

Example:
- minAngle = 90°, difficultyAngleOffsetAngle = 45°.

Case 1:
- Start: currentAngle = 120° (> min + difficultyAngleOffset = 135°? wait) → wait until angle < 45° → wait until angle > 135° → rep++

Case 2:
- Start: currentAngle = 40° (< min - difficultyAngleOffset = 45°) → wait until angle > 135° → rep counted during full cycle
*/

import 'package:sport_exercise_tracker_widget/utils/consts.dart';
import 'package:sport_exercise_tracker_widget/utils/enums.dart';
import 'package:sport_exercise_tracker_widget/models/exercise_models.dart';
import 'package:sport_exercise_tracker_widget/utils/utils.dart';

class ExerciseRepetitionCounterService {
  final Exercise exercise;

  int _reps = 0;
  bool _readyToCount = false;
  RepState _state = RepState.waitingStart;

  DateTime? _movementStartTime;

  ExerciseRepetitionCounterService({
    required this.exercise,
  });

  int getExerciseReps(List<double> currentAngles) {
    if (currentAngles.isEmpty) return _reps;
    final double currentAngle =
        currentAngles.reduce((a, b) => a + b) / currentAngles.length;

    final minAngle = exercise.name.minRequiredAngle;
    final upperDifficultyAngleOffset = minAngle + exercise.difficultyAngleOffsetAngle;
    final lowerDifficultyAngleOffset =  minAngle - exercise.difficultyAngleOffsetAngle;

    switch (_state) {
      case RepState.waitingStart:
        if (currentAngle > upperDifficultyAngleOffset) {
          _state = RepState.waitingDownward;
        } else if (currentAngle < lowerDifficultyAngleOffset) {
          _state = RepState.waitingUpward;
        }
        break;

      case RepState.waitingDownward:
        if (currentAngle < lowerDifficultyAngleOffset) {
          _readyToCount = true;
          _movementStartTime = DateTime.now();
          Utils.printf("bbbbbbbb mouvement startTimer $_movementStartTime");
          _state = RepState.waitingUpwardAfterDown;
        }
        break;

      case RepState.waitingUpwardAfterDown:
        if (currentAngle > upperDifficultyAngleOffset && _readyToCount) {
          final elapsed = DateTime.now().difference(_movementStartTime!).inMilliseconds;
          Utils.printf("bbbbbbbb Movement duration = $elapsed ms");

          if (elapsed < minMovementDurationMs) {
            Utils.printf("bbbbbbbb ❌ Too fast ($elapsed ms), rep not counted (min = $minMovementDurationMs ms)");
          } else if (elapsed > maxMovementDurationMs) {
            Utils.printf("bbbbbbbb ❌ Too slow ($elapsed ms), rep not counted (max = $maxMovementDurationMs ms)");
          } else {
            _reps++;
            Utils.printf("bbbbbbbb ✅ Good rep! reps = $_reps (time=$elapsed ms)");
          }
          _readyToCount = false;
          _movementStartTime = null;
          _state = RepState.waitingDownward;
        }
        break;

      case RepState.waitingUpward:
        if (currentAngle > upperDifficultyAngleOffset) {
          _state = RepState.waitingStart;
        }
        break;
    }

    return _reps;
  }

  void reset() {
    _reps = 0;
    _readyToCount = false;
    _movementStartTime = null;
    _state = RepState.waitingStart;
  }

  int get repetitions => _reps;
}