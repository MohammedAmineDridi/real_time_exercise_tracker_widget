import 'package:flutter_better_camera/camera.dart';
import 'package:sport_exercise_tracker_widget/utils/enums.dart';

class CameraConfig {
  final CameraDirection cameraDirection;
  final CameraResolutionPreset resolution;
  final bool enableAudio;

  CameraConfig({
    this.cameraDirection = CameraDirection.front,
    this.resolution = CameraResolutionPreset.high,
    this.enableAudio = false,
  });

  /// Converts a [CameraResolutionPreset] to your own [ResolutionPreset]
ResolutionPreset convertCameraPresetToResolutionPreset(CameraResolutionPreset preset) {
  switch (preset) {
    case CameraResolutionPreset.low:
      return ResolutionPreset.low;
    case CameraResolutionPreset.medium:
      return ResolutionPreset.medium;
    case CameraResolutionPreset.high:
      return ResolutionPreset.high;
    case CameraResolutionPreset.veryHigh:
      return ResolutionPreset.veryHigh;
    case CameraResolutionPreset.ultraHigh:
      return ResolutionPreset.ultraHigh;
    case CameraResolutionPreset.max:
      return ResolutionPreset.max;
  }
}
}