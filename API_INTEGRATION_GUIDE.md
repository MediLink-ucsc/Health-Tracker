# API Integration Setup Guide

## Overview

The login screen has been updated to integrate with your REST API. The app now makes actual HTTP requests to authenticate users instead of using hardcoded credentials.

## Setup Instructions

### 1. Configure API Base URL

Edit the file `lib/config/app_config.dart` and replace `YOUR_BASE_URL_HERE` with your actual API base URL:

```dart
class AppConfig {
  // Replace with your actual API base URL
  static const String baseUrl = 'https://your-api-domain.com';
  // ... rest of the configuration
}
```

Examples:

- Production: `'https://api.yourdomain.com'`
- Staging: `'https://staging-api.yourdomain.com'`
- Local development: `'http://localhost:3000'`
- Android emulator with local server: `'http://10.0.2.2:3000'`

### 2. API Endpoint Details

**Login Endpoint:** `POST {{BASE_URL}}/v1/auth/patient/login`

**Request Format:**

```json
{
  "username": "0123456789",
  "password": "securePassword123"
}
```

**Success Response (200):**

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Error Response (4xx/5xx):**

```json
{
  "status": "error",
  "message": "invalid credentials"
}
```

### 3. Features Implemented

✅ **API Integration**

- HTTP requests to login endpoint
- Proper error handling
- Request/response logging (in debug mode)

✅ **Token Management**

- Secure token storage using SharedPreferences
- Automatic token persistence
- Token-based authentication ready

✅ **Remember Me Functionality**

- Save/restore login credentials
- Secure credential storage
- Clear credentials on demand

✅ **Loading States**

- Visual feedback during API calls
- Disabled form during login process
- Progress indicators

✅ **Error Handling**

- Network error handling
- API error message display
- Timeout handling (30 seconds)

### 4. Testing the Integration

1. **Update the base URL** in `app_config.dart`
2. **Test with valid credentials** that exist in your backend
3. **Test with invalid credentials** to verify error handling
4. **Test network scenarios** (offline, slow connection)

### 5. Security Considerations

- Tokens are stored securely using SharedPreferences
- Passwords are not logged in production
- HTTPS is recommended for production use
- Consider implementing token refresh logic

### 6. Next Steps

You may want to implement:

- Token refresh mechanism
- Biometric authentication
- Enhanced security features
- User profile data fetching after login

## Files Modified

- `lib/screens/user_login_screen.dart` - Updated login logic
- `lib/services/api_service.dart` - HTTP client for API calls
- `lib/services/auth_service.dart` - Authentication state management
- `lib/config/app_config.dart` - Configuration settings
- `lib/Components/logout.dart` - Updated logout to clear tokens
- `pubspec.yaml` - Added http package dependency

## Testing Credentials

Once your API is configured, you can test with real user accounts. The hardcoded test users have been removed in favor of API authentication.

## Troubleshooting

**Common Issues:**

1. **Network Error:** Check if the base URL is correct and the server is running
2. **CORS Issues:** Ensure your API allows requests from your app's domain
3. **Certificate Issues:** For HTTPS, ensure SSL certificates are valid
4. **Timeout:** Check if the API response time is under 30 seconds

**Debug Logging:**
API requests and responses are logged when `enableApiLogging` is true in `app_config.dart`. Check the console output for detailed information about API calls.
