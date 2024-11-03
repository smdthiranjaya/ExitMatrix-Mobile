import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exitmatrix/models/map_data.dart';

class MapController {
  static Stream<MapData> getMapData() {
    return FirebaseFirestore.instance
        .collection('current_map')
        .doc('info')
        .snapshots()
        .distinct() 
        .map((snapshot) =>
            MapData.fromFirestore(snapshot.data() as Map<String, dynamic>));
  }

  static List<List<String>> stringToMap(String str) {
    return str.split('|').map((row) => row.split('')).toList();
  }
}