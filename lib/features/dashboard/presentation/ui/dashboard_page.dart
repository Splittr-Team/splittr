import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/dashboard/presentation/blocs/dashboard_bloc.dart';

part 'dashboard_form.dart';

class DashboardPage extends BasePage<DashboardBloc, DashboardState> {
  const DashboardPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  DashboardBloc createBloc() => getIt<DashboardBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    return const Scaffold(
      body: _DashboardForm(),
    );
  }
}
