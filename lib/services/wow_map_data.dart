import 'package:exitmatrix/services/quest_marker.dart';

class WowMapData {
  final String zoneName;
  final String subZone;
  final String recommendedLevel;
  final List<String> mapLayout;
  final List<QuestMarker>? questMarkers;

  const WowMapData({
    required this.zoneName,
    required this.subZone,
    required this.recommendedLevel,
    required this.mapLayout,
    this.questMarkers,
  });
}