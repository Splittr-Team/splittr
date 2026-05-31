part of 'splash_page.dart';

class _SplashForm extends StatelessWidget {
  const _SplashForm();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppImage(
        Theme.of(context).brightness == Brightness.dark
            ? ImageAssets.splittrLogoDark
            : ImageAssets.splittrLogoLight,
      ),
    );
  }
}
