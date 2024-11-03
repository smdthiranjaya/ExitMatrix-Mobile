class MapData {
  final String buildingName;
  final int floorNumber;
  final String layout;
  final String? warning;
  final List<String> instructions;
  final int currentInstructionIndex;

  MapData({
    required this.buildingName,
    required this.floorNumber,
    required this.layout,
    this.warning,
    required this.instructions,
    required this.currentInstructionIndex,
  });

  factory MapData.fromFirestore(Map<String, dynamic> data) {
    return MapData(
      buildingName: data['buildingName'] as String,
      floorNumber: data['floorNumber'] as int,
      layout: data['layout'] as String,
      warning: data['warning'] as String?,
      instructions: List<String>.from(data['instructions'] ?? []),
      currentInstructionIndex: data['currentInstructionIndex'] as int? ?? 0,
    );
  }
}