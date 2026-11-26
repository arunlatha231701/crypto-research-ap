# API Documentation

## Crypto Research App

**Document:** REST API Documentation  
**Project:** Crypto Research App  
**Backend Framework:** Django REST Framework  
**Frontend:** Flutter  
**HTTP Client:** Dio  
**External API Provider:** CoinGecko  
**API Style:** RESTful Architecture  
**Document Version:** 1.0

---

# 1. Introduction

## 1.1 Purpose

This document describes the REST API architecture and integration approach used in the Crypto Research App.

The backend is developed using Django and provides API services consumed by the Flutter mobile application.

The backend also integrates with CoinGecko to retrieve cryptocurrency market information and individual coin details.

This document covers API organization, endpoint responsibilities, request handling, response processing, validation, error handling and external API integration.

## 1.2 API Architecture

The application follows a client-server communication architecture.

- Flutter acts as the API consumer.
- Dio handles HTTP communication.
- Django exposes REST API endpoints.
- Serializers validate and transform API data.
- Service classes handle application and integration operations.
- CoinGecko provides external cryptocurrency information.

### API Communication Flow

```text
Flutter Mobile Application
           |
           v
      Dio HTTP Client
           |
           v
     Django REST API
           |
           v
       API Views
           |
           v
       Serializers
           |
           v
      Service Layer
           |
           v
   CoinGecko Integration
           |
           v
      CoinGecko API
           |
           v
    Processed Response
           |
           v
     Flutter Application
```

---

# 2. API Environment Configuration

## 2.1 Base URL

The backend exposes its REST API through the configured Django server.

Development base URL:

```text
http://127.0.0.1:8000/
```

The actual API prefix is determined by the URL configuration in `config/urls.py`.

For production, the application should use a deployed HTTPS backend URL.

## 2.2 Environment Configuration

The API base URL should be maintained through environment-specific frontend configuration.

Example:

```dart
class ApiConfig {
  static const String baseUrl =
      String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
}
```

The example above assumes an Android emulator accessing a Django server running on the development machine.

For physical devices, use an appropriate reachable development server address.

Production configuration must use HTTPS.

---

# 3. API Modules

The backend is organized into modular Django applications.

| Module | Responsibility |
|---|---|
| Market | Cryptocurrency market information |
| Coins | Individual cryptocurrency information |
| Watchlist | Watchlist-related functionality |
| Core | Shared backend functionality |
| CoinGecko Integration | External cryptocurrency API communication |

Each module is responsible for its respective application functionality.

---

# 4. Authentication APIs

## 4.1 Overview

The application includes user authentication and persistent login functionality.

The authentication layer is responsible for:

- Processing user authentication requests.
- Validating authentication credentials.
- Returning authentication results.
- Managing authentication information.
- Supporting persistent login.
- Handling authenticated requests where required.

## 4.2 Authentication Endpoint Registry

The exact authentication URL, HTTP method and request schema must be taken from the implemented authentication views and URL configuration.

| Property | Details |
|---|---|
| Module | Authentication |
| Endpoint | To be verified from source code |
| HTTP Method | To be verified |
| Authentication | Depends on implemented authentication mechanism |
| Request Body | Depends on authentication serializer |
| Response | Depends on actual authentication response |

## 4.3 Token Management

Where token-based authentication is implemented, the frontend should store sensitive authentication information using Flutter Secure Storage.

Authentication headers should follow the backend's configured authentication scheme.

Example for a Bearer-token implementation:

```http
Authorization: Bearer <access_token>
```

The actual token format and refresh mechanism must match the backend implementation.

---

# 5. Market APIs

## 5.1 Overview

The Market module provides cryptocurrency market-related functionality.

It communicates with the CoinGecko integration layer to retrieve market information and prepares the required data for the Flutter application.

### Responsibilities

- Retrieve cryptocurrency market information.
- Process supported market query parameters.
- Validate incoming requests.
- Coordinate external market data requests.
- Serialize market information.
- Handle external API failures.

## 5.2 Market Endpoint Registry

The exact market URL and HTTP method must be verified from `apps/market/urls.py` and the corresponding views.

| Property | Details |
|---|---|
| Module | Market |
| Endpoint | To be verified |
| HTTP Method | To be verified |
| Request Parameters | To be verified |
| Serializer | MarketCoinSerializer |
| External Provider | CoinGecko |

## 5.3 Market Request Parameters

The market service supports request validation, including currency-related validation.

The exact supported parameters and accepted values must be documented from the service and serializer implementations.

| Parameter | Description | Validation |
|---|---|---|
| Currency | Target market currency | Supported currencies must be validated |
| Additional filters | Market-specific filtering | Verify actual implementation |

## 5.4 Market Response

The market API response is processed through the market serialization layer.

The project includes `MarketCoinSerializer` for market coin data.

The exact response fields and JSON structure should be taken from the serializer implementation.

---

# 6. Coin Details API

## 6.1 Overview

The Coins module provides cryptocurrency-specific information.

It supports retrieving information for an individual cryptocurrency through its coin identifier.

The implementation includes:

- Coin Details View.
- Coin Details Service.
- Coin Details Serializer.
- CoinGecko integration.
- External API exception handling.

## 6.2 Endpoint

The implemented route pattern in the Coins URL configuration is:

```http
/<str:coin_id>/
```

The complete API URL depends on the prefix configured in the main Django URL configuration.

| Property | Details |
|---|---|
| Module | Coins |
| Route pattern | `/<str:coin_id>/` |
| HTTP Method | Verify from view implementation |
| Path Parameter | coin_id |
| Serializer | CoinDetailsSerializer |
| Service | Coin Details Service |
| External Provider | CoinGecko |

## 6.3 Path Parameters

| Parameter | Type | Description |
|---|---|---|
| coin_id | String | CoinGecko cryptocurrency identifier |

Example identifier:

```text
bitcoin
```

The identifier should match the identifier expected by the CoinGecko integration.

## 6.4 Request Example

Illustrative route using the implemented relative route pattern:

```http
GET /<configured-prefix>/bitcoin/
```

The HTTP method and complete URL must be confirmed against the final URL and view configuration.

## 6.5 Response Processing

The Coin Details Service communicates with the CoinGecko integration and processes the returned cryptocurrency information.

The `CoinDetailsSerializer` is responsible for serializing the resulting coin data.

The exact JSON response fields must be documented from the actual serializer.

---

# 7. Coin Market Data

## 7.1 Overview

The project includes a `CoinMarketSerializer` for market-related coin information.

This serializer belongs to the market data representation layer.

Its actual endpoint association and serialized fields should be verified from the corresponding view and service implementations.

## 7.2 Responsibilities

- Represent cryptocurrency market information.
- Structure market-related data.
- Maintain consistent serialization.
- Support the frontend's market data presentation.

---

# 8. Watchlist APIs

## 8.1 Overview

The Watchlist module is part of the backend application structure.

It is intended to support user-selected cryptocurrency management.

## 8.2 Functional Responsibilities

Depending on the implemented endpoints, watchlist functionality may include:

- Adding cryptocurrencies to a watchlist.
- Retrieving saved cryptocurrencies.
- Removing selected cryptocurrencies.
- Maintaining user-specific watchlist information.

## 8.3 Endpoint Registry

The actual endpoint paths, HTTP methods, authentication requirements and request schemas must be verified against the Watchlist URL configuration and views.

| Operation | Method | Endpoint |
|---|---|---|
| Retrieve watchlist | To verify | To verify |
| Add coin | To verify | To verify |
| Remove coin | To verify | To verify |

These operations should only be included in the final API contract when confirmed in the source code.

---

# 9. Request and Response Handling

## 9.1 HTTP Methods

The backend uses HTTP methods according to the operation exposed by each endpoint.

| Method | General Purpose |
|---|---|
| GET | Retrieve resources |
| POST | Create resources or execute supported operations |
| PUT | Replace resources |
| PATCH | Partially update resources |
| DELETE | Remove resources |

Only methods actually implemented by the respective endpoints should be documented as supported.

## 9.2 Request Headers

Common request headers include:

```http
Content-Type: application/json
Accept: application/json
```

Authenticated endpoints may additionally require:

```http
Authorization: <configured-authentication-scheme>
```

The authentication header must follow the backend's actual configuration.

## 9.3 JSON Serialization

Django serializers are responsible for converting structured backend data into JSON-compatible responses.

The Flutter application processes the JSON response using its corresponding data models.

---

# 10. API Validation

Request validation is performed at the backend level.

The application includes validation for supported market request parameters.

Examples of validation scenarios include:

- Missing required parameters.
- Invalid cryptocurrency identifiers.
- Unsupported currency values.
- Incorrect request formats.
- Invalid authentication information.

Invalid requests should return appropriate HTTP status codes and meaningful error responses.

The exact validation rules depend on the corresponding serializer and service implementation.

---

# 11. Error Handling

## 11.1 Backend Error Handling

The CoinGecko integration includes dedicated handling for the following exception categories:

| Exception | Description |
|---|---|
| CoinGeckoAuthenticationError | External API authentication failure |
| CoinGeckoRateLimitError | External API rate limit exceeded |
| CoinGeckoAPIError | General external API error |
| CoinGeckoConnectionError | External API connection failure |

These exceptions are handled by the relevant backend view and service components.

## 11.2 HTTP Status Codes

The following table describes standard HTTP status code meanings. The actual mapping must be verified against the implemented API responses.

| Status Code | Meaning |
|---|---|
| 200 | Request successful |
| 201 | Resource created |
| 400 | Invalid request |
| 401 | Authentication required or failed |
| 403 | Permission denied |
| 404 | Resource not found |
| 429 | Too many requests |
| 500 | Internal server error |
| 502 | Upstream service failure |
| 503 | Service unavailable |

## 11.3 Frontend Error Handling

The Flutter networking layer uses Dio for HTTP communication.

The frontend should handle:

- Connection failures.
- Request timeouts.
- HTTP errors.
- Invalid response data.
- Authentication failures.
- Unexpected server responses.

The application should present understandable error messages and maintain appropriate loading and error states.

---

# 12. External API Integration

## 12.1 CoinGecko API

CoinGecko provides the external cryptocurrency market data consumed by the backend.

The Django integration layer manages communication with the external provider.

### Integration Responsibilities

- Configure external API access.
- Send cryptocurrency data requests.
- Process API responses.
- Handle authentication failures.
- Handle rate limits.
- Handle connection errors.
- Convert external errors into backend application errors.

## 12.2 Integration Architecture

```text
Flutter Client
      |
      v
Django REST Endpoint
      |
      v
Application View
      |
      v
Application Service
      |
      v
CoinGecko Integration
      |
      v
CoinGecko API
      |
      v
External JSON Response
      |
      v
Backend Processing
      |
      v
Django REST Response
      |
      v
Flutter Client
```

## 12.3 API Credential Management

External API credentials should be configured through environment variables.

Example:

```env
COINGECKO_API_KEY=your_api_key
```

The actual environment variable name must match the backend integration configuration.

Credentials must not be exposed in Flutter application source code or committed to version control.

---

# 13. API Testing

The backend API should be validated through endpoint-level testing.

Recommended test scenarios include:

| Test Scenario | Expected Result |
|---|---|
| Valid market request | Successful market data response |
| Invalid currency | Appropriate validation error |
| Valid coin identifier | Successful coin details response |
| Invalid coin identifier | Appropriate error response |
| External API authentication failure | Handled authentication exception |
| External API rate limit | Handled rate-limit exception |
| External API connection failure | Handled connection exception |
| Invalid request parameters | Appropriate validation response |

Actual execution results should be recorded in `Testing_Report.md`.

---

# 14. API Documentation Maintenance

This document should be updated whenever API functionality changes.

Updates should include:

- New endpoint registrations.
- Modified request parameters.
- Changes to response serializers.
- Authentication changes.
- New validation rules.
- Additional error-handling scenarios.
- Changes to external API integrations.

Maintaining accurate API documentation helps frontend and backend development remain consistent.

---

# 15. Conclusion

The Crypto Research App uses Django REST APIs to provide backend services to the Flutter mobile application.

The modular backend architecture separates API views, serializers, services and external integrations.

The CoinGecko integration provides cryptocurrency market information, while the frontend consumes backend responses through Dio and manages application state through Riverpod.

This API architecture establishes a structured communication layer between the mobile application, backend services and external cryptocurrency data provider.

---

**Document End**

**Project:** Crypto Research App  
**Document:** API Documentation  
**Version:** 1.0  
**Prepared for:** Technical Assignment Submission