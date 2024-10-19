import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic 2D Building Map',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BuildingMapScreen(),
    );
  }
}

class BuildingMapScreen extends StatelessWidget {
  const BuildingMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic 2D Building Map')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('current_map')
            .doc('info')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;
          if (data == null) {
            return const Center(child: Text('No map data available'));
          }

          final buildingName = data['buildingName'] as String;
          final floorNumber = data['floorNumber'] as int;
          final mapString = data['layout'] as String;
          final warning = data['warning'] as String?;
          final instructions = List<String>.from(data['instructions'] ?? []);
          final currentInstructionIndex =
              data['currentInstructionIndex'] as int? ?? 0;
          final List<List<String>> map = stringToMap(mapString);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Building: $buildingName - Floor: $floorNumber',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              if (warning != null && warning.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.yellow,
                  child: Text(
                    warning,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              if (instructions.isNotEmpty &&
                  currentInstructionIndex < instructions.length)
                Container(
                  padding: const EdgeInsets.all(12.0),
                  color: Colors.lightBlue,
                  child: Text(
                    instructions[currentInstructionIndex],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20.0),
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CustomPaint(
                    painter: MapPainter(map),
                    size: const Size(300, 450),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  final List<List<String>> map;

  MapPainter(this.map);

  @override
  void paint(Canvas canvas, Size size) {
    if (map.isEmpty) return;

    final double cellWidth = size.width / map[0].length;
    final double cellHeight = size.height / map.length;

    for (int y = 0; y < map.length; y++) {
      for (int x = 0; x < map[y].length; x++) {
        final rect = Rect.fromLTWH(
          x * cellWidth,
          y * cellHeight,
          cellWidth,
          cellHeight,
        );

        final Paint paint = Paint();

        switch (map[y][x]) {
          case '0':
            paint.color = Colors.grey[300]!;
            canvas.drawRect(rect, paint);
            _drawWallShadow(canvas, rect);
            break;
          case 'S':
            paint.color = Colors.green[300]!;
            canvas.drawCircle(rect.center, cellWidth / 2, paint);
            break;
          case 'F':
            paint.color = Colors.red[300]!;
            canvas.drawCircle(rect.center, cellWidth / 2, paint);
            break;
          case 'U':
            _drawUser(canvas, rect);
            break;
          case 'P':
            _drawPathCell(canvas, rect);
            break;
          case 'Z':
            _drawFireZoneCell(canvas, rect);
            break;
          default:
            paint.color = Colors.white;
            canvas.drawRect(rect, paint);
        }

        // Draw grid lines
        canvas.drawRect(
          rect,
          Paint()
            ..color = Colors.grey[200]!
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      }
    }
  }

  void _drawFireZoneCell(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.orange.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, paint);
  }

  void _drawFireZone(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.orange.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int dy = -1; dy <= 1; dy++) {
      for (int dx = -1; dx <= 1; dx++) {
        if (dx == 0 && dy == 0) continue;
        final zoneRect = Rect.fromLTWH(
          rect.left + dx * rect.width,
          rect.top + dy * rect.height,
          rect.width,
          rect.height,
        );
        canvas.drawRect(zoneRect, paint);
      }
    }
  }

  void _drawWallShadow(Canvas canvas, Rect rect) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawRect(rect.translate(2, 2), shadowPaint);
  }

  void _drawUser(Canvas canvas, Rect rect) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(rect.center, rect.width / 2, paint);
  }

  void _drawPathCell(Canvas canvas, Rect rect) {
    final paint = Paint()..color = Colors.yellow.withOpacity(0.5);
    canvas.drawRect(rect, paint);

    final arrowPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(rect.left + rect.width * 0.2, rect.top + rect.height * 0.5)
      ..lineTo(rect.left + rect.width * 0.8, rect.top + rect.height * 0.5)
      ..lineTo(rect.left + rect.width * 0.7, rect.top + rect.height * 0.3)
      ..moveTo(rect.left + rect.width * 0.8, rect.top + rect.height * 0.5)
      ..lineTo(rect.left + rect.width * 0.7, rect.top + rect.height * 0.7);

    canvas.drawPath(path, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

List<List<String>> stringToMap(String str) {
  return str.split('|').map((row) => row.split('')).toList();
}
