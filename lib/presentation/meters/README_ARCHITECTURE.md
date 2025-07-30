# Meter Module Architecture

## Overview
The meter module follows a scalable, production-ready architecture with clear separation of concerns.

## Directory Structure

```
meters/
├── navigation/                    # Navigation controllers
│   └── meter_navigation_controller.dart
├── providers/                     # State management
│   └── meter_provider.dart
├── screens/                       # Screen components
│   ├── meters_list_screen.dart    # Main meters list
│   ├── meter_detail_screen_v2.dart # Main detail screen with tabs
│   └── tabs/                      # Individual tab screens
│       ├── meter_overview_screen.dart
│       ├── meter_data_screen.dart
│       ├── meter_live_screen.dart
│       ├── meter_jobs_screen.dart
│       ├── meter_schedules_screen.dart
│       ├── meter_settings_screen.dart
│       └── live/                  # Live sub-tab screens
│           ├── meter_live_general_screen.dart
│           ├── meter_live_objects_screen.dart
│           ├── meter_live_realtime_screen.dart
│           ├── meter_live_events_screen.dart
│           ├── meter_live_load_survey_screen.dart
│           └── meter_live_billing_screen.dart
└── widgets/                       # Reusable widgets
    ├── meter_card.dart
    ├── meter_overview_tab.dart
    ├── meter_data_tab.dart
    ├── meter_live_tab.dart
    ├── meter_jobs_tab.dart
    ├── meter_schedules_tab.dart
    ├── meter_settings_tab.dart
    └── live_tabs/                 # Live tab widgets
        ├── general_tab.dart
        ├── objects_tab.dart
        ├── realtime_tab.dart
        ├── events_tab.dart
        ├── load_survey_tab.dart
        └── billing_tab.dart
```

## Architecture Principles

### 1. Separation of Concerns
- **Screens**: Handle navigation and screen lifecycle
- **Widgets**: Contain UI logic and presentation
- **Providers**: Manage state and business logic
- **Navigation**: Control tab and sub-tab navigation

### 2. Scalability
- Each tab is a separate screen, allowing independent development
- Sub-tabs follow the same pattern for consistency
- Easy to add new tabs or modify existing ones

### 3. State Management
- `MeterProvider`: Manages meter data and API calls
- `MeterNavigationController`: Manages tab navigation state
- Providers are scoped appropriately to avoid memory leaks

### 4. Code Organization
- Clear file naming convention
- Logical grouping of related components
- Easy to locate and modify specific features

## Adding New Features

### Adding a New Tab
1. Create a new screen in `screens/tabs/`
2. Create corresponding widget in `widgets/`
3. Add to `MeterDetailScreenV2` TabBar and TabBarView
4. Update navigation controller if needed

### Adding a New Live Sub-Tab
1. Create a new screen in `screens/tabs/live/`
2. Create corresponding widget in `widgets/live_tabs/`
3. Add to `MeterLiveScreen` TabBar and TabBarView
4. Update navigation controller for sub-tab tracking

## Benefits
- **Maintainability**: Clear structure makes it easy to find and modify code
- **Performance**: Lazy loading of tabs improves initial load time
- **Testability**: Each component can be tested in isolation
- **Reusability**: Widgets can be reused across different screens
- **Team Collaboration**: Clear boundaries allow multiple developers to work simultaneously