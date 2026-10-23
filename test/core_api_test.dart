import 'package:flutter_test/flutter_test.dart';
import 'package:core_api/core_api.dart';

void main() {
  test('InMemoryTokenStorage read and write', () async {
    final storage = InMemoryTokenStorage();
    expect(await storage.readToken(), isNull);

    await storage.writeToken('test-token-123');
    expect(await storage.readToken(), equals('test-token-123'));

    await storage.deleteToken();
    expect(await storage.readToken(), isNull);
  });
}
