import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/features/expenses/data/models/settlement_model.dart';
import 'package:splittr/features/expenses/data/models/user_balance_model.dart';

part 'balances_model.g.dart';

@JsonSerializable()
class BalancesModel {
  const BalancesModel({
    required this.balances,
    this.directSettlements = const [],
    this.simplifiedSettlements = const [],
  });

  factory BalancesModel.fromJson(Map<String, dynamic> json) =>
      _$BalancesModelFromJson(json);

  final List<UserBalanceModel> balances;
  final List<SettlementModel> directSettlements;
  final List<SettlementModel> simplifiedSettlements;
}
