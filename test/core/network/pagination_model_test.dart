import 'package:flutter_test/flutter_test.dart';
import 'package:splittr/core/network/pagination_model.dart';

void main() {
  group('PaginationModel', () {
    test('should deserialize correct from JSON', () {
      final json = {
        'hasMore': true,
        'nextCursor': 'cursor-123',
      };
      final model = PaginationModel.fromJson(json);
      expect(model.hasMore, true);
      expect(model.nextCursor, 'cursor-123');
    });
  });
}
