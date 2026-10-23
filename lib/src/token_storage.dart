/// Kontrak penyimpanan token autentikasi perangkat (bisa diimplementasikan dengan secure storage atau in-memory).
abstract class TokenStorage {
  Future<String?> readToken();
  Future<void> writeToken(String token);
  Future<void> deleteToken();
}

/// Implementasi in-memory sederhana untuk pengujian dan scaffold.
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
