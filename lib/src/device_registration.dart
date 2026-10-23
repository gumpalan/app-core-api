import 'dart:convert';
import 'api_client.dart';

enum DeviceStatus { pending, approved, revoked, unknown }

class RegistrationResult {
  final String deviceId;
  final DeviceStatus status;

  const RegistrationResult({
    required this.deviceId,
    required this.status,
  });
}

/// Helper untuk alur pendaftaran perangkat ke svc-auth (/auth/v1/register).
class DeviceRegistration {
  final ApiClient apiClient;

  DeviceRegistration({required this.apiClient});

  /// Mendaftarkan perangkat baru menggunakan nama dan kunci publik.
  Future<RegistrationResult> register({
    required String deviceName,
    required String publicKeyPem,
  }) async {
    final response = await apiClient.post(
      '/auth/v1/register',
      body: {
        'name': deviceName,
        'publicKey': publicKeyPem,
      },
    );

    if (response.statusCode == 202) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return RegistrationResult(
        deviceId: json['deviceId'] as String? ?? '',
        status: _parseStatus(json['status'] as String?),
      );
    }

    throw Exception('Pendaftaran perangkat gagal dengan kode: ${response.statusCode}');
  }

  /// Mengecek status persetujuan perangkat ke svc-auth.
  Future<DeviceStatus> checkStatus(String deviceId) async {
    final response = await apiClient.get('/auth/v1/register/$deviceId/status');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return _parseStatus(json['status'] as String?);
    }

    return DeviceStatus.unknown;
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
