import 'package:shared_preferences/shared_preferences.dart';

import 'token_storage.dart';

/// Implementasi [TokenStorage] berbasis [SharedPreferences] untuk persistensi lokal.
/// Menyimpan token autentikasi sesi dan pengenal unik perangkat (device ID).
class SharedPrefsTokenStorage implements TokenStorage {
  static const _kToken = 'gumpalan_token';
  static const _kDeviceId = 'gumpalan_device_id';

  @override
  Future<String?> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  @override
  Future<void> writeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, token);
  }

  @override
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
  }

  /// Menyimpan ID perangkat hasil pendaftaran.
  Future<void> writeDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDeviceId, deviceId);
  }

  /// Membaca ID perangkat yang tersimpan (mengembalikan null jika belum terdaftar).
  Future<String?> readDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kDeviceId);
  }

  /// Menghapus seluruh token dan identitas perangkat dari media penyimpanan lokal.
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kDeviceId);
  }
}
