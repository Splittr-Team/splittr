import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:sky_router/sky_router.dart';
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
  Widget buildPage(BuildContext context) {
    return const Scaffold(body: _ProfileForm());
  }
}
