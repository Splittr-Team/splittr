part of 'profile_page.dart';

class _ProfileForm extends StatelessWidget {
  const _ProfileForm();

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: () async {
        getBloc<ProfileBloc>(context).started(noParams);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: AppSpacing.xxl),
          Center(child: AppText.bodyMedium('Profile Page')),
        ],
      ),
    );
  }
}
