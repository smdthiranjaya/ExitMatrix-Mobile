// import 'package:exitmatrix/models/position.dart';
// import 'package:exitmatrix/widgets/zoom_controls.dart';
// import 'package:flutter/material.dart';
// import '../widgets/map_painter.dart';
// import '../widgets/info_panel.dart';
// import '../models/map_data.dart';
// import '../controllers/map_controller.dart';
// import 'dart:math' as math;

// // Custom theme colors
// const primaryRed = Color(0xFFE31837);
// const darkRed = Color(0xFFC41230);
// const almostBlack = Color(0xFF1A1A1A);

// class MapScreen extends StatefulWidget {
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
//   final TransformationController _transformationController =
//       TransformationController();
//   late AnimationController _animationController;
//   MapPosition? userPosition;
//   bool _isInitialized = false;
//   Stream<MapData>? _mapStream;
//   String? _lastMapHash;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();

//     _mapStream = MapController.getMapData();
//   }

//   void _centerMapOnUser(int mapHeight, int mapWidth) {
//     if (userPosition == null || !mounted) return;

//     final double scale = 1.5;
//     final double cellSize = 40.0;

//     final double tx = -(userPosition!.x * cellSize * scale -
//         MediaQuery.of(context).size.width / 2);
//     final double ty = -(userPosition!.y * cellSize * scale -
//         MediaQuery.of(context).size.height / 2);

//     setState(() {
//       _transformationController.value = Matrix4.identity()
//         ..scale(scale)
//         ..translate(tx, ty);
//     });
//   }

//   void _handleMapUpdate(MapData mapData) {
//     if (!mounted) return;

//     String newHash = _calculateMapHash(mapData);
//     if (_lastMapHash == newHash) return;
//     _lastMapHash = newHash;

//     final map = MapController.stringToMap(mapData.layout);
//     _isInitialized = false;

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         _initializeMapPosition(map);
//       }
//     });
//   }

//   String _calculateMapHash(MapData mapData) {
//     return '${mapData.buildingName}_${mapData.floorNumber}_${mapData.layout.length}';
//   }

//   void _initializeMapPosition(List<List<String>> map) {
//     if (_isInitialized) return;

//     // First fit the entire map to screen
//     _fitMapToScreen(map);

//     // Then find user position
//     for (int y = 0; y < map.length; y++) {
//       for (int x = 0; x < map[y].length; x++) {
//         if (map[y][x] == 'U') {
//           setState(() {
//             userPosition = MapPosition(x.toDouble(), y.toDouble());
//             _isInitialized = true;
//           });
//           break;
//         }
//       }
//     }
//   }

//   void _fitMapToScreen(List<List<String>> map) {
//     if (!mounted) return;

//     final double mapWidth = map[0].length * 40.0;
//     final double mapHeight = map.length * 40.0;
//     final Size screenSize = MediaQuery.of(context).size;

//     // Calculate scale to fit the map
//     final double scaleX = screenSize.width / mapWidth;
//     final double scaleY = screenSize.height / mapHeight;
//     final double scale =
//         math.min(scaleX, scaleY) * 0.9; // 90% of fit size for padding

//     // Center the map
//     final double tx = (screenSize.width - (mapWidth * scale)) / 2;
//     final double ty = (screenSize.height - (mapHeight * scale)) / 2;

//     setState(() {
//       _transformationController.value = Matrix4.identity()
//         ..scale(scale)
//         ..translate(tx / scale, ty / scale);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: almostBlack,
//       body: StreamBuilder<MapData>(
//         stream: _mapStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: const TextStyle(color: Colors.white),
//               ),
//             );
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(primaryRed),
//               ),
//             );
//           }

//           if (!snapshot.hasData) {
//             return const Center(
//               child: Text(
//                 'No map data available',
//                 style: TextStyle(color: Colors.white),
//               ),
//             );
//           }

//           final mapData = snapshot.data!;
//           final map = MapController.stringToMap(mapData.layout);

//           _handleMapUpdate(mapData);

//           return Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   almostBlack,
//                   almostBlack.withOpacity(0.95),
//                   almostBlack.withOpacity(0.9),
//                 ],
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: InteractiveViewer(
//                     transformationController: _transformationController,
//                     boundaryMargin: const EdgeInsets.all(double.infinity),
//                     minScale: 0.5,
//                     maxScale: 4.0,
//                     child: Center(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                               color: primaryRed.withOpacity(0.2),
//                               blurRadius: 20,
//                               spreadRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: CustomPaint(
//                           painter: MapPainter(
//                             map,
//                             userPosition: userPosition ?? MapPosition(0, 0),
//                             animation: _animationController,
//                           ),
//                           size: Size(
//                             map[0].length * 40.0,
//                             map.length * 40.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Themed Info Panel
//                 Positioned(
//                   top: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           almostBlack.withOpacity(0.9),
//                           almostBlack.withOpacity(0.7),
//                           almostBlack.withOpacity(0),
//                         ],
//                       ),
//                     ),
//                     child: InfoPanel(
//                       mapData: mapData,
//                       key: ValueKey(
//                           '${mapData.buildingName}_${mapData.floorNumber}'),
//                     ),
//                   ),
//                 ),

//                 // Themed Zoom Controls
//                 Positioned(
//                   right: 16,
//                   bottom: 32,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: primaryRed.withOpacity(0.2),
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: ZoomControls(
//                       onZoomIn: () {
//                         final Matrix4 matrix =
//                             _transformationController.value.clone();
//                         matrix.scale(1.2);
//                         _transformationController.value = matrix;
//                       },
//                       onZoomOut: () {
//                         final Matrix4 matrix =
//                             _transformationController.value.clone();
//                         matrix.scale(1 / 1.2);
//                         _transformationController.value = matrix;
//                       },
//                       onCenter: () {
//                         if (map.isNotEmpty) {
//                           _centerMapOnUser(map.length, map[0].length);
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
