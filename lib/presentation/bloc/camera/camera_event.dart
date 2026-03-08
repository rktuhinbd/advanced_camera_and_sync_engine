import 'package:equatable/equatable.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCamera extends CameraEvent {}

class CapturePhoto extends CameraEvent {}

class SetZoom extends CameraEvent {
  final double zoom;
  const SetZoom(this.zoom);

  @override
  List<Object?> get props => [zoom];
}

class SetFocusPoint extends CameraEvent {
  final double dx;
  final double dy;
  const SetFocusPoint(this.dx, this.dy);

  @override
  List<Object?> get props => [dx, dy];
}

class CameraDispose extends CameraEvent {}
