import 'package:sport_exercise_tracker_widget/configs/camera_config.dart';
import 'package:sport_exercise_tracker_widget/utils/consts.dart';
import 'package:sport_exercise_tracker_widget/utils/enums.dart';
import 'package:sport_exercise_tracker_widget/utils/utils.dart';
import 'package:sport_exercise_tracker_widget/widgets/camera_sport_exercise_tracker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Real Time Exercise Tracker Widget")),
        body: CameraSportExerciseTrackerWidget(
          cameraConfig: CameraConfig(cameraDirection: CameraLensDirection.front,resolution: ResolutionPreset.high, enableAudio: false),
          exerciseName: ExerciseName.curl,
          difficultyLevel: ExerciseDifficultyLevel.hard,
          enableExerciseRepsCounting:true,
          resetExerciseRepsCounting:false,
          // keypoints circles params
          showKeypointCircles:true,
          keyPointsCircleStyle: const KeyPointsCircleStyle(color:Colors.blueAccent ,radius: 5.0),
          // keypoints lines params
          showKeypointLines:true,
          keyPointsLineStyle: const KeyPointsLineStyle(color: Colors.greenAccent, strokeWidth: 2.0),
          // angles text params
          showAnglesText: true,
          anglesTextStyle: const TextStyle(color:Colors.redAccent,fontSize: 20),
          onRepsRepetitionCount: (reps) {
            Utils.printf("You did $reps repetitions!");
          },
        ),
      ),
    );
  }
}