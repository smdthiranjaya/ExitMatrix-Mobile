import 'package:exitmatrix/controllers/map_controller.dart';
import 'package:exitmatrix/core/constants/constants.dart';
import 'package:exitmatrix/models/Particle.dart';
import 'package:exitmatrix/models/map_data.dart';
import 'package:exitmatrix/painter/wow_map_painter.dart';
import 'package:exitmatrix/services/player_position.dart';
import 'package:exitmatrix/services/wow_map_data.dart';
import 'package:exitmatrix/widgets/info_panel.dart';
import 'package:exitmatrix/widgets/wow/WowMapControls.dart';
import 'package:exitmatrix/widgets/wow/WowZoneInfoPanel.dart';
import 'package:exitmatrix/widgets/wow/wow_background.dart';
import 'package:exitmatrix/widgets/wow/wow_mini_map.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class WowMapScreen extends StatefulWidget {
  const WowMapScreen({Key? key}) : super(key: key);

  @override
  State<WowMapScreen> createState() => _WowMapScreenState();
}

class _WowMapScreenState extends State<WowMapScreen>
    with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _playerPulseAnimation;
  late AnimationController _compassAnimation;
  PlayerPosition? userPosition;
  bool _isInitialized = false;
  Stream<MapData>? _mapStream;
  String? _lastMapHash;

  static const Color wowGold = Color(0xFFFFD100);
  static const Color wowDarkBrown = Color(0xFF2C1810);
  static const Color wowLightBrown = Color(0xFF483B2A);

  @override
  void initState() {
    super.initState();
    _playerPulseAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _compassAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _mapStream =
        MapController.getMapData(); // Using your existing MapController
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _playerPulseAnimation.dispose();
    _compassAnimation.dispose();
    super.dispose();
  }

  void _initializePlayerPosition(List<List<String>> map) {
    if (_isInitialized) return;

    for (int y = 0; y < map.length; y++) {
      for (int x = 0; x < map[y].length; x++) {
        if (map[y][x] == 'U') {
          setState(() {
            userPosition = PlayerPosition(x.toDouble(), y.toDouble());
            _isInitialized = true;
          });

          // Focus on player position with animation
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _focusOnPlayer();
            }
          });
          return;
        }
      }
    }
  }

void _focusOnPlayer() {
  if (userPosition == null || !mounted) return;

  final Size screenSize = MediaQuery.of(context).size;
  final double cellSize = 60.0;
  final double scale = 2.0; // Increased zoom level for focus

  final double tx = -(userPosition!.x * cellSize * scale - screenSize.width / 2);
  final double ty = -(userPosition!.y * cellSize * scale - screenSize.height / 2);

  setState(() {
    _transformationController.value = Matrix4.identity()
      ..scale(scale)
      ..translate(tx / scale, ty / scale);
  });
}
  String _calculateMapHash(MapData mapData) {
    return '${mapData.buildingName}_${mapData.floorNumber}_${mapData.layout}';
  }

  void _handleMapUpdate(MapData mapData) {
    if (!mounted) return;

    String newHash = _calculateMapHash(mapData);
    if (_lastMapHash == newHash) return;
    _lastMapHash = newHash;

    final map = MapController.stringToMap(mapData.layout);
    _isInitialized = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializePlayerPosition(map);
      }
    });
  }

  void _centerMapOnPosition(double x, double y) {
    if (!mounted) return;

    final double scale = 1.5;
    final double cellSize = 60.0;

    final double tx =
        -(x * cellSize * scale - MediaQuery.of(context).size.width / 2);
    final double ty =
        -(y * cellSize * scale - MediaQuery.of(context).size.height / 2);

    setState(() {
      _transformationController.value = Matrix4.identity()
        ..scale(scale)
        ..translate(tx, ty);
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: EmergencyThemeColors.background,
    body: StreamBuilder<MapData>(
      stream: _mapStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorView(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingView();
        }

        if (!snapshot.hasData) {
          return _buildNoDataView();
        }

        final mapData = snapshot.data!;
        final map = MapController.stringToMap(mapData.layout);

        _handleMapUpdate(mapData);

        return Stack(
          children: [
            // Main map view
            Positioned.fill(
              child: InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: CustomPaint(
                    painter: WowMapPainter(
                      map,
                      playerPosition: userPosition ?? PlayerPosition(0, 0),
                      playerAnimation: _playerPulseAnimation,
                    ),
                    size: Size(
                      map[0].length * 60.0,
                      map.length * 60.0,
                    ),
                  ),
                ),
              ),
            ),

            // Info Panel at the top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: InfoPanel(
                mapData: mapData,
                key: ValueKey('${mapData.buildingName}_${mapData.floorNumber}'),
              ),
            ),

            // Mini-map moved to bottom left
            Positioned(
              left: 16,
              bottom: 32,
              child: WowMiniMap(
                map: map,
                playerPosition: userPosition,
                onPositionTap: _centerMapOnPosition,
              ),
            ),

            // Map controls stay at bottom right
            Positioned(
              right: 16,
              bottom: 32,
              child: WowMapControls(
                onZoomIn: () {
                  final Matrix4 matrix = _transformationController.value.clone();
                  matrix.scale(1.2);
                  _transformationController.value = matrix;
                },
                onZoomOut: () {
                  final Matrix4 matrix = _transformationController.value.clone();
                  matrix.scale(1 / 1.2);
                  _transformationController.value = matrix;
                },
                onCenterPlayer: () {
                  if (map.isNotEmpty && userPosition != null) {
                    _centerMapOnPosition(userPosition!.x, userPosition!.y);
                  }
                },
              ),
            ),
          ],
        );
      },
    ),
  );
}

  Widget _buildErrorView(String error) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: wowDarkBrown,
          border: Border.all(color: wowGold, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Error loading map: $error',
          style: const TextStyle(color: wowGold),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Loading map...',
            style: TextStyle(color: wowGold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataView() {
    return const Center(
      child: Text(
        'Map unavailable',
        style: TextStyle(color: wowGold, fontSize: 18),
      ),
    );
  }
}

