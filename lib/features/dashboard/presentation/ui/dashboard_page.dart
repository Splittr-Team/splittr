import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sky_architecture/sky_architecture.dart' hide State;
import 'package:sky_bloc/sky_bloc.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/di/injection.dart';
import 'package:splittr/features/dashboard/presentation/blocs/dashboard_bloc.dart';

part 'dashboard_form.dart';

class DashboardPage extends BasePage<DashboardBloc, DashboardState> {
  const DashboardPage({super.key});

  @override
  DashboardBloc createBloc() => getIt<DashboardBloc>()..started(noParams);

  Future<void> sendEmailVerification(
    FirebaseAuth auth, {
    BuildContext? context,
  }) async {
    final user = auth.currentUser;
    if (user == null) {
      if (context != null && context.mounted) {
        AppSnackBar.show(context, message: 'No authenticated user found');
      }
      return;
    }

    if (user.emailVerified) {
      if (context != null && context.mounted) {
        AppSnackBar.show(context, message: 'Email already verified');
      }
      return;
    }

    try {
      await user.sendEmailVerification();
      if (context != null && context.mounted) {
        AppSnackBar.show(
          context,
          message: 'Verification email sent to ${user.email}',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context != null && context.mounted) {
        AppSnackBar.show(
          context,
          message: e.message ?? 'Failed to send verification email',
        );
      }
    } on Exception catch (e) {
      if (context != null && context.mounted) {
        AppSnackBar.show(
          context,
          message: 'Failed to send verification email: $e',
        );
      }
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _DashboardForm(
        onSendEmailVerification: () => sendEmailVerification(
          getIt<FirebaseAuth>(),
          context: context,
        ),
      ),
    );
  }
}
