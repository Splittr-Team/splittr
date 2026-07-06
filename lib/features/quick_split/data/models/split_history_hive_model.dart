import 'package:hive_ce/hive.dart';
import 'package:splittr/features/quick_split/domain/entities/split_history.dart';

part 'split_history_hive_model.g.dart';

@HiveType(
  typeId: 0,
) // IMPORTANT: If you add more models later, increment this ID
class SplitHistoryHiveModel extends HiveObject {
  SplitHistoryHiveModel({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.individualShares,
    required this.createdAt,
  });

  factory SplitHistoryHiveModel.fromEntity(SplitHistory entity) {
    return SplitHistoryHiveModel(
      id: entity.id,
      title: entity.title,
      totalAmount: entity.totalAmount,
      individualShares: entity.individualShares,
      createdAt: entity.createdAt,
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double totalAmount;

  @HiveField(3)
  final Map<String, double> individualShares;

  @HiveField(4)
  final DateTime createdAt;

  SplitHistory toEntity() {
    return SplitHistory(
      id: id,
      title: title,
      totalAmount: totalAmount,
      individualShares: individualShares,
      createdAt: createdAt,
    );
  }
}
