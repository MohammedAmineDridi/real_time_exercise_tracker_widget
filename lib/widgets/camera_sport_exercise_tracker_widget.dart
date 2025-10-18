import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:sport_exercise_tracker_widget/configs/camera_config.dart';
import 'package:sport_exercise_tracker_widget/utils/consts.dart';
import 'package:sport_exercise_tracker_widget/utils/enums.dart';
import 'package:sport_exercise_tracker_widget/services/camera_service.dart';
import '../models/exercise_models.dart';
import '../services/exercise_repetition_counter_service.dart';
import '../services/pose_detection_service.dart';
import '../utils/utils.dart';
import 'exercise_pose_painter.dart';

class CameraSportExerciseTrackerWidget extends StatefulWidget {
  final ExerciseName exerciseName;
  final ExerciseDifficultyLevel difficultyLevel;
  final CameraConfig? cameraConfig;
  final bool? enableExerciseRepsCounting;
  final bool? resetExerciseRepsCounting;
  final bool? showKeypointCircles;
  final KeyPointsLineStyle? keyPointsLineStyle;
  final KeyPointsCircleStyle? keyPointsCircleStyle;
  final bool? showKeypointLines;
  final bool? showAnglesText;
  final TextStyle? anglesTextStyle;
  final void Function(int reps)? onRepsRepetitionCount;

  const CameraSportExerciseTrackerWidget({
    super.key,
    required this.exerciseName,
    required this.enableExerciseRepsCounting,
    required this.resetExerciseRepsCounting,
    required this.difficultyLevel,
    this.showKeypointCircles,
    this.keyPointsLineStyle,
    this.keyPointsCircleStyle,
    this.showKeypointLines,
    this.showAnglesText,
    this.anglesTextStyle,
    this.cameraConfig,
    this.onRepsRepetitionCount,
  });

  @override
  CameraExerciseTrackerWidgetState createState() => CameraExerciseTrackerWidgetState();
}

class CameraExerciseTrackerWidgetState extends State<CameraSportExerciseTrackerWidget> {
  final PoseDetectionService _poseService = PoseDetectionService();
  final CameraService _cameraService = CameraService();

  late Exercise exercise;
  late ExerciseRepetitionCounterService _repService;
  List<Pose> _poses = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    exercise = widget.exerciseName.exerciseEntity;
    exercise = exercise.copyWith(difficultyLevel: widget.difficultyLevel);
    _repService = ExerciseRepetitionCounterService(exercise: exercise);
    _initCamera();
  }

  @override
  void didUpdateWidget(covariant CameraSportExerciseTrackerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exerciseName != widget.exerciseName || oldWidget.difficultyLevel != widget.difficultyLevel) {
      exercise = widget.exerciseName.exerciseEntity;
      exercise = exercise.copyWith(difficultyLevel: widget.difficultyLevel);
      _repService = ExerciseRepetitionCounterService(exercise: exercise);
    }
  }

  Future<void> _initCamera() async {
    try {
      await _cameraService.initialize(widget.cameraConfig!);
      _cameraService.startImageStream(_processCameraImage);
    } catch (e) {
      Utils.printf("Camera init error: $e");
    }
  }

  void _processCameraImage(CameraImage cameraImage) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final poses = await _poseService.processCameraImage(cameraImage);
      setState(() {
        _poses = poses;
      });
    } catch (e) {
      Utils.printf("Pose detection error: $e");
    } finally {
      _isProcessing = false;
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _poseService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraService.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final controller = _cameraService.controller!;
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final widgetSize = Size(constraints.maxWidth, constraints.maxHeight);
          return Stack(
            children: [
              // Camera preview
              CameraPreview(controller),
              // Pose painter
              if (_poses.isNotEmpty)
                CustomPaint(
                  size: widgetSize,
                  painter: ExercisePosePainterWidget(
                    exercise: exercise,
                    exerciseRepetitionCounterService: _repService,
                    cameraDirection: widget.cameraConfig!.cameraDirection,
                    startExerciseRepsCounting: widget.enableExerciseRepsCounting!,
                    resetExerciseRepsCounting: widget.resetExerciseRepsCounting!,
                    showKeypointCircles:widget.showKeypointCircles!,
                    keyPointsCircleStyle: widget.keyPointsCircleStyle!,
                    showKeypointLines:widget.showKeypointLines!,
                    keyPointsLineStyle:  widget.keyPointsLineStyle!,
                    anglesTextStyle: widget.anglesTextStyle!,
                    showAnglesText: widget.showAnglesText!,
                    poses: _poses,
                    widgetSize: widgetSize,
                    imageSize: controller.value.previewSize!,
                    onRepetitionCount: (reps) {
                      Utils.printf("Reps = $reps ,for ${exercise.name}");
                      if (widget.onRepsRepetitionCount != null) {
                        widget.onRepsRepetitionCount!(reps);
                      }
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}