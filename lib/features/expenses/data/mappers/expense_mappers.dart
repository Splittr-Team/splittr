import 'package:sky_utils/sky_utils.dart';
import 'package:splittr/features/expenses/data/models/balances_model.dart';
import 'package:splittr/features/expenses/data/models/expense_details_model.dart';
import 'package:splittr/features/expenses/data/models/expense_isar_model.dart';
import 'package:splittr/features/expenses/data/models/expense_model.dart';
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
    final parsedSplitType = SplitType.values.byNameOrNull(splitType);

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
      SplitType.equal || null => Split.equal(
        userId: userId,
        amount: amount,
        name: name,
        email: email,
        phone: phone,
      ),
    };
  }

  SplitIsarModel toIsar() => SplitIsarModel()
    ..userId = userId
    ..amount = amount.toDouble()
    ..splitType = splitType
    ..splitValue = splitValue?.toDouble()
    ..name = name
    ..email = email
    ..phone = phone;
}

extension SplitIsarModelX on SplitIsarModel {
  Split toDomain() {
    final parsedSplitType = SplitType.values.byNameOrNull(splitType);

    return switch (parsedSplitType) {
      SplitType.exact => Split.exact(
        userId: userId ?? '',
        amount: amount ?? 0,
        splitValue: splitValue ?? 0,
        name: name ?? '',
        email: email,
        phone: phone,
      ),
      SplitType.percentage => Split.percentage(
        userId: userId ?? '',
        amount: amount ?? 0,
        splitValue: splitValue ?? 0,
        name: name ?? '',
        email: email,
        phone: phone,
      ),
      SplitType.equal || null => Split.equal(
        userId: userId ?? '',
        amount: amount ?? 0,
        name: name ?? '',
        email: email,
        phone: phone,
      ),
    };
  }
}

extension SplitIsarModelListX on List<SplitIsarModel> {
  List<Split> toDomain() => map((s) => s.toDomain()).toList();
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
      splitType: SplitType.values.byNameOrNull(expense.splitType),
    );
  }

  ExpenseIsarModel toIsar() => ExpenseIsarModel()
    ..id = expense.id
    ..description = expense.description
    ..amount = expense.amount.toDouble()
    ..currency = expense.currency
    ..paidBy = expense.paidBy
    ..createdBy = expense.createdBy
    ..isPayment = expense.isPayment
    ..spentAt = expense.spentAt
    ..category = expense.category
    ..groupId = expense.groupId
    ..splitType = expense.splitType
    ..splits = splits.toIsar();
}

extension SplitModelListX on List<SplitModel> {
  List<Split> toDomain() {
    return map((s) => s.toDomain()).toList();
  }

  List<SplitIsarModel> toIsar() {
    return map((s) => s.toIsar()).toList();
  }
}

extension UserBalanceModelX on UserBalanceModel {
  UserBalance toDomain() => UserBalance(
    userId: userId,
    userName: userName,
    netBalance: netBalance,
    currency: currency,
  );
}

extension SettlementModelX on SettlementModel {
  Settlement toDomain() => Settlement(
    amount: amount,
    fromUserId: fromUserId,
    fromUserName: fromUserName,
    toUserId: toUserId,
    toUserName: toUserName,
    currency: currency,
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

extension ExpenseModelX on ExpenseModel {
  Expense toDomain() => Expense(
    id: id,
    description: description,
    amount: amount,
    currency: currency,
    paidBy: paidBy,
    createdBy: createdBy,
    isPayment: isPayment,
    spentAt: spentAt,
    splits: const [],
    category: category,
    groupId: groupId,
    splitType: SplitType.values.byNameOrNull(splitType),
  );

  ExpenseIsarModel toIsar() => ExpenseIsarModel()
    ..id = id
    ..description = description
    ..amount = amount.toDouble()
    ..currency = currency
    ..paidBy = paidBy
    ..createdBy = createdBy
    ..isPayment = isPayment
    ..spentAt = spentAt
    ..category = category
    ..groupId = groupId
    ..splitType = splitType;
}

extension ExpenseModelListX on List<ExpenseModel> {
  List<Expense> toDomain() => map((e) => e.toDomain()).toList();

  List<ExpenseIsarModel> toIsar() => map((e) => e.toIsar()).toList();
}

extension ExpenseIsarModelX on ExpenseIsarModel {
  Expense toDomain() => Expense(
    id: id ?? '',
    description: description ?? '',
    amount: amount ?? 0,
    currency: currency ?? 'USD',
    paidBy: paidBy ?? '',
    createdBy: createdBy ?? '',
    isPayment: isPayment ?? false,
    spentAt: spentAt ?? DateTime.now(),
    splits: splits?.toDomain() ?? const [],
    category: category,
    groupId: groupId,
    splitType: SplitType.values.byNameOrNull(splitType),
  );
}

extension ExpenseIsarModelListX on List<ExpenseIsarModel> {
  List<Expense> toDomain() => map((e) => e.toDomain()).toList();
}
