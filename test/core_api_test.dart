import 'package:core_api/core_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('InMemoryTokenStorage read and write', () async {
    final storage = InMemoryTokenStorage();
    expect(await storage.readToken(), isNull);

    await storage.writeToken('test-token-123');
    expect(await storage.readToken(), equals('test-token-123'));

    await storage.deleteToken();
    expect(await storage.readToken(), isNull);
  });

  test('DeviceRegistration register and checkStatus', () async {
    final mockClient = MockClient((request) async {
      if (request.url.path == '/auth/v1/register') {
        return http.Response(
          '{"deviceId":"dev_mock123","status":"pending"}',
          202,
        );
      }
      if (request.url.path == '/auth/v1/register/dev_mock123/status') {
        return http.Response(
          '{"deviceId":"dev_mock123","status":"approved","token":"tok_mock_abc"}',
          200,
        );
      }
      return http.Response('Not Found', 404);
    });

    final storage = InMemoryTokenStorage();
    final apiClient = ApiClient(
      baseUrl: 'http://127.0.0.1:8001',
      tokenStorage: storage,
      client: mockClient,
    );

    final reg = DeviceRegistration(apiClient: apiClient);
    final regResult = await reg.register(
      deviceName: 'My Phone',
      publicKeyPem: 'pubkey',
    );
    expect(regResult.deviceId, equals('dev_mock123'));
    expect(regResult.status, equals(DeviceStatus.pending));

    final statusResult = await reg.checkStatus(regResult.deviceId);
    expect(statusResult.status, equals(DeviceStatus.approved));
    expect(statusResult.token, equals('tok_mock_abc'));
  });
}
