import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/friends/presentation/blocs/friends_bloc.dart';
import 'package:splittr/features/friends/presentation/ui/widgets/friends_empty_state.dart';
import 'package:splittr/features/friends/presentation/ui/widgets/friends_error_state.dart';
import 'package:splittr/features/friends/presentation/ui/widgets/friends_list_view.dart';
import 'package:splittr/features/friends/presentation/ui/widgets/friends_shimmer_list.dart';

part 'friends_form.dart';

class FriendsPage extends BasePage<FriendsBloc, FriendsState> {
  const FriendsPage({super.key});

  @override
  FriendsBloc createBloc() => getIt<FriendsBloc>()..started(noParams);

  @override
  Widget buildPage(BuildContext context) {
    return const Scaffold(body: _FriendsForm());
  }
}
