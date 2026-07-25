import 'package:sky_storage_isar/sky_storage_isar.dart';

part 'expense_isar_model.g.dart';

@collection
class ExpenseIsarModel with IsarCacheable {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? id;

  String? description;
  double? amount;
  String? currency;
  String? paidBy;
  String? createdBy;
  bool? isPayment;
  @Index()
  DateTime? spentAt;
  String? category;
  String? groupId;
}
