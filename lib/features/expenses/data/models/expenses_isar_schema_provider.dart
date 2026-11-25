import 'package:sky_storage_isar/sky_storage_isar.dart';
import 'package:splittr/features/expenses/data/models/balances_isar_model.dart';
import 'package:splittr/features/expenses/data/models/expense_isar_model.dart';

class ExpensesIsarSchemaProvider implements IsarSchemaProvider {
  const ExpensesIsarSchemaProvider();

  @override
  List<CollectionSchema<dynamic>> get schemas => [
    ExpenseIsarModelSchema,
    BalancesIsarModelSchema,
  ];
}
