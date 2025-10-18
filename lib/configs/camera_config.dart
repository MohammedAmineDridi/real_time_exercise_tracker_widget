import 'package:flutter_better_camera/camera.dart';

class CameraConfig {
  final CameraLensDirection cameraDirection;
  final ResolutionPreset resolution;
  final bool enableAudio;

  CameraConfig({
    this.cameraDirection = CameraLensDirection.front,
    this.resolution = ResolutionPreset.high,
    this.enableAudio = false,
  });
}