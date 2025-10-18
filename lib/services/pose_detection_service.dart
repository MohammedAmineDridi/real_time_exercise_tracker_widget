/*
PoseDetectionService

- It's a service for real-time human pose detection using Google ML Kit SDK.
- Converts camera frames (CameraImage) into InputImage and detects poses.
- Handles platform-specific image formats:
    • Android: YUV420 → NV21
    • iOS: BGRA8888
- Methods:
    • processCameraImage(CameraImage) → Future<List<Pose>> : detect poses
    • dispose() : release PoseDetector resources
- Usage: call processCameraImage on each camera frame, dispose when done.
*/

import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectionService {
  static final PoseDetectionService _instance = PoseDetectionService._internal();
  factory PoseDetectionService() => _instance;

  late final PoseDetector _poseDetector;
  final PoseDetectionMode _poseDetectionMode = PoseDetectionMode.stream;
  final PoseDetectionModel _poseDetectionModel = PoseDetectionModel.base;

  PoseDetectionService._internal() {
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        mode: _poseDetectionMode,
        model: _poseDetectionModel,
      ),
    );
  }
  /// Process camera image and return detected poses
  Future<List<Pose>> processCameraImage(CameraImage cameraImage) async {
    final bytes = Platform.isAndroid
        ? _convertYUV420ToNV21(cameraImage)
        : cameraImage.planes[0].bytes;

    final inputImage = InputImage.fromBytes(
      bytes: bytes!,
      metadata: InputImageMetadata(
        size: Size(
          cameraImage.width!.toDouble(),
          cameraImage.height!.toDouble(),
        ),
        rotation: InputImageRotation.rotation0deg,
        format: Platform.isAndroid
            ? InputImageFormat.nv21
            : InputImageFormat.bgra8888,
        bytesPerRow: cameraImage.planes[0].bytesPerRow!,
      ),
    );

    return _poseDetector.processImage(inputImage);
  }

  /// Convert YUV420 camera image to NV21 (for Android)
  Uint8List _convertYUV420ToNV21(CameraImage image) {
    final width = image.width!;
    final height = image.height!;
    final uvRowStride = image.planes[1].bytesPerRow!;
    final uvPixelStride = image.planes[1].bytesPerPixel!;
    final nv21 = Uint8List(width * height * 3 ~/ 2);

    // Copy Y plane
    for (int i = 0; i < height; i++) {
      nv21.setRange(
        i * width,
        (i + 1) * width,
        image.planes[0].bytes!,
        i * image.planes[0].bytesPerRow!,
      );
    }

    // Copy UV plane
    int uvIndex = width * height;
    for (int i = 0; i < height ~/ 2; i++) {
      for (int j = 0; j < width ~/ 2; j++) {
        nv21[uvIndex++] = image.planes[1].bytes![i * uvRowStride + j * uvPixelStride]; // U
        nv21[uvIndex++] = image.planes[2].bytes![i * uvRowStride + j * uvPixelStride]; // V
      }
    }
    return nv21;
  }

  /// Dispose the PoseDetector
  void dispose() {
    _poseDetector.close();
  }
}