# Backend Integration Spec: Email Verification & Anti-Spam Auth Gate

**Target Audience**: Backend Engineering Team  
**Subject**: Expected behavior for incoming Firebase Auth ID Tokens & Email Verification  
**App Client**: Splittr Mobile (Flutter)  

---

## 1. Overview & Objective

To prevent bot spam, invalid user account creation, and spam group/expense injection, the mobile client is introducing email verification for users registering via Email & Password.

This document describes:
1. What the mobile app sends in HTTP requests.
2. The expected backend behavior for verified vs unverified users.
3. Standardized error response format expected by the app.
4. (Optional) Suggested implementation notes using Firebase Admin SDK.

---

## 2. Request Authentication Contract

The mobile app includes the Firebase ID Token in the standard `Authorization` Bearer header on all API requests:

```http
Authorization: Bearer <FIREBASE_ID_TOKEN>
```

When decoded by the Firebase Admin SDK, this token contains:
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

Key claims:
- `email_verified` (`boolean`): Indicates whether the email address has been confirmed.
- `firebase.sign_in_provider` (`string`): The identity provider used (e.g. `"password"`, `"google.com"`, `"apple.com"`).

---

## 3. Expected Backend Behavior

### 3.1 Decision Matrix

| `sign_in_provider` | `email_verified` | Route Type | Expected Action | Status Code | Error Code |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `"google.com"` | `true` | Protected Routes | Allow request | `200` / `201` | None |
| `"apple.com"` | `true` | Protected Routes | Allow request | `200` / `201` | None |
| `"password"` | `true` | Protected Routes | Allow request | `200` / `201` | None |
| `"password"` | `false` | Protected Operations (`/groups`, `/expenses`, `/friends`) | **Reject request** | **`403 Forbidden`** | **`EMAIL_NOT_VERIFIED`** |
| `"password"` | `false` | User Onboarding (`POST /users`, `GET /users/me`) | **Allow or handle** (see §3.3) | `200` / `201` | None |

> **Note**: Google and Apple OAuth providers guarantee verified email addresses at the OAuth layer. Therefore, social logins will always have `email_verified: true` and will never be blocked by this check.

### 3.2 Standardized Error Response Format

When rejecting an unverified request, the app expects a `403 Forbidden` response:

```json
{
  "statusCode": 403,
  "errorCode": "EMAIL_NOT_VERIFIED",
  "message": "Please verify your email address to access this resource."
}
```

The app's HTTP client explicitly checks for:
- HTTP Status: `403`
- `errorCode == "EMAIL_NOT_VERIFIED"`

Upon receiving this error, the app automatically transitions the user to the `VerifyEmailPage` with actions to resend the verification email or check status.

### 3.3 Initial User Creation (`POST /users`)

When a user signs up with email & password on mobile, the app calls `POST /users` with `{ name, email }`.

**Recommended Backend Handling**:
- Permit `POST /users` even if `email_verified == false`.
- Create the user document with a flag: `emailVerified: false` (or `status: "pending_verification"`).
- Block all subsequent operational endpoints (`/groups/*`, `/expenses/*`, `/friends/*`) with `403 EMAIL_NOT_VERIFIED` until the user verifies their email.
- Once the user verifies their email, Firebase issues a new token where `email_verified: true`. Subsequent requests will automatically pass.

---

## 4. (Optional) Implementation Suggestions

*The backend team may implement this using whatever middleware pattern best fits the backend architecture. Below are standard reference implementations for common stacks:*

### Go Example (Fiber / Gin / Chi)
```go
func RequireVerifiedEmail() gin.HandlerFunc {
    return func(c *gin.Context) {
        token := c.MustGet("firebase_token").(*auth.Token)
        
        signInProvider, _ := token.Firebase.SignInProvider.(string)
        emailVerified, _ := token.Claims["email_verified"].(bool)
        
        // Block unverified email/password accounts
        if signInProvider == "password" && !emailVerified {
            c.AbortWithStatusJSON(http.StatusForbidden, gin.H{
                "statusCode": http.StatusForbidden,
                "errorCode":  "EMAIL_NOT_VERIFIED",
                "message":    "Please verify your email address to access this resource.",
            })
            return
        }
        
        c.Next()
    }
}
```

### Node.js / Express Example
```typescript
export function requireVerifiedEmail(req: Request, res: Response, next: NextFunction) {
  const token = req.user; // Decoded Firebase token from auth middleware
  const provider = token.firebase?.sign_in_provider;
  const isVerified = token.email_verified === true;

  if (provider === 'password' && !isVerified) {
    return res.status(403).json({
      statusCode: 403,
      errorCode: 'EMAIL_NOT_VERIFIED',
      message: 'Please verify your email address to access this resource.'
    });
  }

  next();
}
```

---

## 5. Contact & Questions

If you have questions about the token payload or mobile app error handling, reach out to the Mobile Core team or comment on the RFC PR.
