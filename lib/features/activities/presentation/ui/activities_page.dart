import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/activities/presentation/blocs/activities/activities_bloc.dart';
import 'package:splittr/features/activities/presentation/ui/widgets/activities_empty_state.dart';
import 'package:splittr/features/activities/presentation/ui/widgets/activities_error_state.dart';
import 'package:splittr/features/activities/presentation/ui/widgets/activities_list_view.dart';
import 'package:splittr/features/activities/presentation/ui/widgets/activities_shimmer_list.dart';

part 'activities_form.dart';

/// Page displaying activity feed across groups and expenses.
class ActivitiesPage extends BasePage<ActivitiesBloc, ActivitiesState> {
  const ActivitiesPage({super.key});

  @override
  ActivitiesBloc createBloc() => getIt<ActivitiesBloc>()..started(noParams);

  @override
  Widget buildPage(BuildContext context) {
    return const Scaffold(
      appBar: AppTopBar(
        title: 'Activity',
      ),
      body: _ActivitiesForm(),
    );
  }
}
