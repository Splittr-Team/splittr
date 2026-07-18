import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/core/app_config/i_app_config.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/presentation/blocs/group_details/group_details_bloc.dart';
import 'package:splittr/utils/extensions/extensions.dart';

part 'group_details_form.dart';

class GroupDetailsPage extends BasePage<GroupDetailsBloc, GroupDetailsState> {
  const GroupDetailsPage({required this.args, super.key});

  final Map<String, dynamic>? args;

  @override
  GroupDetailsBloc createBloc() =>
      getIt<GroupDetailsBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    final group = args?['group'] as Group?;
    return Scaffold(body: _GroupDetailsForm(group: group!));
  }
}
