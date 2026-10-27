import 'dart:convert';

import 'api_client.dart';

/// Status siklus hidup pendaftaran perangkat.
enum DeviceStatus { pending, approved, revoked, unknown }

/// Hasil respon pendaftaran perangkat baru.
class RegistrationResult {
  final String deviceId;
  final DeviceStatus status;

  const RegistrationResult({required this.deviceId, required this.status});
}

/// Detail status persetujuan dan metadata perangkat dari server autentikasi.
class DeviceStatusResult {
  final String deviceId;
  final String? name;
  final DeviceStatus status;
  final DateTime? registeredAt;
  final String? token;

  const DeviceStatusResult({
    required this.deviceId,
    this.name,
    required this.status,
    this.registeredAt,
    this.token,
  });
}

/// Klien helper untuk alur pendaftaran perangkat pada endpoint `/auth/v1/register`.
class DeviceRegistration {
  final ApiClient apiClient;

  DeviceRegistration({required this.apiClient});

  /// Mendaftarkan perangkat baru menggunakan nama perangkat, kunci publik, dan hardware fingerprint.
  /// Bersifat idempoten: jika [fingerprint] telah terdaftar sebelumnya, server mengembalikan data
  /// perangkat yang telah ada tanpa membuat entitas duplikat.
  Future<RegistrationResult> register({
    required String deviceName,
    required String publicKeyPem,
    String fingerprint = '',
  }) async {
    final response = await apiClient.post(
      '/auth/v1/register',
      body: {
        'name': deviceName,
        'publicKey': publicKeyPem,
        if (fingerprint.isNotEmpty) 'fingerprint': fingerprint,
      },
    );

    if (response.statusCode == 202) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return RegistrationResult(
        deviceId: json['deviceId'] as String? ?? '',
        status: _parseStatus(json['status'] as String?),
      );
    }

    throw Exception(
      'Pendaftaran perangkat gagal dengan kode status: ${response.statusCode}',
    );
  }

  /// Memverifikasi status persetujuan perangkat pada server autentikasi.
  Future<DeviceStatusResult> checkStatus(String deviceId) async {
    final response = await apiClient.get('/auth/v1/register/$deviceId/status');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final createdAtMs = json['createdAt'] as int?;
      return DeviceStatusResult(
        deviceId: json['deviceId'] as String? ?? deviceId,
        name: json['name'] as String?,
        status: _parseStatus(json['status'] as String?),
        registeredAt: createdAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch(createdAtMs * 1000)
            : null,
        token: json['token'] as String?,
      );
    }

    return DeviceStatusResult(deviceId: deviceId, status: DeviceStatus.unknown);
  }

  DeviceStatus _parseStatus(String? status) {
    switch (status) {
      case 'pending':
        return DeviceStatus.pending;
      case 'approved':
        return DeviceStatus.approved;
      case 'revoked':
        return DeviceStatus.revoked;
      default:
        return DeviceStatus.unknown;
    }
  }
}
