# core_api

Paket fondasi Dart untuk ekosistem super app Gumpalan yang menyediakan abstraksi klien HTTP terautentikasi, kontrak antarmuka persistensi sesi kredensial, dan klien komunikasi pendaftaran perangkat.

Paket ini dirancang mandiri tanpa ketergantungan langsung pada antarmuka pengguna Flutter, sehingga dapat digunakan pada berbagai modul klien.

---

## Struktur Direktori

```text
app-core-api/
├── lib/
│   ├── core_api.dart                 # Export publik paket
│   └── src/
│       ├── api_client.dart           # HTTP client dengan auto-injection Bearer token
│       ├── device_registration.dart  # Klien pendaftaran & verifikasi status perangkat
│       ├── prefs_token_storage.dart  # Implementasi token storage berbasis SharedPreferences
│       └── token_storage.dart        # Kontrak antarmuka TokenStorage & InMemoryTokenStorage
└── test/
    └── core_api_test.dart            # Pengujian unit untuk token storage dan klien pendaftaran
```

---

## Komponen Utama

### 1. `ApiClient`
Membungkus klien HTTP standar dengan kemampuan otomatis:
- Menyisipkan header `Authorization: Bearer <token>` pada setiap permintaan jika token tersedia di `TokenStorage`.
- Menangani deserialisasi dan pengelolaan galat jaringan secara konsisten.

### 2. `TokenStorage` & `SharedPrefsTokenStorage`
- `TokenStorage`: Antarmuka abstrak untuk pembacaan, penulisan, dan penghapusan token sesi.
- `SharedPrefsTokenStorage`: Implementasi persistensi berbasis pustaka platform `SharedPreferences` yang juga menyimpan pengenal unik perangkat (`deviceId`).
- `InMemoryTokenStorage`: Implementasi penyimpanan sementara dalam memori untuk kebutuhan pengujian unit yang terisolasi.

### 3. `DeviceRegistration`
Klien helper untuk berinteraksi dengan API pendaftaran perangkat pada `svc-auth`:
- `register({deviceName, publicKeyPem, fingerprint})`: Mendaftarkan perangkat baru atau mengambil identitas yang sudah terdaftar berdasarkan hardware fingerprint (idempoten).
- `checkStatus(deviceId)`: Memeriksa status persetujuan perangkat (`pending`, `approved`, `revoked`, atau `unknown`) beserta informasi token sesi jika telah disetujui.

---

## Contoh Penggunaan

```dart
import 'package:core_api/core_api.dart';

// Inisialisasi media penyimpanan kredensial
final tokenStorage = SharedPrefsTokenStorage();

// Inisialisasi klien HTTP
final apiClient = ApiClient(
  baseUrl: 'http://192.168.1.12:8080',
  tokenStorage: tokenStorage,
);

// Inisialisasi alur pendaftaran perangkat
final registration = DeviceRegistration(apiClient: apiClient);

// Pendaftaran perangkat dengan hardware fingerprint
final result = await registration.register(
  deviceName: 'Ruang Kerja Laptop',
  publicKeyPem: '...',
  fingerprint: 'hardware_unique_id_string',
);

print('Device ID: ${result.deviceId}, Status: ${result.status}');
```

---

## Pengujian Otomatis

Jalankan rangkaian pengujian unit dengan perintah:

```bash
flutter test
```

---

## Lisensi dan Dependensi

- `http` (BSD-3-Clause) - Klien komunikasi protokol HTTP.
- `shared_preferences` (BSD-3-Clause) - Driver penyimpanan data lokal multi-platform.
