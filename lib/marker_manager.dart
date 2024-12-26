import 'dart:typed_data';
import 'package:cool_marker/marker_creator.dart';
import 'package:cool_marker/marker_info_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///
/// - 줌 레벨 변화에 따라 마커 크기를 동적으로 조정
/// - MarkerInfo 리스트를 받아, 실제 Marker(Set<Marker>)로 변환
///
class MarkerManager {
  double _currentZoom;
  final List<MarkerInfo> _markerInfos;

  MarkerManager(this._markerInfos, {double initialZoom = 14.0})
      : _currentZoom = initialZoom;

  set currentZoom(double zoom) => _currentZoom = zoom;

  Future<Set<Marker>> loadMarkers() async {
    // 줌 레벨에 따른 마커 크기 조정 (최소 100, 최대 300)
    final int markerSize = (120 * (_currentZoom / 14)).clamp(100, 300).toInt();

    Set<Marker> markers = {};

    for (final info in _markerInfos) {
      final Uint8List markerIconBytes =
          await MarkerCreator.createCustomMarker(
        info.baseImagePath,
        info.userImagePath,
        markerSize,
      );

      final BitmapDescriptor markerIcon = BitmapDescriptor.bytes(
        markerIconBytes,
        imagePixelRatio: 2.0,
      );

      markers.add(
        Marker(
          markerId: MarkerId(info.markerId),
          position: info.position,
          icon: markerIcon,
          infoWindow: InfoWindow(title: info.title),
        ),
      );
    }

    return markers;
  }
}
