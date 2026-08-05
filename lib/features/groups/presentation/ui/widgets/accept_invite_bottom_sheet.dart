import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/groups/presentation/blocs/join_group/join_group_cubit.dart';
import 'package:splittr/utils/extensions/extensions.dart';

class AcceptInviteBottomSheet extends StatefulWidget {
  const AcceptInviteBottomSheet({
    required this.code,
    super.key,
  });

  final String code;

  @override
  State<AcceptInviteBottomSheet> createState() =>
      _AcceptInviteBottomSheetState();
}

class _AcceptInviteBottomSheetState extends State<AcceptInviteBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<JoinGroupCubit>(
      create: (context) {
        final cubit = getIt<JoinGroupCubit>();
        unawaited(cubit.fetchGroupPreview(widget.code));
        return cubit;
      },
      child: BlocListener<JoinGroupCubit, JoinGroupState>(
        listener: (context, state) {
          switch (state) {
            case JoinGroupSuccess(:final group):
              RouteHandler.pop<void>(context);
              GroupDetailsRoute(
                groupId: group.id ?? '',
                group: group,
              ).pushReplacement(context);
            case JoinGroupFailure(:final failure):
              AppSnackBar.show(context, message: failure.message);
            case JoinGroupPreviewFailure(:final failure):
              AppSnackBar.show(context, message: failure.message);
            default:
              break;
          }
        },
        child: BlocBuilder<JoinGroupCubit, JoinGroupState>(
          builder: (context, state) {
            return switch (state) {
              JoinGroupPreviewLoading() => const SizedBox(
                height: 200,
                child: Center(
                  child: AppProgressIndicator.circular(),
                ),
              ),
              JoinGroupPreviewFailure() => Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.bodyMedium(context.strings.failedToLoadPreview),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AppButton.outlined(
                          text: context.strings.close,
                          onPressed: () => RouteHandler.pop<void>(context),
                        ),
                        AppButton.primary(
                          text: context.strings.retry,
                          onPressed: () => context
                              .read<JoinGroupCubit>()
                              .fetchGroupPreview(widget.code),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              JoinGroupPreviewSuccess(:final preview) => Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText.titleLarge(preview.name),
                    const SizedBox(height: AppSpacing.xs),
                    AppText.bodyMedium(
                      context.strings.invitedBy(preview.creatorName),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppText.bodyMedium(preview.description),
                    const SizedBox(height: AppSpacing.sm),
                    AppText.bodyMedium(
                      context.strings.membersCount(preview.memberCount),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton.text(
                          text: context.strings.decline,
                          onPressed: () => RouteHandler.pop<void>(context),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        AppButton.primary(
                          text: context.strings.acceptInvite,
                          onPressed: () => context
                              .read<JoinGroupCubit>()
                              .joinGroup(widget.code),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              JoinGroupLoading() => const SizedBox(
                height: 200,
                child: Center(
                  child: AppProgressIndicator.circular(),
                ),
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
