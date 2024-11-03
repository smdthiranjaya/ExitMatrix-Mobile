import 'package:flutter/material.dart';

class ZoomControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onCenter;

  const ZoomControls({
    Key? key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ZoomButton(
          icon: Icons.add,
          onPressed: onZoomIn,
        ),
        const SizedBox(height: 8),
        _ZoomButton(
          icon: Icons.remove,
          onPressed: onZoomOut,
        ),
        const SizedBox(height: 16),
        _ZoomButton(
          icon: Icons.gps_fixed,
          onPressed: onCenter,
        ),
      ],
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ZoomButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 24),
          ),
        ),
      ),
    );
  }
}