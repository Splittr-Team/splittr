import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
import 'package:splittr/core/router/app_routes.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/app_config/domain/stores/app_config_store.dart';
import 'package:splittr/features/auth/presentation/blocs/auth_bloc.dart'
    hide OnFailure;
import 'package:splittr/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:splittr/features/profile/presentation/ui/widgets/currency_picker_bottom_sheet.dart';
import 'package:splittr/features/profile/presentation/ui/widgets/profile_header_card.dart';
import 'package:splittr/utils/extensions/extensions.dart';

part 'profile_form.dart';

class ProfilePage extends BasePage<ProfileBloc, ProfileState> {
  const ProfilePage({super.key});

  @override
  ProfileBloc createBloc() => getIt<ProfileBloc>()..started(noParams);

  @override
  bool showLoading(ProfileState state) => state.store.loading;

  @override
  void handleStateChange(BuildContext context, ProfileState state) {
    switch (state) {
      case OnAccountDeleted():
        AppSnackBar.show(
          context,
          message: 'Your account has been deleted.',
        );
      case OnDeleteAccountFailure(:final failure):
        final msg = failure.message;
        final isUnsettled = msg.toUpperCase().contains('UNSETTLED') ||
            msg.toLowerCase().contains('balance') ||
            msg.toLowerCase().contains('outstanding') ||
            msg.toLowerCase().contains('settle');
        if (isUnsettled) {
          unawaited(
            AppDialog.show<void>(
              context: context,
              title: 'Cannot Delete Account',
              description:
                  'You have outstanding balances in one or more groups. '
                  'Please settle all balances before proceeding.',
              actions: [
                AppButton.text(
                  onPressed: () {
                    RouteHandler.pop<void>(context);
                    const DashboardRoute().go(context);
                  },
                  text: 'Go to Balances',
                ),
                AppButton.text(
                  onPressed: () => RouteHandler.pop<void>(context),
                  text: 'OK',
                ),
              ],
            ),
          );
        } else {
          AppSnackBar.show(
            context,
            message: failure.message,
          );
        }
      case OnFailure(:final failure):
        AppSnackBar.show(
          context,
          message: failure.message,
        );
      default:
        break;
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    return const Scaffold(body: _ProfileForm());
  }
}
