import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/groups/presentation/blocs/create_group/create_group_bloc.dart';
import 'package:splittr/utils/extensions/l10n_extensions.dart';

class CreateGroupBottomSheet extends StatelessWidget {
  const CreateGroupBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateGroupBloc>(),
      child: BlocListener<CreateGroupBloc, CreateGroupState>(
        listener: (context, state) => switch (state) {
          OnCreateGroupSuccess _ => RouteHandler.pop<void>(context),
          _ => () {},
        },
        child: const _BottomSheetBody(),
      ),
    );
  }
}

class _BottomSheetBody extends StatelessWidget {
  const _BottomSheetBody();

  @override
  Widget build(BuildContext context) {
    return AppScrollView(
      mainAxisSize: .min,
      children: [
        Text(
          context.strings.createGroup,
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          labelText: context.strings.groupName,
          onChanged: (groupName) => getBloc<CreateGroupBloc>(
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
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          labelText: context.strings.groupDescription,
          onChanged: (groupDescription) => getBloc<CreateGroupBloc>(
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
        const SizedBox(height: AppSpacing.lg),
        BlocSelector<CreateGroupBloc, CreateGroupState, bool>(
          selector: (state) =>
              state.store.groupName.trim().isNotEmpty &&
              state.store.groupDescription.trim().isNotEmpty,
          builder: (context, isValid) {
            return AppButton.primary(
              text: context.strings.createGroup,
              // TODO(Chaitanya): add loading condition
              onPressed: isValid
                  ? () => getBloc<CreateGroupBloc>(
                      context,
                    ).createGroupButtonClicked()
                  : null,
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
