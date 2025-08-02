// Quick Test Configuration for API Integration
// This file shows how to quickly test your API integration

/* 
STEP 1: Configure your API URL
Edit lib/config/app_config.dart and replace 'YOUR_BASE_URL_HERE' with your actual API URL

Examples:
- Local development: 'http://localhost:3000'
- Android emulator: 'http://10.0.2.2:3000'  
- Production: 'https://api.yourdomain.com'

STEP 2: Test your API endpoint manually first
Use curl or Postman to test:

curl -X POST \
  'YOUR_API_URL/v1/auth/patient/login' \
  -H 'Content-Type: application/json' \
  -d '{
    "username": "0123456789",
    "password": "testPassword123"
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

STEP 3: Test in your Flutter app
1. Run: flutter run
2. Try logging in with valid credentials
3. Check debug console for API logs
4. Verify token storage works

STEP 4: Enable debug logging
In app_config.dart, make sure:
static const bool enableApiLogging = true;

This will show all API requests/responses in the debug console.

STEP 5: Production setup
Before releasing:
1. Set enableApiLogging = false
2. Use HTTPS URLs
3. Test with real production credentials
4. Verify token security

The app is now ready for API integration!
*/

void main() {
  print('API Integration Setup Complete!');
  print('Follow the steps in this file to configure your API.');
}
