import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {}

class CameraReady extends CameraState {
  final CameraController controller;
  final double currentZoom;
  final double minZoom;
  final double maxZoom;

  const CameraReady({
    required this.controller,
    this.currentZoom = 1.0,
    required this.minZoom,
    required this.maxZoom,
  });

  CameraReady copyWith({
    CameraController? controller,
    double? currentZoom,
    double? minZoom,
    double? maxZoom,
  }) {
    return CameraReady(
      controller: controller ?? this.controller,
      currentZoom: currentZoom ?? this.currentZoom,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
    );
  }

  @override
  List<Object?> get props => [controller, currentZoom, minZoom, maxZoom];
}

class CameraCapturing extends CameraState {
  final CameraController controller;
  final double currentZoom;
  final double minZoom;
  final double maxZoom;

  const CameraCapturing({
    required this.controller,
    this.currentZoom = 1.0,
    required this.minZoom,
    required this.maxZoom,
  });

  @override
  List<Object?> get props => [controller, currentZoom, minZoom, maxZoom];
}

class CameraError extends CameraState {
  final String message;
  const CameraError(this.message);

  @override
  List<Object?> get props => [message];
}
