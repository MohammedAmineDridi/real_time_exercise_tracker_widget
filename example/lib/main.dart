import 'package:flutter/material.dart';
import 'package:sport_exercise_tracker_widget/camera_sport_exercise_tracker_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});
  @override
  ExampleAppState createState() => ExampleAppState();
}

class ExampleAppState extends State<ExampleApp> {
  ExerciseName selectedExercise = ExerciseName.curl;
  ExerciseDifficultyLevel selectedDifficulty = ExerciseDifficultyLevel.easy;
  CameraDirection selectedCamera = CameraDirection.front;
  int reps = 0;
  bool counting = false;
  late CameraConfig cameraConfig;

  @override
  void initState() {
    super.initState();
    cameraConfig = CameraConfig(
      cameraDirection: selectedCamera,
      resolution: CameraResolutionPreset.high,
      enableAudio: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Exercise Tracker Example")),
        body: Stack(
          children: [
            CameraSportExerciseTrackerWidget(
              key: ValueKey(selectedCamera),
              cameraConfig: cameraConfig,
              exerciseName: selectedExercise,
              difficultyLevel: selectedDifficulty,
              enableExerciseRepsCounting: counting,
              resetExerciseRepsCounting: !counting,
              showKeypointCircles: true,
              keyPointsCircleStyle:
                  const KeyPointsCircleStyle(color: Colors.blue, radius: 5.0),
              showKeypointLines: true,
              keyPointsLineStyle:
                  const KeyPointsLineStyle(color: Colors.green, strokeWidth: 2),
              showAnglesText: true,
              anglesTextStyle:
                  const TextStyle(color: Colors.red, fontSize: 20),
              onRepsRepetitionCount: (val) {
                setState(() {
                  reps = val;
                });
              },
            ),

            // Reps counter
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Reps: $reps',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Selectors
            Positioned(
              top: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Camera selector
                  DropdownButton<CameraDirection>(
                    value: selectedCamera,
                    items: CameraDirection.values
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e.name.toUpperCase())))
                        .toList(),
                    onChanged: (val) async {
                      setState(() {
                        selectedCamera = val!;
                        cameraConfig = CameraConfig(
                          cameraDirection: selectedCamera,
                          resolution: CameraResolutionPreset.high,
                          enableAudio: false,
                        );
                      });
                    },
                  ),

                  const SizedBox(height: 8),

                  // Exercise selector
                  DropdownButton<ExerciseName>(
                    value: selectedExercise,
                    items: ExerciseName.values
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e.name.toUpperCase())))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedExercise = val!;
                        reps = 0;
                      });
                    },
                  ),

                  const SizedBox(height: 8),

                  // Difficulty selector
                  DropdownButton<ExerciseDifficultyLevel>(
                    value: selectedDifficulty,
                    items: ExerciseDifficultyLevel.values
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e.name.toUpperCase())))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedDifficulty = val!;
                      });
                    },
                  ),

                  const SizedBox(height: 8),

                  // Start/Stop button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        counting = !counting;
                      });
                    },
                    child: Text(counting ? "Stop & Reset" : "Start"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}