part of 'dashboard_page.dart';

class _DashboardForm extends StatelessWidget {
  const _DashboardForm({this.onSendEmailVerification});

  final VoidCallback? onSendEmailVerification;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppText.titleLarge('Dashboard'),
          const SizedBox(height: AppSpacing.md),
          AppButton.primary(
            text: 'Send Email Verification',
            onPressed: onSendEmailVerification,
          ),
        ],
      ),
    );
  }
}
