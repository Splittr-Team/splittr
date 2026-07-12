import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splittr/features/expenses/domain/entities/settlement.dart';
import 'package:splittr/features/expenses/domain/entities/user_balance.dart';

part 'balances.freezed.dart';

@freezed
class Balances with _$Balances {
  const Balances({
    required this.balances,
    required this.settlements,
  });

  @override
  final List<UserBalance> balances;
  @override
  final List<Settlement> settlements;
}
