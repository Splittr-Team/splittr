import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart' hide State;
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/core/presentation/widgets/widgets.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/profile/domain/entities/profile.dart';
import 'package:splittr/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:splittr/utils/extensions/extensions.dart';

part 'profile_form.dart';

class ProfilePage extends BasePage<ProfileBloc, ProfileState> {
  const ProfilePage({super.key});

  @override
  ProfileBloc createBloc() => getIt<ProfileBloc>()..started(noParams);

  @override
  void handleStateChange(BuildContext context, ProfileState state) {
    switch (state) {
      case OnProfileUpdated():
        AppSnackBar.show(
          context,
          message: context.strings.profileUpdatedSuccessfully,
        );
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
    return AppScaffold(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      appBar: AppTopBar(
        title: context.strings.profile,
      ),
      body: const _ProfileForm(),
    );
  }
}
