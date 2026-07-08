import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/features/groups/presentation/blocs/groups_bloc.dart';
import 'package:splittr/utils/bloc_utils/bloc_utils.dart';
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class CreateGroupBottomSheet extends StatefulWidget {
  const CreateGroupBottomSheet({super.key});

  @override
  State<CreateGroupBottomSheet> createState() => _CreateGroupBottomSheetState();
}

class _CreateGroupBottomSheetState extends State<CreateGroupBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupsBloc, GroupsState>(
      listener: (context, state) {
        if (state is OnGroupsUpdate) {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.strings.createGroup,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AppTextField(
              labelText: context.strings.groupName,
              onChanged: (groupName) => getBloc<GroupsBloc>(
                context,
              ).groupNameChanged(groupName: groupName),
              validator: (groupName) {
                if (groupName?.isNotEmpty ?? false) {
                  return Name(
                    groupName ?? '',
                  ).value.fold((failure) => failure.message, (_) => null);
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              labelText: context.strings.groupDescription,
              onChanged: (groupDescription) => getBloc<GroupsBloc>(
                context,
              ).groupDescriptionChanged(groupDescription: groupDescription),
              validator: (groupDescription) {
                if (groupDescription?.isNotEmpty ?? false) {
                  return Name(
                    groupDescription ?? '',
                  ).value.fold((failure) => failure.message, (_) => null);
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            BlocSelector<GroupsBloc, GroupsState, bool>(
              selector: (state) =>
                  (state.store.groupName?.isNotEmpty ?? false) &&
                  (state.store.groupDescription?.isNotEmpty ?? false),
              builder: (context, isValid) {
                return AppButton.primary(
                  text: context.strings.createGroup,
                  onPressed: isValid
                      ? () => getBloc<GroupsBloc>(context).createGroupClicked()
                      : null,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
