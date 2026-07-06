part of 'sign_up_page.dart';

class _SignUpForm extends StatelessWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context) {
    return AppScrollView(
      crossAxisAlignment: .center,
      children: [
        AppText.titleLarge(
          context.strings.createAccount,
          color: context.colorScheme.onSurface,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppText.bodyMedium(
          context.strings.joinUs,
          color: context.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: AppSpacing.xl),
        AuthFormCard(
          children: [
            NameTextField(
              onChanged: (name) =>
                  getBloc<SignUpBloc>(context).nameChanged(name: name),
            ),
            EmailTextField(
              onChanged: (email) =>
                  getBloc<SignUpBloc>(context).emailChanged(email: email),
            ),
            PasswordTextField(
              onChanged: (password) => getBloc<SignUpBloc>(
                context,
              ).passwordChanged(password: password),
            ),
            BlocSelector<SignUpBloc, SignUpState, Password?>(
              selector: (state) => state.store.password,
              builder: (context, password) {
                return ConfirmPasswordTextField(
                  onChanged: (confirmPassword) => getBloc<SignUpBloc>(
                    context,
                  ).confirmPasswordChanged(confirmPassword: confirmPassword),
                  password: password,
                );
              },
            ),
            BlocSelector<SignUpBloc, SignUpState, bool>(
              selector: (state) =>
                  (state.store.name?.isValid() ?? false) &&
                  (state.store.emailAddress?.isValid() ?? false) &&
                  (state.store.password?.isValid() ?? false) &&
                  (state.store.confirmPassword?.isValid() ?? false),
              builder: (context, isValid) {
                return AppButton.primary(
                  text: context.strings.signUp,
                  onPressed: isValid
                      ? () => getBloc<SignUpBloc>(context).signUpClicked()
                      : null,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const _AlreadyHaveAccountSection(),
        const SizedBox(height: AppSpacing.lg),
        const OrDivider(),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          alignment: .center,
          spacing: AppSpacing.md,
          children: [
            GoogleSignInButton(onPressed: () {}),
            AppleSignInButton(onPressed: () {}),
          ],
        ),
      ],
    );
  }
}

class _AlreadyHaveAccountSection extends StatefulWidget {
  const _AlreadyHaveAccountSection();

  @override
  State<_AlreadyHaveAccountSection> createState() =>
      _AlreadyHaveAccountSectionState();
}

class _AlreadyHaveAccountSectionState
    extends State<_AlreadyHaveAccountSection> {
  late final GestureRecognizer _signInTapRecognizer;

  @override
  void initState() {
    super.initState();
    _signInTapRecognizer = TapGestureRecognizer()
      ..onTap = () => RouteHandler.pop<void>(context);
  }

  @override
  void dispose() {
    _signInTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppRichText(
      spans: [
        AppTextSpan.bodyMedium(context.strings.alreadyHaveAccount),
        const AppTextSpan(' '),
        AppTextSpan.labelLarge(
          context.strings.signIn,
          color: context.colorScheme.primary,
          recognizer: _signInTapRecognizer,
        ),
      ],
    );
  }
}
