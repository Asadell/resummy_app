# 🚀 Resummy App

<p align="center">
  <img src="assets/icon/icon.png" alt="Resummy Logo" width="120"/>
</p>

<p align="center">
  <strong>AI-Powered Resume Builder & Career Preparation App</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-blue?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.0+-blue?logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/Firebase-Enabled-orange?logo=firebase" alt="Firebase"/>
  <img src="https://img.shields.io/badge/Material%203-Enabled-purple" alt="Material 3"/>
</p>

---

## 📖 About

**Resummy** adalah aplikasi mobile yang membantu pengguna dalam:
- 📝 **CV Builder** - Membuat CV profesional dengan template modern
- 🌐 **CV Translator** - Menerjemahkan CV ke berbagai bahasa
- 📊 **CV Analyzer** - Menganalisis kualitas CV dengan AI
- 🎤 **Interview Prep** - Latihan interview dengan AI interviewer
- 📈 **Progress Tracking** - Melacak perkembangan skill dan performa

---

## 🏗️ Project Structure

```
lib/
├── app/                          # App-level configuration
│   ├── app.dart                  # Root MaterialApp widget
│   └── routes/                   # Auto Route configuration
│       ├── app_router.dart       # Route definitions
│       └── app_router.gr.dart    # Generated routes
│
├── core/                         # Core utilities & shared logic
│   ├── constants/                # App constants
│   ├── errors/                   # Error handling (Failure, Exception)
│   ├── l10n/                     # Localization (i18n)
│   │   ├── arb/                  # ARB translation files
│   │   │   ├── app_en.arb        # English translations
│   │   │   └── app_id.arb        # Indonesian translations
│   │   ├── app_localizations.dart
│   │   └── app_localizations_*.dart
│   ├── providers/                # Global state providers
│   │   ├── locale_provider.dart  # Language preference
│   │   └── theme_provider.dart   # Dark/Light mode
│   ├── theme/                    # App theming
│   │   ├── app_colors.dart       # Color palette
│   │   └── app_theme.dart        # ThemeData (Light & Dark)
│   └── utils/                    # Helper functions
│
├── features/                     # Feature modules (Clean Architecture)
│   ├── auth/                     # Authentication & Onboarding
│   │   ├── data/                 # Repositories, Data Sources
│   │   ├── domain/               # Entities, Use Cases
│   │   └── presentation/         # Screens, Widgets
│   │
│   ├── cv_tools/                 # CV Builder, Translator, Analyzer
│   │   └── presentation/screens/
│   │       ├── builder/          # 7-step CV creation
│   │       ├── translator/       # Translation flow
│   │       ├── analyzer/         # AI analysis
│   │       └── history/          # CV history
│   │
│   ├── interview/                # Interview Preparation
│   │   └── presentation/screens/
│   │       ├── setup/            # Interview configuration
│   │       ├── session/          # Live interview session
│   │       └── feedback/         # AI feedback & recommendations
│   │
│   ├── home/                     # Dashboard & Hub screens
│   ├── history/                  # Activity history
│   └── profile/                  # User settings
│
├── shared/                       # Shared components
│   └── widgets/                  # Reusable UI widgets
│       ├── bottom_nav_bar.dart
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       ├── error_display.dart
│       └── loading_indicator.dart
│
└── main.dart                     # App entry point
```

---

## 🎨 Theming System

### Color Palette

| Color | Light Mode | Dark Mode | Usage |
|-------|-----------|-----------|-------|
| **Primary** | `#0EA5E9` (Sky Blue) | `#38BDF8` | Buttons, Links, Highlights |
| **Secondary** | `#10B981` (Emerald) | `#4ADE80` | Success states, Accents |
| **Error** | `#EF4444` | `#F87171` | Error messages, Alerts |
| **Surface** | `#FFFFFF` | `#1E293B` | Cards, Dialogs |
| **Background** | `#FAFAFA` | `#0F172A` | Screen backgrounds |

### Menggunakan Theme

```dart
// Mengakses warna dari Theme
final primaryColor = Theme.of(context).colorScheme.primary;
final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

// Menggunakan AppColors langsung
import 'package:resummy_app/core/theme/app_colors.dart';
final customBlue = AppColors.primary500;
```

### Dark/Light Mode Toggle

Theme dikelola oleh `ThemeProvider` dengan persistence ke `SharedPreferences`:

```dart
// Di widget manapun
final themeProvider = Provider.of<ThemeProvider>(context);

// Cek mode saat ini
bool isDark = themeProvider.isDarkMode;

// Toggle theme
themeProvider.toggleTheme();

// Set specific mode
themeProvider.setDarkMode(true);
```

Theme akan tersimpan dan otomatis di-load saat app restart.

---

## 🌍 Localization (L10n)

Aplikasi mendukung multi-bahasa menggunakan Flutter's built-in localization:

### Bahasa yang Didukung
- 🇮🇩 **Indonesian (id)** - Default
- 🇺🇸 **English (en)**

### File Struktur

```
lib/core/l10n/
├── arb/
│   ├── app_en.arb          # English strings
│   └── app_id.arb          # Indonesian strings
├── app_localizations.dart  # Generated localizations
├── app_localizations_en.dart
└── app_localizations_id.dart
```

### Menambah String Baru

1. **Tambahkan ke ARB files:**

```json
// lib/core/l10n/arb/app_en.arb
{
  "welcomeMessage": "Welcome to Resummy!",
  "@welcomeMessage": {
    "description": "Welcome message on home screen"
  }
}
```

```json
// lib/core/l10n/arb/app_id.arb
{
  "welcomeMessage": "Selamat datang di Resummy!"
}
```

2. **Generate localization files:**
```bash
flutter gen-l10n
```

3. **Gunakan di Widget:**
```dart
import 'package:resummy_app/core/l10n/app_localizations.dart';

Text(AppLocalizations.of(context)!.welcomeMessage)
```

### Mengubah Bahasa

```dart
final localeProvider = Provider.of<LocaleProvider>(context);

// Set bahasa
localeProvider.setLocale(const Locale('en')); // English
localeProvider.setLocale(const Locale('id')); // Indonesian

// Cek bahasa saat ini
Locale currentLocale = localeProvider.locale;
```

---

## 🧩 Shared Widgets

Reusable widgets tersedia di `lib/shared/widgets/`:

### CustomButton

```dart
import 'package:resummy_app/shared/widgets/custom_button.dart';

CustomButton(
  text: 'Submit',
  onPressed: () => doSomething(),
  isLoading: false,
  isOutlined: false, // true for outlined style
)
```

### CustomTextField

```dart
import 'package:resummy_app/shared/widgets/custom_text_field.dart';

CustomTextField(
  label: 'Email',
  hint: 'Enter your email',
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  validator: (value) => value!.isEmpty ? 'Required' : null,
)
```

### LoadingIndicator

```dart
import 'package:resummy_app/shared/widgets/loading_indicator.dart';

// Default circular indicator
const LoadingIndicator()

// With custom message
const LoadingIndicator(message: 'Loading data...')
```

### ErrorDisplay

```dart
import 'package:resummy_app/shared/widgets/error_display.dart';

ErrorDisplay(
  message: 'Something went wrong',
  onRetry: () => retryAction(),
)
```

---

## 🛣️ Navigation (Auto Route)

Aplikasi menggunakan [Auto Route](https://pub.dev/packages/auto_route) untuk type-safe navigation.

### Navigasi Dasar

```dart
import 'package:resummy_app/app/routes/app_router.gr.dart';

// Push to new screen
context.router.push(const HomeRoute());

// Replace current screen
context.router.replace(const LoginRoute());

// Pop back
context.router.pop();

// Push and remove all previous
context.router.replaceAll([const MainLayoutRoute()]);
```

### Definisi Route

Routes didefinisikan di `lib/app/routes/app_router.dart`:

```dart
@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: MainLayoutRoute.page, children: [
      AutoRoute(page: HomeRoute.page),
      AutoRoute(page: CvToolsHubRoute.page),
      AutoRoute(page: InterviewPrepRoute.page),
      AutoRoute(page: HistoryRoute.page),
      AutoRoute(page: ProfileRoute.page),
    ]),
    // ... more routes
  ];
}
```

### Regenerate Routes

Setelah menambah/mengubah routes, jalankan:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart `>=3.0.0`
- Node.js (untuk Firebase CLI)

### Installation

```bash
# 1. Clone repository
git clone https://github.com/yourusername/resummy_app.git
cd resummy_app

# 2. Install dependencies
flutter pub get

# 3. Generate files
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n

# 4. Setup Firebase (lihat section berikutnya)
```

---

## 🔥 Firebase Setup (Untuk Tim)

> **PENTING:** Setiap developer harus setup Firebase-nya sendiri karena SHA-1 fingerprint berbeda per device.

### Step 1: Install Firebase CLI

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login ke Firebase (gunakan akun yang sudah di-invite ke project)
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Jika flutterfire command not found:
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### Step 2: Configure FlutterFire

```bash
# Di root folder project
flutterfire configure

# Pilih project: resummy-app-xxxxx
# Pilih platforms: android, web
```

Ini akan generate/update `lib/firebase_options.dart`.

### Step 3: Setup SHA-1 (Android)

**Kenapa perlu?** Google Sign-In butuh SHA-1 fingerprint untuk security.

```bash
# Cara 1: Via Gradle
cd android
./gradlew signingReport

# Copy SHA-1 dari output "Variant: debug"
# Contoh: A1:B2:C3:D4:E5:F6:...

# Cara 2: Via keytool
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**Tambahkan SHA-1 ke Firebase Console:**

1. Buka [Firebase Console](https://console.firebase.google.com/) → Project Settings (⚙️)
2. Scroll ke "Your apps" → Pilih Android app
3. Click **"Add fingerprint"** → Paste SHA-1 → Save
4. **Download `google-services.json`** → Taruh di `android/app/`

### Step 4: Verify Setup

```bash
flutter run
```

Jika berhasil, app akan jalan tanpa error Firebase!

---

## 🛡️ Firestore Security Rules

Rules saat ini (development mode):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users: hanya bisa akses data sendiri
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // CVs: hanya pemilik yang bisa akses
    match /cvs/{cvId} {
      allow read, write: if request.auth != null && resource.data.userId == request.auth.uid;
    }
    
    // Interviews: hanya pemilik yang bisa akses
    match /interviews/{interviewId} {
      allow read, write: if request.auth != null && resource.data.userId == request.auth.uid;
    }
  }
}
```

> ⚠️ **Production:** Rules ini perlu di-hardening sebelum release!

---

## 🐛 Common Firebase Issues

| Issue | Solution |
|-------|----------|
| `flutterfire: command not found` | `export PATH="$PATH":"$HOME/.pub-cache/bin"` |
| Google Sign-In error | Pastikan SHA-1 sudah ditambahkan di Firebase Console |
| `google-services.json` not found | Download dari Firebase Console → taruh di `android/app/` |
| Permission denied Firestore | Cek user sudah login & rules benar |

---

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.1 | State Management |
| `auto_route` | ^9.2.2 | Navigation |
| `firebase_core` | ^3.6.0 | Firebase Core |
| `firebase_auth` | ^5.3.0 | Authentication |
| `cloud_firestore` | ^5.4.4 | Database |
| `google_fonts` | ^6.1.0 | Typography |
| `shared_preferences` | ^2.3.2 | Local Storage |
| `get_it` | ^8.0.0 | Dependency Injection |

---

## 📱 Screenshots

> Coming soon...

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

<p align="center">
  Made with ❤️ by Resummy Team
</p>
