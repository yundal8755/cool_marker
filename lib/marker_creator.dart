import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// Custom Marker 아이콘을 합성하는 전담 클래스
/// - 베이스 마커 이미지 + 사용자 이미지 → 하나의 PNG(Uint8List) → BitmapDescriptor
///
class MarkerCreator {
  static Future<Uint8List> createCustomMarker(
      String baseImagePath, String userImagePath, int size) async {
    // (1) 베이스 마커 로드
    final ByteData baseData = await rootBundle.load(baseImagePath);
    final ui.Codec baseCodec = await ui.instantiateImageCodec(
      baseData.buffer.asUint8List(),
      targetWidth: size,
    );
    final ui.FrameInfo baseFrameInfo = await baseCodec.getNextFrame();
    final ui.Image baseImage = baseFrameInfo.image;

    // (2) 사용자 이미지 로드
    final ByteData userData = await rootBundle.load(userImagePath);
    final ui.Codec userCodec =
        await ui.instantiateImageCodec(userData.buffer.asUint8List());
    final ui.FrameInfo userFrameInfo = await userCodec.getNextFrame();
    final ui.Image userImage = userFrameInfo.image;

    // (3) Canvas로 두 이미지를 합성
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(size.toDouble(), size.toDouble()),
      ),
    );

    // 베이스 마커
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      image: baseImage,
    );

    // 사용자 이미지를 원형으로 합성
    final double userImageSize = size / 1.7;
    final Rect userImageRect = Rect.fromCircle(
      center: Offset(size / 2, size / 2.45),
      radius: userImageSize / 2,
    );

    canvas.save();

    // 원형 영역 설정
    canvas.clipPath(Path()..addOval(userImageRect));

    // 영역에다가만 사용자 이미지를 그리기
    canvas.drawImageRect(
      userImage,
      Rect.fromLTWH(
        0,
        0,
        userImage.width.toDouble(),
        userImage.height.toDouble(),
      ),
      userImageRect,
      Paint(),
    );
    canvas.restore();

    // 최종 PNG 바이트 생성
    final picture = recorder.endRecording();
    final ui.Image combinedImage = await picture.toImage(size, size);
    final ByteData? pngBytes =
        await combinedImage.toByteData(format: ui.ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }
}
