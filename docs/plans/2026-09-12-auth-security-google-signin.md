# Auth Security, Email Verification & Primary Google Sign-In Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement email verification anti-spam gating for email/password auth, establish Google Sign-In as the primary full-width 1-tap option on Login & Sign-Up screens, and protect application routes with a type-safe verification router guard.

**Architecture:** Extend `AuthRemoteDataSource` and `AuthRepository` with `sendEmailVerification()` and `checkEmailVerified()`. Update `AuthBloc` with `AuthProviderType` and verification status. Add `VerifyEmailRoute` guarded by `AppRouter`. Redesign `login_form.dart` and `sign_up_form.dart` to place `GoogleSignInButton` at the top with primary emphasis.

**Tech Stack:** Flutter, Dart, `firebase_auth`, `sky_architecture`, `sky_bloc`, `sky_design_system`, `go_router`.

## Global Constraints

- Never use raw provider strings (`"password"`, `"google.com"`) in router or presentation layer; use `AuthProviderType` domain enum.
- Follow `sky_design_system` strictly (`AppButton`, `AppText`, `AppSpacing`, `AppScrollView`, `AppCard`, `AppDivider`).
- Default currency fallback remains `'INR'`.
- Always use `fvm flutter` / `fvm dart` for toolchain execution.

---

### Task 1: Domain AuthProviderType & Remote Data Source Updates

**Files:**
- Create: `lib/features/auth/domain/entities/auth_provider_type.dart`
- Modify: `lib/features/auth/data/datasources/auth_remote_data_source.dart`
- Modify: `lib/features/auth/data/datasources/auth_remote_data_source_impl.dart`
- Modify: `lib/features/auth/domain/repositories/auth_repository.dart`
- Modify: `lib/features/auth/data/repositories/auth_repository_impl.dart`

**Interfaces:**
- Produces:
  - `enum AuthProviderType { emailPassword, google, apple, anonymous }`
  - `Future<void> sendEmailVerification()` on `AuthRepository`
  - `FutureEitherFailure<bool> checkEmailVerified()` on `AuthRepository`
  - `AuthProviderType get currentAuthProvider` on `AuthRepository`

- [ ] **Step 1: Create `auth_provider_type.dart`**

```dart
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
```

- [ ] **Step 2: Add verification methods to `AuthRemoteDataSource` & `AuthRemoteDataSourceImpl`**

In `lib/features/auth/data/datasources/auth_remote_data_source.dart`:
```dart
Future<void> sendEmailVerification();
Future<bool> checkEmailVerified();
AuthProviderType get currentAuthProvider;
```

In `lib/features/auth/data/datasources/auth_remote_data_source_impl.dart`:
```dart
@override
AuthProviderType get currentAuthProvider {
  final user = _firebaseAuth.currentUser;
  if (user == null) return AuthProviderType.anonymous;
  if (user.isAnonymous) return AuthProviderType.anonymous;
  for (final profile in user.providerData) {
    return AuthProviderType.fromProviderId(profile.providerId);
  }
  return AuthProviderType.emailPassword;
}

@override
Future<void> sendEmailVerification() async {
  try {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  } on FirebaseException catch (e) {
    throw e.toServerException();
  }
}

@override
Future<bool> checkEmailVerified() async {
  try {
    await _firebaseAuth.currentUser?.reload();
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  } on FirebaseException catch (e) {
    throw e.toServerException();
  }
}
```
And in `signUpWithEmail`, dispatch verification email right after account creation:
```dart
await _firebaseAuth.currentUser?.sendEmailVerification();
```

- [ ] **Step 3: Update `AuthRepository` and `AuthRepositoryImpl`**

Wire `sendEmailVerification()`, `checkEmailVerified()`, and `currentAuthProvider` in `AuthRepositoryImpl`.

- [ ] **Step 4: Run build_runner and static analysis**

Run: `fvm flutter analyze`
Expected: 0 errors.

---

### Task 2: AuthBloc Verification State & Events

**Files:**
- Modify: `lib/features/auth/presentation/blocs/auth_state.dart`
- Modify: `lib/features/auth/presentation/blocs/auth_event.dart`
- Modify: `lib/features/auth/presentation/blocs/auth_bloc.dart`

**Interfaces:**
- Consumes: `AuthRepository.checkEmailVerified()`, `AuthRepository.sendEmailVerification()`, `AuthProviderType`
- Produces:
  - `AuthState.isEmailVerified` (bool, default `true`)
  - `AuthState.authProvider` (`AuthProviderType`, default `anonymous`)
  - Getter: `bool get isEmailVerificationRequired => !isEmailVerified && authProvider.requiresEmailVerification;`

- [ ] **Step 1: Add fields and getter to `AuthStateStore`**

In `lib/features/auth/presentation/blocs/auth_state.dart`:
Add `@Default(true) bool isEmailVerified` and `@Default(AuthProviderType.anonymous) AuthProviderType authProvider`.
Add getter:
```dart
bool get isEmailVerificationRequired =>
    !isEmailVerified && authProvider.requiresEmailVerification;
```

- [ ] **Step 2: Add events to `auth_event.dart`**

```dart
const factory AuthEvent.checkEmailVerificationRequested() = _CheckEmailVerificationRequested;
const factory AuthEvent.resendEmailVerificationRequested() = _ResendEmailVerificationRequested;
```

- [ ] **Step 3: Implement event handlers in `auth_bloc.dart`**

Handle:
- `_onCheckEmailVerificationRequested`: calls `_authRepository.checkEmailVerified()`. If true, emits `isEmailVerified: true` and syncs user profile via `getMe()`.
- `_onResendEmailVerificationRequested`: calls `_authRepository.sendEmailVerification()`.
- Update `checkAuthStatus`: sets `isEmailVerified` and `authProvider` based on current Firebase user.

- [ ] **Step 4: Run build_runner and analyze**

Run: `fvm dart run build_runner build --delete-conflicting-outputs && fvm flutter analyze`
Expected: 0 errors.

---

### Task 3: Router Guard & VerifyEmailRoute

**Files:**
- Modify: `lib/core/router/app_routes.dart`
- Modify: `lib/core/router/app_router.dart`

**Interfaces:**
- Produces: `VerifyEmailRoute` registered at `/verify-email`
- Guard: redirects unverified email/password accounts to `/verify-email` when authenticated.

- [ ] **Step 1: Declare `VerifyEmailRoute` in `app_routes.dart`**

```dart
class VerifyEmailRoute extends AppRoute {
  const VerifyEmailRoute();
  static const String pathTemplate = '/verify-email';
  @override
  String get path => pathTemplate;
  static VerifyEmailRoute? fromState(GoRouterState state) => const VerifyEmailRoute();
}
```

- [ ] **Step 2: Register route and redirect rule in `app_router.dart`**

In `_routes`:
```dart
GoRoute(
  path: VerifyEmailRoute.pathTemplate,
  builder: (context, state) => const VerifyEmailPage(),
),
```
In redirect callback:
```dart
final isEmailVerificationRequired = authState.store.isEmailVerificationRequired;
if (isAuthenticated && isEmailVerificationRequired) {
  if (state.matchedLocation != VerifyEmailRoute.pathTemplate) {
    return VerifyEmailRoute.pathTemplate;
  }
  return null;
}
```

- [ ] **Step 3: Run static analysis**

Run: `fvm flutter analyze`
Expected: 0 errors.

---

### Task 4: UI Redesign: Google Sign-In Primary on Login & Sign-Up

**Files:**
- Modify: `lib/features/auth/presentation/pages/login/login_form.dart`
- Modify: `lib/features/auth/presentation/pages/sign_up/sign_up_form.dart`
- Modify: `lib/features/auth/presentation/pages/widgets/google_sign_in_button.dart`

**Interfaces:**
- Makes `GoogleSignInButton` full-width and prominent.
- Layout flow: Google Sign-In -> Divider ("or with email") -> Email & Password Card.

- [ ] **Step 1: Enhance `GoogleSignInButton` to support full width**

Make `GoogleSignInButton` an `AppButton.outlined` with Google logo, expanded width, and high touch target.

- [ ] **Step 2: Restructure `login_form.dart`**

1. Welcome header.
2. `GoogleSignInButton(onPressed: () => ...loginWithGoogleClicked())`.
3. `OrDivider(text: context.strings.orWithEmail)`.
4. `AuthFormCard` with email and password fields, login button.
5. "Continue as guest" button.

- [ ] **Step 3: Restructure `sign_up_form.dart`**

1. Create account header.
2. `GoogleSignInButton(onPressed: () => ...signUpWithGoogleClicked())`.
3. `OrDivider(text: context.strings.orWithEmail)`.
4. `AuthFormCard` with Name, Email, Password, Confirm Password fields, sign-up button.

- [ ] **Step 4: Format and analyze**

Run: `fvm dart format lib/features/auth/ && fvm flutter analyze`
Expected: 0 errors.

---

### Task 5: VerifyEmailPage & Form Implementation

**Files:**
- Create: `lib/features/auth/presentation/pages/verify_email/verify_email_page.dart`
- Create: `lib/features/auth/presentation/pages/verify_email/verify_email_form.dart`
- Modify: `lib/l10n/app_en.arb`

**Interfaces:**
- Produces: `VerifyEmailPage`
- Features:
  - Resend cooldown timer (60 seconds)
  - "I've verified my email" check button
  - "Sign Out" button
  - `WidgetsBindingObserver` to auto-check on `AppLifecycleState.resumed`

- [ ] **Step 1: Add localization strings in `app_en.arb`**

Add strings:
`verifyEmailTitle`, `verifyEmailSubtitle`, `checkVerificationButton`, `resendEmailButton`, `resendCooldown`, `verificationEmailSentSnackbar`.

- [ ] **Step 2: Create `verify_email_form.dart` and `verify_email_page.dart`**

Stateful form with:
- `Timer` for 60s cooldown.
- Calls `getBloc<AuthBloc>(context).add(const AuthEvent.checkEmailVerificationRequested())` on button press or app resume.
- Calls `getBloc<AuthBloc>(context).add(const AuthEvent.resendEmailVerificationRequested())` on resend.
- "Sign out" button calls `getBloc<AuthBloc>(context).logout()`.

- [ ] **Step 3: Run build_runner, analyze, and test**

Run:
`fvm flutter gen-l10n`
`fvm dart run build_runner build --delete-conflicting-outputs`
`fvm flutter analyze`
`fvm flutter test`

Expected: 0 errors, all tests passing.
