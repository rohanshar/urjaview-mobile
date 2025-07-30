# UrjaView Mobile

UrjaView by Indotech Meters - Advanced DLMS smart meter management mobile application built with Flutter.

## Features

- 🔐 **Secure Authentication**: JWT-based authentication with secure token storage
- 📊 **Meter Management**: View and manage DLMS smart meters
- 📱 **Responsive Design**: Optimized for both iOS and Android
- 🎨 **Modern UI**: Material 3 design with custom theming
- 🔄 **Real-time Updates**: Live meter status and data synchronization

## Project Structure

```
lib/
├── core/
│   ├── constants/      # App constants and configurations
│   ├── theme/          # App theme and styling
│   ├── utils/          # Utilities and helpers
│   └── widgets/        # Reusable widgets
├── data/
│   ├── models/         # Data models
│   ├── repositories/   # Data repositories
│   └── services/       # API and external services
└── presentation/
    ├── auth/           # Authentication screens and logic
    ├── meters/         # Meter-related screens
    └── widgets/        # Screen-specific widgets
```

## Getting Started

### Prerequisites

- Flutter SDK (3.7.0 or higher)
- Dart SDK
- iOS/Android development environment set up

### Installation

1. Clone the repository
2. Navigate to the project directory:
   ```bash
   cd urjaview_mobile
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Configuration

The app connects to the DLMS Cloud API. Update the API base URL in:
`lib/core/constants/app_constants.dart`

## Architecture

The app follows a clean architecture pattern with:

- **Presentation Layer**: UI components and state management (Provider)
- **Domain Layer**: Business logic and repositories
- **Data Layer**: API services and data models

## State Management

- **Provider**: For app-wide state management
- **Go Router**: For navigation with deep linking support

## API Integration

The app integrates with the DLMS Cloud backend API:
- Authentication endpoints
- Meter CRUD operations
- Real-time meter data
- Job scheduling and monitoring

## Demo Credentials

For testing purposes:
- Email: `test@example.com`
- Password: `Test@123456`

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Follow the existing code structure and naming conventions
2. Write clean, documented code
3. Test on both iOS and Android platforms
4. Submit pull requests with detailed descriptions

## License

This project is part of the DLMS Cloud platform.