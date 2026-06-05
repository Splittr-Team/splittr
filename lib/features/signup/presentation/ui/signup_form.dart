part of 'signup_page.dart';

class _SignupForm extends StatelessWidget {
  const _SignupForm();

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
                  const Text('Hello, there👋', style: TextStyle(fontSize: 25)),
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: AppTextField(
                      labelText: 'Email',
                      hintText: 'Enter Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: AppTextField(
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: AppTextField(
                      labelText: 'Confirm password',
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AppButton.outlined(text: 'SignUp', onPressed: () {}),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Already a user? ',
                          style: TextStyle(color: Colors.black),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              unawaited(
                                RouteHandler.pushAndRemoveUntil(
                                  context,
                                  RouteId.login,
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
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
