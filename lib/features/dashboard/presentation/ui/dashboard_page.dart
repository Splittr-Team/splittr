import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/dashboard/presentation/blocs/dashboard_bloc.dart';

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
