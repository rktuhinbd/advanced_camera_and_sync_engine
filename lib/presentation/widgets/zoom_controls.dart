import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/camera/camera_bloc.dart';
import '../bloc/camera/camera_event.dart';

class ZoomControls extends StatelessWidget {
  final double currentZoom;
  final double minZoom;
  final double maxZoom;

  const ZoomControls({
    super.key,
    required this.currentZoom,
    required this.minZoom,
    required this.maxZoom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildZoomButton(context, 0.5),
            const SizedBox(width: 10),
            _buildZoomButton(context, 1.0),
            const SizedBox(width: 10),
            _buildZoomButton(context, 2.0),
          ],
        ),
        Slider(
          value: currentZoom,
          min: minZoom,
          max: maxZoom,
          activeColor: Colors.yellow,
          inactiveColor: Colors.white54,
          onChanged: (value) {
            context.read<CameraBloc>().add(SetZoom(value));
          },
        ),
      ],
    );
  }

  Widget _buildZoomButton(BuildContext context, double targetZoom) {
    // If target zoom is outside the bounds, we clamp it to max/min
    final clampTargetZoom = targetZoom.clamp(minZoom, maxZoom);
    final isSelected = (currentZoom - clampTargetZoom).abs() < 0.1;

    return GestureDetector(
      onTap: () {
        context.read<CameraBloc>().add(SetZoom(clampTargetZoom));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow : Colors.black54,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.yellow : Colors.white),
        ),
        child: Text(
          '${targetZoom}x',
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
