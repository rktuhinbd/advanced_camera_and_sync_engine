import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import '../../../../domain/usecases/save_image_usecase.dart';
import 'camera_event.dart';
import 'camera_state.dart';

/// CameraBloc handles the state and events for the custom camera implementation.
/// It interacts directly with the `camera` plugin and forwards hardware captures
/// to the internal database via the [SaveImageUseCase].
class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final SaveImageUseCase _saveImageUseCase;
  CameraController? _controller;

  CameraBloc(this._saveImageUseCase) : super(CameraInitial()) {
    on<InitializeCamera>(_onInitialize);
    on<CapturePhoto>(_onCapture);
    on<SetZoom>(_onZoomChanged);
    on<SetFocusPoint>(_onFocusTapped);
    on<CameraDispose>(_onDispose);
  }

  Future<void> _onInitialize(
    InitializeCamera event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        emit(const CameraError("Camera Hardware Unavailable: No cameras found on this device."));
        return;
      }

      // Automatically selects the first available camera (usually rear)
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();

      final minZoom = await _controller!.getMinZoomLevel();
      final maxZoom = await _controller!.getMaxZoomLevel();

      emit(
        CameraReady(
          controller: _controller!,
          currentZoom: 1.0,
          minZoom: minZoom,
          maxZoom: maxZoom,
        ),
      );
    } on CameraException catch (e) {
      if (e.code == 'CameraAccessDenied') {
         emit(const CameraError("Permission Denied: Please grant camera access in your device settings."));
      } else {
         emit(CameraError("Camera Initialization Failed: ${e.description}"));
      }
    } catch (e) {
      emit(CameraError("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onCapture(CapturePhoto event, Emitter<CameraState> emit) async {
    if (state is CameraReady) {
      final currentState = state as CameraReady;

      emit(
        CameraCapturing(
          controller: currentState.controller,
          currentZoom: currentState.currentZoom,
          minZoom: currentState.minZoom,
          maxZoom: currentState.maxZoom,
        ),
      );

      try {
        final XFile image = await _controller!.takePicture();
        await _saveImageUseCase(image.path);

        emit(
          CameraReady(
            controller: currentState.controller,
            currentZoom: currentState.currentZoom,
            minZoom: currentState.minZoom,
            maxZoom: currentState.maxZoom,
          ),
        );
      } catch (e) {
        emit(CameraError(e.toString()));
        emit(
          CameraReady(
            controller: currentState.controller,
            currentZoom: currentState.currentZoom,
            minZoom: currentState.minZoom,
            maxZoom: currentState.maxZoom,
          ),
        );
      }
    }
  }

  Future<void> _onZoomChanged(SetZoom event, Emitter<CameraState> emit) async {
    if (state is CameraReady && _controller != null) {
      final currentState = state as CameraReady;
      try {
        await _controller!.setZoomLevel(event.zoom);
        emit(currentState.copyWith(currentZoom: event.zoom));
      } catch (e) {
        // Handle error silently or log
      }
    }
  }

  Future<void> _onFocusTapped(
    SetFocusPoint event,
    Emitter<CameraState> emit,
  ) async {
    if (state is CameraReady && _controller != null) {
      try {
        await _controller!.setFocusPoint(Offset(event.dx, event.dy));
        await _controller!.setFocusMode(FocusMode.auto);
      } catch (e) {
        // Handle error silently or log
      }
    }
  }

  Future<void> _onDispose(
    CameraDispose event,
    Emitter<CameraState> emit,
  ) async {
    await _controller?.dispose();
    _controller = null;
    emit(CameraInitial());
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
