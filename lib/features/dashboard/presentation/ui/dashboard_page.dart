import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:splittr/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:splittr/utils/bloc_utils/bloc_utils.dart';
import 'package:splittr/utils/extensions/extensions.dart';

part 'dashboard_form.dart';

class DashboardPage extends BasePage<DashboardBloc, DashboardState> {
  const DashboardPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  DashboardBloc createBloc() => getIt<DashboardBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: const _DashboardForm(),
      appBar: AppBar(),
      drawer: AppNavigationDrawer(
        selectedIndex: 0,
        onDestinationSelected: (value) {},
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                ),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppText.headlineMedium(
                      context.strings.appName,
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  ],
                ),
              ),
              AppListTile(
                leadingIcon: Icons.logout_rounded,
                title: context.strings.login,
                onTap: () {
                  getBloc<AuthBloc>(context).loggedOut();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
