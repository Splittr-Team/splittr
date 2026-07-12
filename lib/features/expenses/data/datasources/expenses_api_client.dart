import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sky_network/sky_network.dart';
import 'package:splittr/features/expenses/data/models/balances_model.dart';
import 'package:splittr/features/expenses/data/models/create_expense_payload.dart';
import 'package:splittr/features/expenses/data/models/expense_details_model.dart';
import 'package:splittr/features/expenses/data/models/settle_expense_payload.dart';

part 'expenses_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: '/v1')
abstract class ExpensesApiClient {
  @factoryMethod
  factory ExpensesApiClient(Dio dio) = _ExpensesApiClient;

  @POST('/expenses')
  Future<ExpenseDetailsModel> createExpense(
    @Body() CreateExpensePayload body,
  );

  @GET('/expenses/{id}')
  Future<ExpenseDetailsModel> getExpenseDetails(
    @Path('id') String id,
  );

  @POST('/expenses/settle')
  Future<ExpenseDetailsModel> settleExpense(
    @Body() SettleExpensePayload body,
  );

  @GET('/balances')
  Future<BalancesModel> getBalances({
    @Query('groupId') String? groupId,
    @Query('simplified') bool? simplified,
  });
}
