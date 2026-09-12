enum AuthProviderType {
  emailPassword,
  google,
  apple,
  anonymous;

  bool get requiresEmailVerification => this == AuthProviderType.emailPassword;

  static AuthProviderType fromProviderId(String? providerId) {
    return switch (providerId) {
      'google.com' => AuthProviderType.google,
      'apple.com' => AuthProviderType.apple,
      'password' => AuthProviderType.emailPassword,
      _ => AuthProviderType.anonymous,
    };
  }
}
