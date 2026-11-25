part of 'profile_page.dart';

class _ProfileForm extends StatelessWidget {
  const _ProfileForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state.store.profile;
        final settings = state.store.settings;
        final isEditMode = state.store.isEditMode;
        final bloc = getBloc<ProfileBloc>(context);

        return AppRefreshIndicator(
          onRefresh: () async {
            bloc.started(noParams);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            children: [
              _ProfileHeader(
                profile: profile,
                onAvatarPicked: bloc.updateAvatar,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Profile Details Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.titleMedium(
                    context.strings.profileDetails,
                    color: context.colorScheme.onSurface,
                  ),
                  if (!isEditMode)
                    AppIconButton(
                      icon: Icons.edit_outlined,
                      onPressed: bloc.editModeToggled,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Material(
                color: context.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                clipBehavior: Clip.antiAlias,
                child: !isEditMode
                    ? Column(
                        children: [
                          AppListTile(
                            leadingIcon: Icons.person_outline,
                            title: context.strings.fullName,
                            subtitle: profile?.name?.isNotEmpty == true
                                ? profile!.name!
                                : '—',
                          ),
                          const AppDivider.horizontal(),
                          AppListTile(
                            leadingIcon: Icons.email_outlined,
                            title: context.strings.emailAddress,
                            subtitle: profile?.email?.isNotEmpty == true
                                ? profile!.email!
                                : '—',
                          ),
                          const AppDivider.horizontal(),
                          AppListTile(
                            leadingIcon: Icons.payments_outlined,
                            title: context.strings.defaultCurrency,
                            subtitle:
                                profile?.defaultCurrency?.isNotEmpty == true
                                ? profile!.defaultCurrency!
                                : 'USD',
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              initialValue: state.store.draftName,
                              labelText: context.strings.fullName,
                              hintText: context.strings.enterYourFullName,
                              prefixIcon: const AppIcon.md(
                                Icons.person_outline,
                              ),
                              onChanged: bloc.nameChanged,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppTextField(
                              initialValue: state.store.draftCurrency,
                              labelText: context.strings.defaultCurrency,
                              hintText: context.strings.currencyHintText,
                              prefixIcon: const AppIcon.md(
                                Icons.payments_outlined,
                              ),
                              onChanged: bloc.currencyChanged,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              children: [
                                Expanded(
                                  child: AppButton.secondary(
                                    text: context.strings.cancel,
                                    onPressed: bloc.editModeToggled,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child:
                                      BlocSelector<
                                        ProfileBloc,
                                        ProfileState,
                                        bool
                                      >(
                                        selector: (state) =>
                                            state.store.canSave,
                                        builder: (context, canSave) {
                                          return AppButton.primary(
                                            text: context.strings.saveChanges,
                                            onPressed: canSave
                                                ? bloc.updateProfile
                                                : null,
                                          );
                                        },
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Preferences Section
              AppText.titleMedium(
                'Preferences',
                color: context.colorScheme.onSurface,
              ),
              const SizedBox(height: AppSpacing.sm),
              Material(
                color: context.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                clipBehavior: Clip.antiAlias,
                child: AppListTile(
                  leadingIcon: Icons.person_add_outlined,
                  title: context.strings.autoAcceptFriendRequests,
                  subtitle: context.strings.autoAcceptFriendRequestsSubtitle,
                  trailingWidget: AppSwitch(
                    value: settings?.autoAcceptFriendRequests ?? false,
                    onChanged: (val) {
                      bloc.updateSettings(
                        autoAcceptFriendRequests: val,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.onAvatarPicked,
  });

  final Profile? profile;
  final ValueChanged<File> onAvatarPicked;

  @override
  Widget build(BuildContext context) {
    return MediaPickerWidget(
      sheetTitle: context.strings.changePhoto,
      onImagePicked: onAvatarPicked,
      builder: (context, showPicker) {
        return Column(
          children: [
            _EditableAvatar(
              imageUrl: profile?.avatarUrl,
              onTap: showPicker,
            ),
            const SizedBox(height: AppSpacing.md),
            AppText.headlineSmall(
              profile?.name?.isNotEmpty == true
                  ? profile!.name!
                  : context.strings.user,
              color: context.colorScheme.onSurface,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText.bodyMedium(
              profile?.email?.isNotEmpty == true ? profile!.email! : '—',
              color: context.colorScheme.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}

class _EditableAvatar extends StatelessWidget {
  const _EditableAvatar({
    required this.onTap,
    this.imageUrl,
  });

  static const double _radius = AppRadius.xxl;
  static const double _diameter = _radius * 2;

  final VoidCallback onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final imageProvider = switch (imageUrl) {
      final url? when url.isNotEmpty => NetworkImage(url),
      _ => null,
    };

    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: _diameter,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: AppAvatar.icon(
                icon: Icons.person,
                radius: _radius,
                backgroundImage: imageProvider,
                onBackgroundImageError: imageProvider != null
                    ? (_, _) {}
                    : null,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colorScheme.surfaceContainerLowest,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.add_a_photo,
                  size: 14,
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
