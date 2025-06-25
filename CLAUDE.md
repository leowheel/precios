# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application called "precios" (Spanish for "prices") that's currently in its initial template state. The project is configured for multi-platform deployment (mobile, web, and desktop).

## Development Commands

```bash
# Development
flutter run                    # Run the app on connected device/emulator
flutter run -d chrome         # Run on web browser
flutter run -d macos          # Run on macOS (if on macOS)

# Dependencies
flutter pub get               # Install dependencies
flutter pub upgrade           # Update dependencies

# Code Quality
flutter analyze              # Static analysis and linting
flutter test                 # Run all tests

# Building
flutter build apk           # Build Android APK
flutter build appbundle     # Build Android App Bundle
flutter build ios           # Build iOS app
flutter build web           # Build web app
flutter build macos         # Build macOS app
flutter build linux         # Build Linux app
flutter build windows       # Build Windows app

# Utilities
flutter clean               # Clean build artifacts
flutter doctor              # Check Flutter installation
```

## Project Structure

- **`lib/`** - Main Dart application code
  - `main.dart` - Application entry point (currently template counter app)
- **`test/`** - Widget and unit tests
- **Platform-specific directories:**
  - `android/` - Android configuration
  - `ios/` - iOS configuration  
  - `web/` - Web deployment files
  - `macos/`, `linux/`, `windows/` - Desktop platform configurations

## Configuration

- **SDK Version:** Dart ^3.8.1
- **Dependencies:** Minimal setup with `cupertino_icons`
- **Linting:** Uses `flutter_lints` package with standard Flutter rules
- **Platforms:** Configured for mobile, web, and desktop

## Architecture Notes

Currently uses the default Flutter template architecture:
- Material Design UI framework
- StatefulWidget pattern for state management
- Standard Flutter project organization

The app is ready for development but needs custom business logic implementation for the intended price-related functionality.