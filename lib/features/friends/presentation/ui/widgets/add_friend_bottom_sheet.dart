import 'package:flutter/material.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/friends/presentation/blocs/add_friend/add_friend_bloc.dart';
import 'package:splittr/utils/extensions/extensions.dart';

class AddFriendBottomSheet extends StatelessWidget {
  const AddFriendBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddFriendBloc>(),
      child: BlocListener<AddFriendBloc, AddFriendState>(
        listener: (context, state) {
          switch (state) {
            case OnAddFriendSuccess():
              AppSnackBar.show(
                context,
                message: context.strings.friendAddedSuccessfully,
              );
              RouteHandler.pop<void>(context);
            case OnFailure(:final failure):
              AppSnackBar.show(
                context,
                message: failure.message,
              );
            case _:
              break;
          }
        },
        child: const AddFriendBottomSheetBody(),
      ),
    );
  }
}

class AddFriendBottomSheetBody extends StatelessWidget {
  const AddFriendBottomSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFriendBloc, AddFriendState>(
      builder: (context, state) {
        final isLoading = state.store.loading;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              labelText: context.strings.emailOrPhone,
              hintText: context.strings.enterEmailOrPhone,
              enabled: !isLoading,
              onChanged: (value) => getBloc<AddFriendBloc>(
                context,
              ).emailOrPhoneChanged(emailOrPhone: value),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              text: context.strings.submit,
              onPressed:
                  state.store.emailOrPhone.trim().isNotEmpty && !isLoading
                  ? () => getBloc<AddFriendBloc>(context).submitButtonClicked()
                  : null,
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
    );
  }
}
