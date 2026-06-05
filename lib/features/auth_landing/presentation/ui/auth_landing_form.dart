part of 'auth_landing_page.dart';

class _AuthLandingForm extends StatelessWidget {
  const _AuthLandingForm();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Lottie.asset(AnimationKeys.billLottie),
          AppButton.outlined(
            text: 'Quick Split',
            onPressed: () {
              unawaited(RouteHandler.push(context, RouteId.quickSplit));
            },
          ),
          const SizedBox(height: 10),
          AppButton.primary(
            text: 'Login',
            onPressed: () {
              unawaited(RouteHandler.push(context, RouteId.login));
            },
          ),
          const SizedBox(height: 10),
          AppButton.secondary(
            text: 'SignUp',
            onPressed: () {
              unawaited(RouteHandler.push(context, RouteId.signup));
            },
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
