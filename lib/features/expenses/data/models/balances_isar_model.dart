import 'package:sky_storage_isar/sky_storage_isar.dart';

part 'balances_isar_model.g.dart';

@collection
class BalancesIsarModel with IsarCacheable {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? groupId;

  List<UserBalanceIsarModel>? balances;
  List<SettlementIsarModel>? settlements;
  DateTime? updatedAt;
}

@embedded
class UserBalanceIsarModel {
  String? userId;
  String? userName;
  double? netBalance;
  String? currency;
}

@embedded
class SettlementIsarModel {
  double? amount;
  String? fromUserId;
  String? fromUserName;
  String? toUserId;
  String? toUserName;
  String? currency;
}
