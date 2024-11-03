import 'package:exitmatrix/core/constants/constants.dart';
import 'package:flutter/material.dart';

class WowMapControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onCenterPlayer;

  const WowMapControls({
    Key? key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCenterPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: EmergencyThemeColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: EmergencyThemeColors.text.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: EmergencyThemeColors.secondary,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildButton(
            icon: Icons.add,
            tooltip: 'Zoom In',
            onPressed: onZoomIn,
          ),
          _buildDivider(),
          _buildButton(
            icon: Icons.remove,
            tooltip: 'Zoom Out',
            onPressed: onZoomOut,
          ),
          _buildDivider(),
          _buildButton(
            icon: Icons.my_location,
            tooltip: 'Focus on You',
            onPressed: onCenterPlayer,
            isLocation: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: EmergencyThemeColors.text.withOpacity(0.1),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool isLocation = false,
  }) {
    return Tooltip(
      message: tooltip,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: BoxDecoration(
        color: EmergencyThemeColors.text.withOpacity(0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: isLocation 
                ? EmergencyThemeColors.primary 
                : EmergencyThemeColors.secondary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}