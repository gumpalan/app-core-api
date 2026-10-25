/// Kontrak antarmuka penyimpanan token autentikasi perangkat.
abstract class TokenStorage {
  /// Membaca token otorisasi tersimpan, atau mengembalikan null jika belum ada.
  Future<String?> readToken();

  /// Menyimpan token otorisasi.
  Future<void> writeToken(String token);

  /// Menghapus token otorisasi dari media penyimpanan.
  Future<void> deleteToken();
}

/// Implementasi in-memory sederhana untuk pengujian otomatis.
class InMemoryTokenStorage implements TokenStorage {
  String? _token;

  @override
  Future<String?> readToken() async => _token;

  @override
  Future<void> writeToken(String token) async {
    _token = token;
  }

  @override
  Future<void> deleteToken() async {
    _token = null;
  }
}
