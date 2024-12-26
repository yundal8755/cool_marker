# [Flutter] 나만의 Google Map Marker 만들기
![velog 썸네일](https://github.com/user-attachments/assets/851e1de8-d45b-43b3-b39d-68d5b3326a34)

<br>

## 1️⃣ 소개
해당 소스코드는 Google Maps 위에 `베이스 마커 이미지`와 `사용자 첨부 이미지`를 합성하여 **Custom Marker**를 적용했습니다.

<br>

<주요 과정>
1. 베이스 마커 이미지와 사용자 이미지를 불러오기
2. `Canvas`를 활용해 두 이미지를 합성
3. 합성 이미지를 `BitmapDescriptor`로 변환하여 Google Maps에 표시

<br>

![image](https://github.com/user-attachments/assets/7cbc8025-4c58-4a39-8bca-40d90ca25ae4)

이를 통해 나만의 개성 있는 Custom Marker를 구현할 수 있습니다.

<br>

## 2️⃣ Google Maps API 키 설정
저는 fvm 3.22.2 버전을 사용하여 만들었습니다. 
<br>
이를 참고하여 pubspec.yaml에 `google_maps_flutter` 패키지를 추가하고 플랫폼별 설정을 하시면 됩니다.

<br>

### 2-1. iOS 설정
iOS 프로젝트에서는 Google Maps API 키를 아래 위치에 추가합니다.
1. **`AppDelegate.swift`** 파일 열기
2. `GMSServices.provideAPIKey`에 API 키 추가

```dart
import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("GoogleMapKey") // 여기에 Google Maps API 키를 입력
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

```

<br>

### 2-2. Android 설정
Android 프로젝트에서는 Google Maps API 키를 아래 위치에 추가합니다.
1. **`android/app/src/main/AndroidManifest.xml`** 파일 열기
2. `<meta-data>` 태그에 API 키 추가

```dart
<application>
    <!-- Google Maps API 키 추가 -->
    <meta-data
        android:name="com.google.android.maps.v2.API_KEY"
        android:value="GoogleMapKey" /> <!-- 여기에 Google Maps API 키를 입력 -->
</application>
```
