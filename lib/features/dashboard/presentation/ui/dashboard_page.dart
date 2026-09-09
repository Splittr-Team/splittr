import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/activities/domain/entities/activity.dart';
import 'package:splittr/features/activities/presentation/ui/widgets/activity_item_card.dart';
import 'package:splittr/features/app_config/domain/stores/app_config_store.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:splittr/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:splittr/features/dashboard/presentation/ui/widgets/quick_actions_bar.dart';
import 'package:splittr/features/dashboard/presentation/ui/widgets/total_balance_card.dart';
import 'package:splittr/features/expenses/domain/entities/expense.dart';
import 'package:splittr/features/expenses/presentation/ui/widgets/expense_card.dart';
import 'package:splittr/features/expenses/presentation/ui/widgets/expenses_shimmer_list.dart';
import 'package:splittr/utils/extensions/extensions.dart';

part 'dashboard_form.dart';

class DashboardPage extends BasePage<DashboardBloc, DashboardState> {
  const DashboardPage({super.key});

  @override
  DashboardBloc createBloc() => getIt<DashboardBloc>()..started(noParams);

  @override
  Widget buildPage(BuildContext context) {
    return const Scaffold(
      body: _DashboardForm(),
    );
  }
}
