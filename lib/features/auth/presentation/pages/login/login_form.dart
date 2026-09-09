part of 'login_page.dart';

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return AppScrollView(
      crossAxisAlignment: .center,
      children: [
        AppText.titleLarge(
          context.strings.welcomeBack,
          color: context.colorScheme.onSurface,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppText.bodyMedium(
          context.strings.enterEmailToContinue,
          color: context.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: AppSpacing.xl),
        AuthFormCard(
          children: [
            EmailTextField(
              onChanged: (email) =>
                  getBloc<LoginBloc>(context).emailChanged(email: email),
            ),
            PasswordTextField(
              onChanged: (password) => getBloc<LoginBloc>(
                context,
              ).passwordChanged(password: password),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton.text(
                text: context.strings.forgotPassword,
                onPressed: () => _showForgotPasswordDialog(context),
              ),
            ),
            BlocSelector<LoginBloc, LoginState, bool>(
              selector: (state) =>
                  (state.store.emailAddress?.isValid() ?? false) &&
                  (state.store.password?.isValid() ?? false),
              builder: (context, isValid) {
                return AppButton.primary(
                  text: context.strings.login,
                  onPressed: isValid
                      ? () => getBloc<LoginBloc>(context).loginClicked()
                      : null,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const _DoNotHaveAccountSection(),
        const SizedBox(height: AppSpacing.lg),
        const OrDivider(),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          alignment: .center,
          spacing: AppSpacing.md,
          children: [
            GoogleSignInButton(
              onPressed: () =>
                  getBloc<LoginBloc>(context).loginWithGoogleClicked(),
            ),
            AppleSignInButton(
              onPressed: () => AppSnackBar.show(
                context,
                message: context.strings.socialSignInComingSoon,
              ),
            ),
          ],
        ),
        AppButton.outlined(
          text: context.strings.guestLogin,
          icon: Icons.person,
          onPressed: () => getBloc<AuthBloc>(context).loginAsGuest(),
        ),
      ],
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    unawaited(
      AppDialog.show<void>(
        context: context,
        title: context.strings.forgotPasswordTitle,
        description: context.strings.forgotPasswordDescription,
        actions: [
          AppButton.primary(
            onPressed: () => RouteHandler.pop<void>(context),
            text: context.strings.ok,
          ),
        ],
      ),
    );
  }
}

class _DoNotHaveAccountSection extends StatefulWidget {
  const _DoNotHaveAccountSection();

  @override
  State<_DoNotHaveAccountSection> createState() =>
      _DoNotHaveAccountSectionState();
}

class _DoNotHaveAccountSectionState extends State<_DoNotHaveAccountSection> {
  late final GestureRecognizer _signUpTapRecognizer;

  @override
  void initState() {
    super.initState();
    _signUpTapRecognizer = TapGestureRecognizer()
      ..onTap = () => const SignUpRoute().push<void>(context);
  }

  @override
  void dispose() {
    _signUpTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppRichText(
      spans: [
        AppTextSpan.bodyMedium(context.strings.doNotHaveAccount),
        const AppTextSpan.bodyMedium(' '),
        AppTextSpan.labelLarge(
          context.strings.signUpWithEmail,
          color: context.colorScheme.primary,
          recognizer: _signUpTapRecognizer,
        ),
      ],
    );
  }
}
