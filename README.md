# Urja View Mobile

Urja View by Indotech Meters - Advanced DLMS smart meter management mobile application built with Flutter.

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
   cd urjaview-mobile
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Install git hooks (recommended):
   ```bash
   ./scripts/install-hooks.sh
   ```

5. Run the app:
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

## Development

### Code Quality

This project enforces code quality through:

1. **Pre-commit hooks**: Automatically runs `flutter analyze` before commits
   - Install hooks: `./scripts/install-hooks.sh`
   - Skip hooks (when needed): `git commit --no-verify`

2. **Code formatting**: Dart format is checked in pre-commit
   - Format code: `dart format .`
   - Check formatting: `dart format --set-exit-if-changed --output=none .`

3. **Static analysis**: Flutter analyze catches potential issues
   - Run manually: `flutter analyze`

### Useful Commands

```bash
# Quick development script
./run_app.sh

# Run analysis
flutter analyze

# Format code
dart format .

# Run tests
flutter test

# Clean build artifacts
flutter clean
```

## Contributing

1. Install git hooks before making changes: `./scripts/install-hooks.sh`
2. Follow the existing code structure and naming conventions
3. Ensure `flutter analyze` passes before committing
4. Write clean, documented code
5. Test on both iOS and Android platforms
6. Submit pull requests with detailed descriptions

## License

This project is part of the DLMS Cloud platform.