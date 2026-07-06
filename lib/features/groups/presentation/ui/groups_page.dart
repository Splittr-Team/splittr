import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/groups/presentation/blocs/groups_bloc.dart';

part 'groups_form.dart';

class GroupsPage extends BasePage<GroupsBloc, GroupsState> {
  const GroupsPage({
    this.args,
    super.key,
  });
  final Map<String, dynamic>? args;

  @override
  GroupsBloc createBloc() => getIt<GroupsBloc>()..started(args: args);

  @override
  Widget buildPage(BuildContext context) {
    return const Scaffold(
      body: _GroupsForm(),
    );
  }
}
