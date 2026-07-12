import 'package:recase/recase.dart';
import 'package:splittr/features/expenses/data/models/balances_model.dart';
import 'package:splittr/features/expenses/data/models/expense_details_model.dart';
import 'package:splittr/features/expenses/data/models/input_split_payload.dart';
import 'package:splittr/features/expenses/data/models/settlement_model.dart';
import 'package:splittr/features/expenses/data/models/split_model.dart';
import 'package:splittr/features/expenses/data/models/user_balance_model.dart';
import 'package:splittr/features/expenses/domain/entities/balances.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/domain/entities/input_split.dart';
import 'package:splittr/features/expenses/domain/entities/settlement.dart';
import 'package:splittr/features/expenses/domain/entities/split.dart';
import 'package:splittr/features/expenses/domain/entities/split_type.dart';
import 'package:splittr/features/expenses/domain/entities/user_balance.dart';

extension SplitModelX on SplitModel {
  Split toDomain() {
    final parsedSplitType = SplitType.values.byName(splitType.camelCase);

    return switch (parsedSplitType) {
      SplitType.exact => Split.exact(
        userId: userId,
        amount: amount,
        splitValue: splitValue ?? 0,
        name: name,
        email: email,
        phone: phone,
      ),
      SplitType.percentage => Split.percentage(
        userId: userId,
        amount: amount,
        splitValue: splitValue ?? 0,
        name: name,
        email: email,
        phone: phone,
      ),
      SplitType.equal => Split.equal(
        userId: userId,
        amount: amount,
        name: name,
        email: email,
        phone: phone,
      ),
    };
  }
}

extension InputSplitX on InputSplit {
  InputSplitPayload toModel() {
    return switch (this) {
      EqualInputSplit(:final userId) => InputSplitPayload(userId: userId),
      ExactInputSplit(:final userId, :final amount) => InputSplitPayload(
        userId: userId,
        amount: amount,
      ),
      PercentageInputSplit(:final userId, :final percentage) =>
        InputSplitPayload(
          userId: userId,
          percentage: percentage,
        ),
    };
  }
}

extension InputSplitListX on List<InputSplit> {
  List<InputSplitPayload> toModel() {
    return map((s) => s.toModel()).toList();
  }
}

extension ExpenseDetailsModelX on ExpenseDetailsModel {
  Expense toDomain() {
    return Expense(
      id: expense.id,
      description: expense.description,
      amount: expense.amount,
      currency: expense.currency,
      paidBy: expense.paidBy,
      createdBy: expense.createdBy,
      isPayment: expense.isPayment,
      spentAt: expense.spentAt,
      splits: splits.toDomain(),
      category: expense.category,
      groupId: expense.groupId,
    );
  }
}

extension SplitModelListX on List<SplitModel> {
  List<Split> toDomain() {
    return map((s) => s.toDomain()).toList();
  }
}

extension UserBalanceModelX on UserBalanceModel {
  UserBalance toDomain() => UserBalance(
    userId: userId,
    userName: userName,
    netBalance: netBalance,
  );
}

extension SettlementModelX on SettlementModel {
  Settlement toDomain() => Settlement(
    amount: amount,
    fromUserId: fromUserId,
    fromUserName: fromUserName,
    toUserId: toUserId,
    toUserName: toUserName,
  );
}

extension BalancesModelX on BalancesModel {
  Balances toDomain() => Balances(
    balances: balances.toDomain(),
    settlements: settlements.toDomain(),
  );
}

extension UserBalanceModelListX on List<UserBalanceModel> {
  List<UserBalance> toDomain() {
    return map((b) => b.toDomain()).toList();
  }
}

extension SettlementModelListX on List<SettlementModel> {
  List<Settlement> toDomain() {
    return map((s) => s.toDomain()).toList();
  }
}
