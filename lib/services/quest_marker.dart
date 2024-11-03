import 'package:exitmatrix/services/player_position.dart';

enum QuestType {
  available,
  inProgress,
  complete,
  daily,
  weekly
}

class QuestMarker {
  final PlayerPosition position;
  final QuestType type;
  final bool isComplete;
  final String questName;

  const QuestMarker({
    required this.position,
    required this.type,
    required this.isComplete,
    required this.questName,
  });
}