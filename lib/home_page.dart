import 'package:flutter/material.dart';
import 'package:cool_marker/marker_info_model.dart';
import 'package:cool_marker/marker_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  // 초기 카메라 위치 (서울 시청)
  static const LatLng _seoulCityHall = LatLng(37.5665, 126.9780);

  // 실제 마커 정보를 담아둘 리스트 (초기엔 아무것도 없음)
  final List<MarkerInfo> _markerInfos = [];

  late MarkerManager _markerManager;
  Set<Marker> _markers = {};
  double _currentZoom = 17.0;
  static const String googleMapStyle = '''
  [
    {
      "featureType": "poi",
      "elementType": "all",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "road",
      "elementType": "labels",
      "stylers": [{"visibility": "off"}]
    },
  ]
  ''';

  @override
  void initState() {
    super.initState();
    _markerManager = MarkerManager(_markerInfos, initialZoom: _currentZoom);
    _loadMarkers();
  }

  /// MarkerManager를 통해 Marker 세트를 생성
  Future<void> _loadMarkers() async {
    final markers = await _markerManager.loadMarkers();
    setState(() => _markers = markers);
  }

  /// 지도 카메라 움직임에 따라 줌 레벨이 크게 바뀌면 마커 재로드 (크기 조절)
  void _onCameraMove(CameraPosition position) {
    if ((_currentZoom - position.zoom).abs() >= 0.5) {
      _currentZoom = position.zoom;
      _markerManager.currentZoom = _currentZoom;
      _loadMarkers();
    }
  }

  /// 지도 생성 완료 시점에 controller 저장 + 지도 스타일 설정
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// (+) 버튼 클릭
  /// - 화면 중앙 좌표 구하기
  /// - Bottom Sheet 로 3가지 이미지(강아지, 고양이, 어린이) 선택
  /// - 선택 즉시 Custom Marker 추가
  void _onAddMarkerPressed() async {
    final center = await mapController.getLatLng(
      ScreenCoordinate(
        x: (MediaQuery.of(context).size.width ~/ 2),
        y: (MediaQuery.of(context).size.height ~/ 2),
      ),
    );

    _showImageSelectionBottomSheet(center);
  }

  /// 마커 이미지 선택 바텀싯
  void _showImageSelectionBottomSheet(LatLng center) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text('이미지 고르기', style: TextStyle(fontSize: 16)),
              const Divider(),
              ListTile(
                leading: Image.asset(
                  'assets/images/abc.jpg', // 강아지
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
                title: const Text('Dog'),
                onTap: () {
                  Navigator.pop(context);
                  _addCustomMarker(center, 'assets/images/abc.jpg');
                },
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/123.png', // 고양이
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
                title: const Text('Cat'),
                onTap: () {
                  Navigator.pop(context);
                  _addCustomMarker(center, 'assets/images/123.png');
                },
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/user_photo.png', // 어린이
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
                title: const Text('Child'),
                onTap: () {
                  Navigator.pop(context);
                  _addCustomMarker(center, 'assets/images/user_photo.png');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  /// userImagePath를 바탕으로 새로운 MarkerInfo 추가 (마커 재로드)
  void _addCustomMarker(LatLng position, String userImagePath) {
    final newMarkerInfo = MarkerInfo(
      markerId: 'marker_${DateTime.now().millisecondsSinceEpoch}',
      position: position,
      userImagePath: userImagePath,
      baseImagePath: 'assets/images/base_marker.png',
      title: 'Custom Marker',
    );

    _markerInfos.add(newMarkerInfo);
    _loadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cool Marker'),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onCameraMove: _onCameraMove,
            myLocationButtonEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: _seoulCityHall,
              zoom: 15.0,
            ),
            markers: _markers,
            style: googleMapStyle,
          ),
          Center(
            child: IgnorePointer(
              ignoring: true,
              child: Icon(
                Icons.add_location_alt,
                size: 36,
                color: Colors.red.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddMarkerPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
