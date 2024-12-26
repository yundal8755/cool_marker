import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerInfo {
  final String markerId;
  final LatLng position;
  final String userImagePath;
  final String baseImagePath;
  final String title;

  MarkerInfo({
    required this.markerId,
    required this.position,
    required this.userImagePath,
    required this.baseImagePath,
    required this.title,
  });
}