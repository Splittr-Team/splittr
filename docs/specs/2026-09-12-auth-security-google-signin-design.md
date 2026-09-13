# Design Spec: Auth Security, Email Verification & Primary Google Sign-In

**Date**: 2026-09-12  
**Status**: Draft (Under Review)  
**Authors**: Splittr Core Engineering  

---

## 1. Executive Summary

This specification addresses two core product goals:
1. **Spam Mitigation & Security**: Require email verification for Email/Password registrations before granting access to core app resources (groups, expenses, balances, activities).
2. **Frictionless Onboarding via Google Sign-In**: Position Google Sign-In as the primary, prominent 1-tap authentication method across Login and Sign-Up screens. Google OAuth provides verified emails by default (`email_verified: true`), bypassing verification delays and eliminating spam accounts.

---

## 2. User Experience & Visual Design

### 2.1 Login & Sign-Up Screen Reordering
Currently, the screens prioritize manual email and password entry with small social buttons at the bottom. The new layout reverses this visual hierarchy:

```
+------------------------------------------+
|               Welcome Back               |
|                                          |
|  +------------------------------------+  |
|  | [G]  Continue with Google          |  |  <-- Full-width high-emphasis primary
|  +------------------------------------+  |
|                                          |
|          --- or with email ---           |  <-- Subtle divider
|                                          |
|  +------------------------------------+  |
|  | Email Address                      |  |
|  | Password                           |  |
|  | Forgot Password?                   |  |
|  | [ Log In ]                         |  |  <-- Secondary container/form
|  +------------------------------------+  |
|                                          |
|         Continue as Guest (text)         |
+------------------------------------------+
```

### 2.2 Email Verification Screen (`VerifyEmailPage`)
When an unverified email/password user signs up or attempts to log in:
1. Entry to main application routes (`/dashboard`, `/groups`, etc.) is blocked.
2. User is routed to `/verify-email`.
3. Screen displays:
   - Verification envelope graphic/icon.
   - Target email address: `user@example.com`.
   - Clear instructions to click the verification link sent to their inbox.
   - **Action 1: "I've Verified My Email"** (`AppButton.primary`): reloads Firebase user session and transitions to Dashboard if verified.
   - **Action 2: "Resend Verification Email"** (`AppButton.outlined`): re-triggers verification link dispatch with an active 60-second countdown cooldown timer.
   - **Action 3: "Sign Out / Change Email"** (`AppButton.text`): returns to login screen.
4. **Lifecycle Auto-Check**: Listens to app lifecycle state (`AppLifecycleState.resumed`). When the user switches back from their email app (e.g. Gmail/Mail), the app automatically triggers a silent `user.reload()`.

---

## 3. Client Architecture

### 3.1 Domain Decoupling & Typed Providers
Avoid raw string checks (e.g. `'password'`, `'google.com'`) in UI and router logic.

```dart
enum AuthProviderType {
  emailPassword,
  google,
  apple,
  anonymous;

  bool get requiresEmailVerification => this == AuthProviderType.emailPassword;
}
```

### 3.2 State Management (`AuthBloc`)
- **State Fields**:
  - `bool isEmailVerified`
  - `AuthProviderType authProvider`
  - Computed property:
    ```dart
    bool get isEmailVerificationRequired =>
        !isEmailVerified && authProvider.requiresEmailVerification;
    ```
- **Events**:
  - `checkEmailVerificationRequested`: calls `user.reload()`, re-evaluates `isEmailVerified`.
  - `resendEmailVerificationRequested`: triggers email send with cooldown tracking.
  - `emailVerifiedStateChanged(bool verified)`: updates state and triggers user profile sync with backend.

### 3.3 Navigation & Router Guard (`AppRouter`)
- The router redirect guard examines `authState`:
  ```dart
  if (authState.isAuthenticated && authState.isEmailVerificationRequired) {
    if (state.matchedLocation != const VerifyEmailRoute().path) {
      return const VerifyEmailRoute().path;
    }
    return null;
  }
  ```
- Protects deep links and prevents manual URL tampering.

### 3.4 API Error Interceptor
- When any protected API call receives HTTP `403` with `errorCode == 'EMAIL_NOT_VERIFIED'`:
  - Interceptor dispatches event to `AuthBloc`.
  - Redirects app to `/verify-email`.

---

## 4. Backend Contract & Expected Behavior

This section defines the contract between the Flutter client and the backend services.

### 4.1 Client Request Identity
The Flutter application sends the Firebase ID Token in the standard `Authorization` header for all requests:
```http
Authorization: Bearer <FIREBASE_ID_TOKEN>
```

The Firebase ID Token contains decoded claims:
```json
{
  "iss": "https://securetoken.google.com/<project-id>",
  "sub": "<firebase-uid>",
  "aud": "<project-id>",
  "auth_time": 1757692800,
  "user_id": "<firebase-uid>",
  "email": "user@example.com",
  "email_verified": false,
  "firebase": {
    "sign_in_provider": "password"
  }
}
```

### 4.2 Expected Backend Behavior

| Sign-In Provider | `email_verified` Claim | Endpoint Type | Expected HTTP Status | Expected Error Code |
| :--- | :--- | :--- | :--- | :--- |
| `google.com` | `true` (guaranteed by Google) | Any Protected Route | `200` / `201` (Pass) | None |
| `password` | `true` | Any Protected Route | `200` / `201` (Pass) | None |
| `password` | `false` | Protected Routes (`/groups`, `/expenses`, `/friends`, etc.) | **`403 Forbidden`** | **`EMAIL_NOT_VERIFIED`** |
| `password` | `false` | Identity/Profile Sync (`/users/me`, `/users`) | Whitelisted / Handled (see below) | None |

### 4.3 Standardized Error Response
When rejecting an unverified request, the backend should return:

```json
{
  "statusCode": 403,
  "errorCode": "EMAIL_NOT_VERIFIED",
  "message": "Please verify your email address to access this resource."
}
```

### 4.4 Account Creation on Initial Sign-Up
On initial user creation (`POST /users`):
- **Option A (Recommended)**: Backend permits `POST /users` even if `email_verified == false` so the user record exists in database with a `status: "pending_verification"` or `emailVerified: false` flag, but blocks all operational mutations (`/groups`, `/expenses`) until verified.
- **Option B**: Client calls `POST /users` only after email verification succeeds. (Requires client to delay backend account creation until `emailVerified == true`).
- **Recommendation**: Option A is cleaner for tracking sign-up drop-offs and linking invites/referrals.

---

## 5. Security & Spam Analysis

1. **Bot / Script Protection**: A script cannot mass-create spam groups or expenses because protected routes reject tokens with `email_verified: false`.
2. **Domain Spoofing**: Attackers registering with stolen emails (e.g. `ceo@target.com`) cannot interact with the system or pollute member directories without inbox confirmation.
3. **Google Sign-In Bypass**: Google accounts bypass email verification because Google guarantees domain ownership and authentication during the OAuth flow.
