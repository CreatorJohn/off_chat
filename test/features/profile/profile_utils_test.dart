import 'package:flutter_test/flutter_test.dart';
import 'package:off_chat/src/features/profile/domain/profile_utils.dart';

void main() {
  group('ProfileUtils Tests', () {
    test('generateProfileHash should be deterministic', () {
      const username = 'Alex Sterling';
      const path = '/path/to/image.jpg';

      final hash1 = ProfileUtils.generateProfileHash(username, path);
      final hash2 = ProfileUtils.generateProfileHash(username, path);

      expect(hash1, equals(hash2));
    });

    test('generateProfileHash should change when username changes', () {
      const path = '/path/to/image.jpg';

      final hash1 = ProfileUtils.generateProfileHash('User1', path);
      final hash2 = ProfileUtils.generateProfileHash('User2', path);

      expect(hash1, isNot(equals(hash2)));
    });

    test('generateProfileHash should handle null path', () {
      const username = 'Alex Sterling';

      final hash = ProfileUtils.generateProfileHash(username, null);
      expect(hash, isA<int>());
    });
  });
}
