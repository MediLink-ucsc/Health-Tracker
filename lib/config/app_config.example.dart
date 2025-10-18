// Example configuration for testing with a local development server
// Copy this content to lib/config/app_config.dart and modify as needed

class AppConfig {
  // EXAMPLE: Local development server
  // static const String baseUrl = 'http://localhost:3000';

  // EXAMPLE: Android emulator with local server
  // static const String baseUrl = 'http://10.0.2.2:3000';

  // EXAMPLE: Production server
  // static const String baseUrl = 'https://api.yourdomain.com';

  // EXAMPLE: Staging server
  // static const String baseUrl = 'https://staging-api.yourdomain.com';

  // TODO: Replace with your actual API base URL
  static const String baseUrl = 'http://localhost:3000/api';

  // API endpoints
  static const String loginEndpoint = '/v1/auth/patient/login';

  // Timeout settings
  static const Duration apiTimeout = Duration(seconds: 30);

  // Debug settings (set to false in production)
  static const bool enableApiLogging = true;
}

/*
TESTING STEPS:

1. Replace 'YOUR_BASE_URL_HERE' with your actual API URL
2. Make sure your API server is running
3. Test the login with valid credentials from your database
4. Check the debug console for API request/response logs

EXAMPLE API TESTING WITH POSTMAN/CURL:

curl -X POST \
  'YOUR_BASE_URL/v1/auth/patient/login' \
  -H 'Content-Type: application/json' \
  -d '{
    "username": "0123456789",
    "password": "securePassword123"
  }'

Expected Success Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}

Expected Error Response:
{
  "status": "error",
  "message": "invalid credentials"
}
*/