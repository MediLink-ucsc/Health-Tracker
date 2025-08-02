# Lab Reports API Integration

## Overview

Successfully integrated the lab reports API to replace hardcoded data in the LabReportsScreen.

## Changes Made

### 1. Updated App Configuration (`lib/config/app_config.dart`)

- Added `labReportEndpoint` constant for the lab reports API endpoint

### 2. Enhanced LabReport Model (`lib/models/lab_report.dart`)

- Extended the `LabReport` class with additional fields:
  - `id`, `reportUrl`, `testType`, `sampleType`, `status`
- Added `LabReport.fromApiResponse()` factory constructor to create objects from API response
- Added `LabReportHistoryResponse` and `LabReportData` classes to handle API response structure

### 3. Extended API Service (`lib/services/api_service.dart`)

- Added authentication headers support with `_authHeaders`
- Implemented `getLabReports(String patientId)` method to fetch lab reports from API
- Includes proper error handling for network issues, format errors, and API errors

### 4. Upgraded LabReportsScreen (`lib/screens/Reports/lab_reports_screen.dart`)

- Changed from `StatelessWidget` to `StatefulWidget` to manage state
- Added loading, error, and empty states
- Implemented API data fetching in `_fetchLabReports()` method
- Added pull-to-refresh functionality
- Enhanced UI with status badges, better error handling, and loading indicators
- Added refresh button in app bar

## API Integration Details

### Endpoint

```
{{BASE_URL}}/v1/labReport/workflow/patients/PAT001/history
```

### Authentication

- Uses Bearer token authentication (token retrieved from AuthService)
- Falls back gracefully if no token is available

### Current Patient ID

- Currently hardcoded as 'PAT001'
- **TODO**: Replace with actual patient ID from user session/authentication

### Error Handling

- Network connectivity issues
- Server errors
- Invalid response formats
- Authentication failures

## Features Added

1. **Loading States**: Shows spinner while fetching data
2. **Error Handling**: User-friendly error messages with retry option
3. **Empty States**: Message when no reports are found
4. **Pull-to-Refresh**: Users can refresh by pulling down
5. **Status Indicators**: Color-coded status badges for each report
6. **Enhanced Details**: Shows test type, sample type, and limited extracted details preview
7. **Refresh Button**: Manual refresh option in app bar

## Next Steps

1. **Patient ID Management**: Replace hardcoded patient ID with dynamic value from user session
2. **Authentication Integration**: Ensure proper login flow saves patient ID for API calls
3. **Offline Support**: Consider caching reports for offline viewing
4. **Error Recovery**: Implement more sophisticated retry mechanisms
5. **Performance**: Add pagination if the number of reports becomes large

## Testing

To test the integration:

1. Ensure the API server is running and accessible
2. Make sure a valid authentication token is available
3. Verify the patient ID 'PAT001' exists in the system
4. Check network connectivity
5. Monitor API logs for debugging if needed

## Notes

- The integration maintains backward compatibility with the existing ViewReportScreen
- All existing UI interactions remain functional
- Added proper TypeScript-like error handling for better reliability
- The API response structure is fully mapped to Flutter objects for type safety
