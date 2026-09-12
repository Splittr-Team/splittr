part of 'profile_page.dart';

class _ProfileForm extends StatelessWidget {
  const _ProfileForm();

  void _showCurrencyPicker(BuildContext context, String currentCurrency) {
    unawaited(
      AppBottomSheet.show<void>(
        context: context,
        title: 'Select Default Currency',
        child: CurrencyPickerBottomSheet(
          selectedCurrency: currentCurrency,
          onCurrencySelected: (currency) {
            getBloc<ProfileBloc>(context).currencyChanged(currency: currency);
          },
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    unawaited(
      AppDialog.show<void>(
        context: context,
        title: context.strings.logout,
        description: 'Are you sure you want to log out of your account?',
        actions: [
          AppButton.text(
            onPressed: () => RouteHandler.pop<void>(context),
            text: context.strings.cancel,
          ),
          AppButton.text(
            onPressed: () {
              RouteHandler.pop<void>(context);
              getBloc<AuthBloc>(context).loggedOut();
            },
            text: context.strings.logout,
            color: context.colorScheme.error,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final user = state.store.user;
        final selectedCurrency = state.store.selectedCurrency;
        final isDarkMode = state.store.isDarkMode;

        return AppRefreshIndicator(
          onRefresh: () async {
            getBloc<ProfileBloc>(context).started(noParams);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ProfileHeaderCard(user: user),
              const SizedBox(height: AppSpacing.lg),
              AppText.labelLarge(
                'PREFERENCES',
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard.outlined(
                color: context.colorScheme.surfaceContainer,
                child: Column(
                  children: [
                    AppListTile(
                      leadingIcon: Icons.attach_money_rounded,
                      title: 'Default Currency',
                      subtitle: selectedCurrency,
                      onTap: () => _showCurrencyPicker(
                        context,
                        selectedCurrency,
                      ),
                    ),
                    const AppDivider.horizontal(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isDarkMode
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppText.bodyLarge('Dark Mode'),
                                AppText.bodySmall(
                                  isDarkMode ? 'Enabled' : 'Disabled',
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: isDarkMode,
                            onChanged: (val) {
                              getBloc<ProfileBloc>(context).themeModeToggled(
                                isDarkMode: val,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppText.labelLarge(
                'ABOUT & LEGAL',
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard.outlined(
                color: context.colorScheme.surfaceContainer,
                child: Column(
                  children: [
                    if (getIt<AppConfigStore>().legal?.termsOfServiceUrl !=
                        null)
                      AppListTile(
                        leadingIcon: Icons.description_outlined,
                        title: 'Terms of Service',
                        subtitle:
                            getIt<AppConfigStore>().legal!.termsOfServiceUrl,
                        onTap: () {
                          unawaited(
                            AppDialog.show<void>(
                              context: context,
                              title: 'Terms of Service',
                              description: getIt<AppConfigStore>()
                                  .legal!
                                  .termsOfServiceUrl,
                              actions: [
                                AppButton.text(
                                  onPressed: () =>
                                      RouteHandler.pop<void>(context),
                                  text: 'OK',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    if (getIt<AppConfigStore>().legal?.privacyPolicyUrl !=
                        null) ...[
                      const AppDivider.horizontal(),
                      AppListTile(
                        leadingIcon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        subtitle:
                            getIt<AppConfigStore>().legal!.privacyPolicyUrl,
                        onTap: () {
                          unawaited(
                            AppDialog.show<void>(
                              context: context,
                              title: 'Privacy Policy',
                              description: getIt<AppConfigStore>()
                                  .legal!
                                  .privacyPolicyUrl,
                              actions: [
                                AppButton.text(
                                  onPressed: () =>
                                      RouteHandler.pop<void>(context),
                                  text: 'OK',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                    if (getIt<AppConfigStore>().legal?.supportEmail !=
                        null) ...[
                      const AppDivider.horizontal(),
                      AppListTile(
                        leadingIcon: Icons.help_outline_rounded,
                        title: 'Support',
                        subtitle: getIt<AppConfigStore>().legal!.supportEmail,
                        onTap: () {
                          final supportEmail =
                              getIt<AppConfigStore>().legal!.supportEmail;
                          unawaited(
                            AppDialog.show<void>(
                              context: context,
                              title: 'Support',
                              description: 'Contact: $supportEmail',
                              actions: [
                                AppButton.text(
                                  onPressed: () =>
                                      RouteHandler.pop<void>(context),
                                  text: 'OK',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                    const AppDivider.horizontal(),
                    Builder(
                      builder: (context) {
                        final version =
                            getIt<AppConfigStore>().config?.configVersion ??
                            '1.0.0';
                        return AppListTile(
                          leadingIcon: Icons.info_outline_rounded,
                          title: 'App Version',
                          subtitle: 'v$version',
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppText.labelLarge(
                'ACCOUNT',
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard.outlined(
                color: context.colorScheme.surfaceContainer,
                child: AppListTile(
                  leadingIcon: Icons.logout_rounded,
                  title: context.strings.logout,
                  onTap: () => _confirmLogout(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
