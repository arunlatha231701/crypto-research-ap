# Crypto Research App

### Cryptocurrency Market Research & Analysis Platform

**Project Type:** Full-Stack Mobile Application  
**Frontend:** Flutter & Dart  
**Backend:** Django REST API  
**External Data Provider:** CoinGecko API  
**Architecture:** MVVM (Frontend)  
**State Management:** Riverpod 3

---

## 1. Project Overview

Crypto Research App is a mobile application designed to help users explore cryptocurrency market information, monitor digital assets and access cryptocurrency-related insights through an integrated mobile and backend architecture.

The application uses Flutter for its cross-platform mobile interface and Django for backend API development. Cryptocurrency market information is integrated through the CoinGecko API.

The project follows a modular architecture to maintain separation of concerns, scalability, maintainability and code reusability.

## 2. Key Features

### Authentication
- User authentication.
- Persistent login functionality.
- Secure token storage.
- Authentication session management.

### Cryptocurrency Market
- Cryptocurrency market information.
- Market data retrieval through CoinGecko.
- Cryptocurrency ranking and price information.

### Coin Details
- Individual cryptocurrency information.
- Market-related details.
- API-driven data presentation.

### Watchlist
- Watchlist module for managing selected cryptocurrencies.
- Cryptocurrency data integration.

### Dashboard
- Centralized market information.
- Market statistics and cryptocurrency insights.
- Visual market analysis.

*Note: The exact completion status of each dashboard and watchlist feature should be verified against the current source code before submission.*

## 3. Technology Stack

| Category | Technology |
|---|---|
| Mobile framework | Flutter |
| Programming language | Dart |
| State management | Riverpod 3 |
| Architecture | MVVM |
| Navigation | GoRouter |
| HTTP client | Dio |
| Charts | FL Chart |
| Local database | Hive |
| Preferences | SharedPreferences |
| Secure storage | Flutter Secure Storage |
| Backend | Django |
| API integration | CoinGecko |
| API communication | REST |

## 4. Project Architecture

### Frontend Architecture

The Flutter application follows the MVVM architecture pattern.

- **Model:** Represents application data and data structures.
- **View:** Handles the user interface and user interactions.
- **ViewModel:** Manages application state, business logic and communication with repositories or services.

Riverpod is used for state management, while Dio handles HTTP communication with the backend.

### Backend Architecture

The backend follows a modular Django application structure.

```text
backend/
│
├── apps/
│   ├── market/
│   ├── coins/
│   └── watchlist/
│
├── config/
│   ├── settings.py
│   ├── urls.py
│   ├── asgi.py
│   └── wsgi.py
│
├── core/
│
├── integrations/
│   └── coingecko/
│
├── manage.py
└── requirements.txt
```

The backend separates application modules, configuration, shared functionality and external API integrations.

## 5. External API Integration

The application integrates with CoinGecko to retrieve cryptocurrency market information.

The integration is organized into a dedicated service layer.

The backend handles:
- External API communication.
- Response processing.
- Data serialization.
- Request validation.
- API exception handling.
- Connection and rate-limit errors.

The Django backend acts as the integration layer between the mobile application and the external cryptocurrency data provider.

## 6. Prerequisites

Before running the project, install:

### Frontend
- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Android SDK or Xcode for the respective platform

### Backend
- Python
- pip
- Virtual environment support
- Django and project dependencies
- CoinGecko API access/configuration as required

## 7. Installation and Setup

### Backend Setup

Navigate to the backend directory:

```bash
cd backend
```

Create a virtual environment:

```bash
python -m venv venv
```

Activate it on Windows:

```powershell
.\venv\Scripts\Activate.ps1
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Configure environment variables using the project's `.env` configuration.

Apply database migrations:

```bash
python manage.py migrate
```

Start the Django development server:

```bash
python manage.py runserver
```

Backend default development address:

```text
http://127.0.0.1:8000/
```

### Frontend Setup

Navigate to the frontend directory:

```bash
cd frontend
```

Install Flutter dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

**Important:** Configure the frontend API base URL to point to the appropriate backend environment. Android emulators, physical devices and local development machines may require different host addresses.

## 8. Environment Configuration

Sensitive credentials and environment-specific configuration must not be committed to source control.

Use a local `.env` file for backend configuration.

Example placeholder:

```env
DEBUG=True
SECRET_KEY=your_secret_key
ALLOWED_HOSTS=localhost,127.0.0.1
COINGECKO_API_KEY=your_api_key
```

The actual environment variable names must match the backend settings and CoinGecko integration implementation.

Never include actual credentials in the assignment ZIP.

## 9. Error Handling

The backend integration includes handling for different external API failure scenarios, including:

- Authentication errors.
- API rate-limit errors.
- General API errors.
- Network connection errors.

The frontend should handle API failures and display appropriate user-facing feedback.

## 10. Security Considerations

- Secure storage for authentication tokens.
- Environment-based configuration.
- Avoid committing API credentials.
- Backend-side request validation.
- Appropriate API exception handling.
- HTTPS for production API communication.

## 11. Testing

The application should be verified through:

- Authentication testing.
- Persistent login validation.
- Market API integration testing.
- Cryptocurrency details testing.
- Watchlist testing.
- Invalid request validation.
- API connection failure testing.
- Backend Django system checks.

Refer to `documentation/Testing_Report.md` for detailed test cases and execution results.

## 12. Future Enhancements

Potential enhancements include:

- Advanced cryptocurrency analytics.
- Interactive historical market charts.
- Portfolio tracking and performance analysis.
- Custom cryptocurrency price alerts.
- Push notifications.
- Expanded watchlist functionality.

These enhancements are subject to implementation and are not represented as completed features.

## 13. Project Objective

The objective of this project is to develop a maintainable, modular and scalable cryptocurrency research platform by combining Flutter mobile development, Django backend services and external cryptocurrency market data integration.

---

**Developed as a Full-Stack Mobile Application Project**

**Technology:** Flutter | Django | Python | Riverpod | CoinGecko API