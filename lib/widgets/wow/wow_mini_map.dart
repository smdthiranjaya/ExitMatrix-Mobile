import 'package:exitmatrix/core/constants/constants.dart';
import 'package:exitmatrix/painter/wow_mini_map_painter.dart';
import 'package:exitmatrix/services/player_position.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class WowMiniMap extends StatelessWidget {
  final List<List<String>> map;
  final PlayerPosition? playerPosition;
  final Function(double x, double y) onPositionTap;

  const WowMiniMap({
    Key? key,
    required this.map,
    required this.playerPosition,
    required this.onPositionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: EmergencyThemeColors.text.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map,
                  size: 16,
                  color: EmergencyThemeColors.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mini Map',
                  style: TextStyle(
                    color: EmergencyThemeColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTapDown: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final localPosition = box.globalToLocal(details.globalPosition);
                final mapWidth = map[0].length.toDouble();
                final mapHeight = map.length.toDouble();

                // Account for the header height
                final headerHeight = 36.0;
                final availableHeight = box.size.height - headerHeight;

                // Calculate cell size
                final cellSize = math.min(
                  box.size.width / mapWidth,
                  availableHeight / mapHeight,
                );

                // Calculate offsets to center the map
                final xOffset = (box.size.width - (cellSize * mapWidth)) / 2;
                final yOffset = ((availableHeight - (cellSize * mapHeight)) / 2) + headerHeight;

                // Convert tap position to map coordinates
                final x = (localPosition.dx - xOffset) / cellSize;
                final y = (localPosition.dy - yOffset) / cellSize;

                if (x >= 0 && x < mapWidth && y >= 0 && y < mapHeight) {
                  onPositionTap(x, y);
                }
              },
              child: CustomPaint(
                painter: WowMiniMapPainter(
                  map: map,
                  playerPosition: playerPosition,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          // Mini map legend
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: EmergencyThemeColors.text.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('You', EmergencyThemeColors.playerColor),
                _buildLegendItem('Exit', EmergencyThemeColors.exitColor),
                _buildLegendItem('Fire', EmergencyThemeColors.fireColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: EmergencyThemeColors.text,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
