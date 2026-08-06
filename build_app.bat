@echo off
echo 🌱 Building CashewGuard AI APK...
flutter clean
flutter pub get
flutter build apk --debug --android-skip-build-dependency-validation
echo ✅ Build complete!
echo 📁 APK location: build\app\outputs\flutter-apk\app-debug.apk
pause