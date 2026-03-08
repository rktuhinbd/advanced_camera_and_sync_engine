import 'package:flutter/material.dart';

class FocusIndicator extends StatelessWidget {
  final Offset position;

  const FocusIndicator({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - 35,
      top: position.dy - 35,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.yellow, width: 2),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Center(
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
