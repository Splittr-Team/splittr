import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/quick_split/domain/entities/split_history.dart';

part 'split_history_isar_model.g.dart';

@collection
class SplitHistoryIsarModel {
  SplitHistoryIsarModel();

  factory SplitHistoryIsarModel.fromEntity(SplitHistory entity) {
    return SplitHistoryIsarModel()
      ..id = entity.id
      ..title = entity.title
      ..totalAmount = entity.totalAmount
      ..individualShares = entity.individualShares.entries
          .map(
            (e) => ShareIsarModel()
              ..userId = e.key
              ..shareAmount = e.value,
          )
          .toList()
      ..createdAt = entity.createdAt;
  }

  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String title;
  late double totalAmount;

  late List<ShareIsarModel> individualShares;

  late DateTime createdAt;

  SplitHistory toEntity() {
    final sharesMap = {
      for (final share in individualShares) share.userId: share.shareAmount,
    };
    return SplitHistory(
      id: id,
      title: title,
      totalAmount: totalAmount,
      individualShares: sharesMap,
      createdAt: createdAt,
    );
  }
}

@embedded
class ShareIsarModel {
  ShareIsarModel();

  late String userId;
  late double shareAmount;
}
