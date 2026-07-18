import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/router/route_paths.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/groups/presentation/blocs/join_group/join_group_cubit.dart';
import 'package:splittr/utils/extensions/extensions.dart';

class JoinGroupBottomSheet extends StatefulWidget {
  const JoinGroupBottomSheet({super.key});

  @override
  State<JoinGroupBottomSheet> createState() => _JoinGroupBottomSheetState();
}

class _JoinGroupBottomSheetState extends State<JoinGroupBottomSheet> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<JoinGroupCubit>(),
      child: BlocListener<JoinGroupCubit, JoinGroupState>(
        listener: (context, state) {
          switch (state) {
            case JoinGroupSuccess():
              RouteHandler.pop<void>(context);
              unawaited(
                RouteHandler.push<void>(
                  context,
                  RoutePaths.groupDetails,
                  extra: {'group': state.group},
                ),
              );
            case JoinGroupFailure(:final failure):
              AppSnackBar.show(context, message: failure.message);
            case _:
              break;
          }
        },
        child: BlocBuilder<JoinGroupCubit, JoinGroupState>(
          builder: (context, state) {
            final isLoading = state is JoinGroupLoading;

            return AppScrollView(
              mainAxisSize: .min,
              children: [
                Text(
                  context.strings.joinGroup,
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.strings.enterCode,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _codeController,
                  labelText: context.strings.groupCode,
                  enabled: !isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _codeController,
                  builder: (context, textValue, _) {
                    final isValid =
                        textValue.text.trim().isNotEmpty && !isLoading;

                    return AppButton.primary(
                      text: context.strings.joinGroup,
                      onPressed: isValid
                          ? () => context.read<JoinGroupCubit>().joinGroup(
                              inviteCode: _codeController.text.trim(),
                            )
                          : null,
                    );
                  },
                ),
                if (isLoading) ...[
                  const SizedBox(height: AppSpacing.md),
                  const Center(
                    child: AppProgressIndicator.circular(),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
              ],
            );
          },
        ),
      ),
    );
  }
}
