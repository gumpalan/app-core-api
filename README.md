# core_api

Package Dart fondasi untuk super app Gumpalan: klien HTTP terautentikasi, antarmuka penyimpanan token, dan helper alur pendaftaran perangkat.

## Struktur

```
lib/
├── core_api.dart
└── src/
    ├── api_client.dart            # HTTP client dengan injeksi Bearer token otomatis
    ├── device_registration.dart   # Permintaan register dan cek status perangkat
    └── token_storage.dart         # Kontrak TokenStorage & InMemoryTokenStorage
```

## Penggunaan

```dart
final tokenStorage = InMemoryTokenStorage();
final apiClient = ApiClient(
  baseUrl: 'http://127.0.0.1:8080',
  tokenStorage: tokenStorage,
);

final registration = DeviceRegistration(apiClient: apiClient);
```

## Lisensi dan Dependensi

Lisensi repositori ini **belum ditentukan**.

### Dependensi Langsung:
- `http` (BSD-3-Clause) - Pustaka klien HTTP standar komunitas Dart.

### Memeriksa Lisensi:
Periksa berkas `pubspec.lock` atau gunakan perintah:
```bash
flutter pub pub run -- flutter pub deps
```
