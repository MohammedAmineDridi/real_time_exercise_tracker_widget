import 'package:flutter_better_camera/camera.dart';
import 'package:sport_exercise_tracker_widget/configs/camera_config.dart';

class CameraService {
  CameraController? controller;
  List<CameraDescription> _cameras = [];

  CameraService._internal();
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;

  /// Initialize the camera
  Future<void> initialize(CameraConfig config) async {
    if (controller != null) {
      await controller!.dispose();
      controller = null;
    }
    _cameras = await availableCameras();
    if (_cameras.isEmpty) {
      throw Exception("No camera available");
    }
    final selectedCamera = config.cameraDirection == CameraLensDirection.front
        ? _cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front)
        : _cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back);

    controller = CameraController(
      selectedCamera,
      config.resolution,
      enableAudio: config.enableAudio,
    );
    await controller!.initialize();
  }

  /// Start image streaming
  void startImageStream(Function(CameraImage) onFrame) {
    controller?.startImageStream(onFrame);
  }

  /// Dispose the camera
  void dispose() {
    controller?.dispose();
  }

  bool get isInitialized => controller?.value.isInitialized ?? false;
}