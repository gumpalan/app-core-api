import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

/// ApiClient adalah pembungkus HTTP client dengan penyisipan otomatis token bearer.
class ApiClient {
  final String baseUrl;
  final TokenStorage tokenStorage;
  final http.Client _client;

  ApiClient({
    required this.baseUrl,
    required this.tokenStorage,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Uri _resolveUri(String path) {
    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$cleanBase$cleanPath');
  }

  Future<Map<String, String>> _headers() async {
    final token = await tokenStorage.readToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<http.Response> get(String path) async {
    final uri = _resolveUri(path);
    final headers = await _headers();
    return _client.get(uri, headers: headers);
  }

  Future<http.Response> post(String path, {Map<String, dynamic>? body}) async {
    final uri = _resolveUri(path);
    final headers = await _headers();
    return _client.post(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  void close() {
    _client.close();
  }
}
