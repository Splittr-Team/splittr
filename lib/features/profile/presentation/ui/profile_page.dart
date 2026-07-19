import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/profile/presentation/blocs/profile_bloc.dart';

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
