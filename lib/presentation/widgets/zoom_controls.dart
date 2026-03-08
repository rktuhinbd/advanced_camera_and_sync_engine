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
            if (minZoom < 1.0) ...[
              _buildZoomButton(context, minZoom, '0.5x'),
              const SizedBox(width: 10),
            ],
            _buildZoomButton(context, 1.0, '1x'),
            const SizedBox(width: 10),
            if (maxZoom >= 2.0) ...[
              _buildZoomButton(context, 2.0, '2x'),
            ],
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

  Widget _buildZoomButton(BuildContext context, double targetZoom, String label) {
    final isSelected = (currentZoom - targetZoom).abs() < 0.1;

    return GestureDetector(
      onTap: () {
        context.read<CameraBloc>().add(SetZoom(targetZoom.clamp(minZoom, maxZoom)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow : Colors.black54,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.white,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
