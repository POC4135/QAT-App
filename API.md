# QAT API Reference

**Base URL:** `https://api.qat-app.com/v1`  
**Auth:** Bearer token in `Authorization` header  
**Format:** JSON request/response

---

## Authentication

### `POST /auth/send-otp`
Send a 6-digit OTP via SMS to a phone number.

**Request**
```json
{ "phone": "+919876543210" }
```
**Response** `200`
```json
{ "success": true, "message": "OTP sent", "expiresIn": 300 }
```

---

### `POST /auth/verify-otp`
Verify OTP and receive an access token.

**Request**
```json
{ "phone": "+919876543210", "code": "482910" }
```
**Response** `200`
```json
{
  "accessToken": "eyJ...",
  "user": { "id": "...", "fullName": "John Doe", "onboardingCompleted": false }
}
```
**Errors:** `400 INVALID_CODE`, `410 CODE_EXPIRED`

---

### `POST /auth/google`
Google OAuth sign-in.

**Request**
```json
{ "idToken": "google-id-token" }
```
**Response** Same as verify-otp.

---

### `POST /auth/sign-out`
Invalidate the current session token. Auth required.

---

## Onboarding

All endpoints require auth. All return `{ success: true }`.

### `POST /onboarding/profile`
```json
{ "fullName": "John Doe", "phone": "+919876543210", "email": "john@example.com", "dateOfBirth": "1985-06-15" }
```

### `POST /onboarding/location`
```json
{ "streetLine1": "123 Emerald St", "streetLine2": "Building A, Unit 203", "city": "San Francisco", "state": "CA", "zipCode": "94105", "country": "US", "houseIdentifier": "A-203", "latitude": 37.7749, "longitude": -122.4194 }
```

### `POST /onboarding/medical`
```json
{
  "doctors": [{ "name": "Dr. Sarah Lee", "specialty": "Cardiologist", "hospital": "City General", "phone": "+918111111888" }],
  "allergies": [{ "name": "Penicillin", "severity": "severe" }],
  "medications": [{ "name": "Amlodipine", "dosage": "5mg", "frequency": "Once daily" }]
}
```

### `POST /onboarding/health`
```json
{
  "preferredHospitals": [{ "name": "City General Hospital", "address": "123 Health Blvd" }],
  "preferredDoctors": ["doctor-id-1"]
}
```

### `POST /onboarding/emergency-contacts`
```json
{
  "contacts": [
    { "fullName": "Emily Smith", "phone": "+15550001111", "relation": "Daughter", "isPrimary": true }
  ]
}
```

### `POST /onboarding/household`
```json
{
  "members": [
    { "fullName": "Jane Doe", "phone": "+15550002222", "email": "jane@example.com" }
  ]
}
```

### `POST /onboarding/complete`
Marks onboarding as complete. Returns updated user object.

---

## User

### `GET /user/me`
Returns the authenticated user's full profile.

### `PATCH /user/me`
Update user profile fields (partial update).

---

## Devices

### `GET /devices`
List all devices for the authenticated user.

**Response**
```json
{
  "data": [
    { "id": "...", "name": "Gateway", "type": "gateway", "status": "online", "batteryLevel": null, "connectionType": "MAIN HUB", "isOnline": true }
  ]
}
```

### `GET /devices/:id`
Get a single device by ID.

### `POST /devices/system-test`
Trigger a system diagnostic test across all devices.

**Response** `202`
```json
{ "success": true, "testId": "test-...", "message": "System test initiated" }
```

---

## Alert History

### `GET /alerts`
Paginated alert history for the user.

**Query params:** `category` (emergency|system), `page` (default 1), `limit` (default 20)

**Response**
```json
{
  "data": [
    {
      "id": "...",
      "type": "gas_leak",
      "category": "emergency",
      "title": "Gas Leak Detected",
      "description": "Kitchen Sensor triggered",
      "timestamp": "2026-04-28T10:30:00.000Z",
      "deviceName": "Gas Detector",
      "resolved": false
    }
  ],
  "total": 5,
  "page": 1,
  "limit": 20,
  "hasMore": false
}
```

---

## SOS

### `POST /sos/trigger`
Trigger an SOS event. Immediately notifies emergency contacts.

**Request** (optional)
```json
{ "locationSnapshot": "123 Maple St, Springfield" }
```
**Response** `201`
```json
{ "sosId": "sos-...", "status": "active", "escalatesAt": "2026-04-28T10:30:07.000Z" }
```

### `POST /sos/:sosId/cancel`
Cancel an active SOS event. Marks user as safe.

**Response** `200`
```json
{ "success": true, "message": "SOS cancelled. You have been marked safe." }
```

### `POST /sos/:sosId/notify`
Manually re-notify all emergency contacts for an active SOS.

---

## Error Format

All errors return:
```json
{
  "success": false,
  "error": {
    "code": "INVALID_CODE",
    "message": "The OTP code is incorrect.",
    "statusCode": 400
  }
}
```

| Code | Meaning |
|------|---------|
| `INVALID_CODE` | OTP is wrong |
| `CODE_EXPIRED` | OTP has expired (5 min TTL) |
| `UNAUTHORIZED` | Missing or invalid Bearer token |
| `NOT_FOUND` | Resource doesn't exist |
| `RATE_LIMITED` | Too many OTP requests |
| `SERVER_ERROR` | Internal server error |
