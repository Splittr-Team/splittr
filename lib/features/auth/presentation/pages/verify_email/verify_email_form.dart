part of 'verify_email_page.dart';

class _VerifyEmailForm extends StatefulWidget {
  const _VerifyEmailForm();

  @override
  State<_VerifyEmailForm> createState() => _VerifyEmailFormState();
}

class _VerifyEmailFormState extends State<_VerifyEmailForm>
    with WidgetsBindingObserver {
  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_checkVerification(silent: true));
    }
  }

  void _startCooldown() {
    setState(() {
      _cooldownSeconds = 60;
    });
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_cooldownSeconds <= 1) {
        timer.cancel();
        setState(() {
          _cooldownSeconds = 0;
        });
      } else {
        setState(() {
          _cooldownSeconds--;
        });
      }
    });
  }

  Future<void> _checkVerification({bool silent = false}) async {
    if (_isChecking) return;
    setState(() {
      _isChecking = true;
    });

    final authBloc = context.read<AuthBloc>()..checkEmailVerification();

    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() {
      _isChecking = false;
    });

    final currentState = authBloc.state;
    if (!silent && currentState is UnverifiedEmail) {
      AppSnackBar.show(
        context,
        message: context.strings.emailNotVerifiedYet,
      );
    }
  }

  void _resendVerification() {
    if (_cooldownSeconds > 0) return;
    context.read<AuthBloc>().resendEmailVerification();
    _startCooldown();
    AppSnackBar.show(
      context,
      message: context.strings.verificationSentSnackbar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OnFailure) {
          AppSnackBar.show(
            context,
            message: state.failure.message,
          );
        }
      },
      builder: (context, state) {
        final email = switch (state) {
          UnverifiedEmail(:final email) => email,
          _ => '',
        };

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer.withValues(
                      alpha: 0.3,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mark_email_unread_rounded,
                    size: 72,
                    color: context.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppText.headlineMedium(
                  context.strings.verifyEmailTitle,
                  textAlign: TextAlign.center,
                  color: context.colorScheme.onSurface,
                ),
                const SizedBox(height: AppSpacing.md),
                AppText.bodyLarge(
                  context.strings.verifyEmailSubtitle(
                    email.isNotEmpty ? email : 'your email',
                  ),
                  textAlign: TextAlign.center,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.primary(
                    text: _isChecking
                        ? 'Checking...'
                        : context.strings.checkVerificationButton,
                    onPressed: _isChecking ? null : _checkVerification,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.outlined(
                    text: _cooldownSeconds > 0
                        ? context.strings.resendCooldown(_cooldownSeconds)
                        : context.strings.resendVerificationButton,
                    onPressed: _cooldownSeconds > 0
                        ? null
                        : _resendVerification,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton.text(
                  text: context.strings.logout,
                  onPressed: () => context.read<AuthBloc>().loggedOut(),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );
  }
}
