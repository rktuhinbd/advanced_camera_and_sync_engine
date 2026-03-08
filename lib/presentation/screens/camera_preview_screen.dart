import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/camera/camera_bloc.dart';
import '../bloc/camera/camera_event.dart';
import '../bloc/camera/camera_state.dart';
import '../widgets/focus_indicator.dart';
import '../widgets/zoom_controls.dart';
import '../widgets/pending_uploads_list.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  Offset? _focusPoint;

  @override
  void initState() {
    super.initState();
    context.read<CameraBloc>().add(InitializeCamera());
  }

  void _onTapToFocus(TapDownDetails details, BoxConstraints constraints) {
    setState(() {
      _focusPoint = details.localPosition;
    });

    final dx = details.localPosition.dx / constraints.maxWidth;
    final dy = details.localPosition.dy / constraints.maxHeight;

    context.read<CameraBloc>().add(SetFocusPoint(dx, dy));

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _focusPoint = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<CameraBloc, CameraState>(
        builder: (context, state) {
          if (state is CameraInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CameraError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () => context.read<CameraBloc>().add(InitializeCamera()),
                      child: const Text('Retry', style: TextStyle(color: Colors.black)),
                    )
                  ],
                ),
              ),
            );
          } else if (state is CameraReady || state is CameraCapturing) {
            final controller = state is CameraReady
                ? state.controller
                : (state as CameraCapturing).controller;
            final currentZoom = state is CameraReady
                ? state.currentZoom
                : (state as CameraCapturing).currentZoom;
            final minZoom = state is CameraReady
                ? state.minZoom
                : (state as CameraCapturing).minZoom;
            final maxZoom = state is CameraReady
                ? state.maxZoom
                : (state as CameraCapturing).maxZoom;
            final isCapturing = state is CameraCapturing;

            return SafeArea(
              child: Stack(
                children: [
                  // Camera Preview
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onScaleUpdate: (details) {
                          // Handle Pinch to Zoom
                          final newZoom = (currentZoom * details.scale).clamp(
                            minZoom,
                            maxZoom,
                          );
                          context.read<CameraBloc>().add(SetZoom(newZoom));
                        },
                        onTapDown: (details) =>
                            _onTapToFocus(details, constraints),
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: CameraPreview(controller),
                        ),
                      );
                    },
                  ),

                  // Focus Indicator
                  if (_focusPoint != null)
                    FocusIndicator(position: _focusPoint!),

                  // Top section: Pending Uploads
                  const Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: PendingUploadsList(),
                  ),

                  // Bottom section: Controls
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // Zoom Controls
                        ZoomControls(
                          currentZoom: currentZoom,
                          minZoom: minZoom,
                          maxZoom: maxZoom,
                        ),

                        const SizedBox(height: 20),

                        // Capture Button
                        GestureDetector(
                          onTap: isCapturing
                              ? null
                              : () => context.read<CameraBloc>().add(
                                  CapturePhoto(),
                                ),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCapturing ? Colors.grey : Colors.white,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 4,
                              ),
                            ),
                            child: isCapturing
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
