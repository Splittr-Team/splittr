import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/groups/presentation/blocs/groups_bloc.dart';
import 'package:splittr/features/groups/presentation/ui/widgets/create_group_bottom_sheet.dart';
import 'package:splittr/utils/bloc_utils/bloc_utils.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Groups'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGroupSheet(context),
        child: const Icon(Icons.add),
      ),
      body: const _GroupsForm(),
    );
  }

  Future<void> _showCreateGroupSheet(BuildContext context) async {
    final groupsBloc = getBloc<GroupsBloc>(context);
    await AppBottomSheet.show<void>(
      context: context,
      child: BlocProvider.value(
        value: groupsBloc,
        child: const CreateGroupBottomSheet(),
      ),
    );
  }
}
