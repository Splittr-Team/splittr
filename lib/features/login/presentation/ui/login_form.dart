part of 'login_page.dart';

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blue background
        const ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
          child: FractionallySizedBox(
            heightFactor: 0.55,
            alignment: Alignment.topCenter,
            // child: Container(color: AppColors.blueBgColor),
          ),
        ),
        // Centered white card
        Center(
          child: Card(
            // color: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20,
              ), // Optional: Rounded corners
            ),
            elevation: 4, // Optional: Add shadow to the card
            margin: const EdgeInsets.all(
              16,
            ), // Optional: Margin around the card
            child: Padding(
              padding: const EdgeInsets.all(16), // Padding inside the card
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimize height of the card
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Welcome back', style: TextStyle(fontSize: 25)),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AppTextField(
                      labelText: 'Email',
                      hintText: 'Enter Email',
                      onChanged: getBloc<LoginBloc>(context).phoneNumberChanged,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AppTextField(
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      onChanged: getBloc<LoginBloc>(context).phoneNumberChanged,
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AppButton.outlined(
                      text: 'Login',
                      onPressed: getBloc<LoginBloc>(context).sendOtpClicked,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'New User? ',
                          style: TextStyle(color: Colors.black),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              unawaited(
                                RouteHandler.pushAndRemoveUntil(
                                  context,
                                  RouteId.signup,
                                ),
                              );
                            },
                            child: const Text(
                              'SignUp',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
