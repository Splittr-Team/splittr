import 'package:sky_storage_isar/sky_storage_isar.dart';

part 'pagination_metadata_isar_model.g.dart';

@collection
class PaginationMetadataIsarModel with IsarCacheable {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  @Enumerated(EnumType.name)
  FeatureCacheKey? featureKey;

  String? nextCursor;
  bool hasMore = false;
}

enum FeatureCacheKey {
  groups(ttl: Duration(minutes: 15)),
  expenses(ttl: Duration(minutes: 5)),
  friends(ttl: Duration(minutes: 30)),
  notifications(ttl: Duration(minutes: 10));

  const FeatureCacheKey({required this.ttl});

  final Duration ttl;
}
