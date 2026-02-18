<p align="center">
  <img src="assets/icon/icon.png" alt="Resummy Logo" width="140"/>
</p>

<h1 align="center">✨ Resummy</h1>

<p align="center">
  <strong>AI-Powered Resume Builder & Career Preparation Platform</strong><br/>
  <em>Built with Flutter · Powered by Gemini AI · Works Offline</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Gemini_AI-Powered-4285F4?logo=google&logoColor=white" />
  <img src="https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase&logoColor=black" />
  <img src="https://img.shields.io/badge/Offline-Ready-34A853?logo=android&logoColor=white" />
  <img src="https://img.shields.io/badge/Material_3-Design-6750A4" />
</p>

---

## 📋 Daftar Isi

| # | Topik | Deskripsi |
|---|-------|-----------|
| 1 | [🎯 Tentang Resummy](#-tentang-resummy) | Visi, misi, dan keunggulan aplikasi |
| 2 | [✨ Fitur Utama](#-fitur-utama) | CV Builder, Analyzer, Translator, Interview Prep |
| 3 | [📸 Screenshots](#-screenshots) | Tampilan visual aplikasi |
| 4 | [🏗️ Arsitektur](#️-arsitektur) | Clean Architecture & struktur folder |
| 5 | [🤖 Gemini AI Round-Robin](#-gemini-ai-round-robin) | Sistem multi-key load balancing |
| 6 | [📦 Offline Architecture](#-offline-architecture) | SQLite + Sync Queue |
| 7 | [🎨 Theming System](#-theming-system) | Dark/Light mode & color palette |
| 8 | [🌍 Localization](#-localization) | Multi-bahasa (ID & EN) |
| 9 | [🛣️ Navigasi](#️-navigasi) | Auto Route type-safe navigation |
| 10 | [⚙️ Konfigurasi](#️-konfigurasi) | Setup default & kustom |
| 11 | [🚀 Getting Started](#-getting-started) | Instalasi & menjalankan app |
| 12 | [🔥 Firebase Setup](#-firebase-setup) | Konfigurasi Firebase untuk tim |
| 13 | [📦 Dependencies](#-dependencies) | Daftar paket yang digunakan |

---

## 🎯 Tentang Resummy

**Resummy** adalah aplikasi mobile berbasis AI yang dirancang untuk membantu para pencari kerja dan profesional dalam mempersiapkan karir mereka secara menyeluruh — mulai dari membuat CV yang menarik, menganalisis kualitasnya, menerjemahkannya ke berbagai bahasa, hingga berlatih wawancara kerja dengan AI interviewer yang realistis.

### 💡 Mengapa Resummy?

> Di era persaingan kerja yang semakin ketat, memiliki CV yang baik dan kemampuan interview yang solid adalah kunci. Resummy hadir sebagai *career companion* yang cerdas, tersedia 24/7, dan bekerja bahkan tanpa koneksi internet.

| Masalah | Solusi Resummy |
|---------|----------------|
| CV tidak menarik / tidak ATS-friendly | CV Builder dengan template profesional + AI Analyzer |
| Tidak tahu cara menjawab pertanyaan interview | AI Interview Simulator dengan feedback STAR |
| CV hanya dalam satu bahasa | CV Translator ke berbagai bahasa |
| Tidak bisa pakai app tanpa internet | Offline-first architecture dengan SQLite |
| Biaya AI mahal & sering quota habis | Gemini Round-Robin dengan 51 API keys |

---

## ✨ Fitur Utama

### 📝 CV Builder

CV Builder yang komprehensif dengan **8 langkah terstruktur** untuk menghasilkan CV profesional.

**Langkah-langkah:**
1. **Data Pribadi** — Nama, kontak, foto profil
2. **Ringkasan** — Professional summary dengan panduan AI
3. **Pengalaman Kerja** — Multi-entry dengan format terstruktur
4. **Pendidikan** — Riwayat pendidikan lengkap
5. **Organisasi** — Pengalaman organisasi & kepanitiaan
6. **Keahlian** — Technical & soft skills
7. **Sertifikasi** — Sertifikat & penghargaan
8. **Section Manager** — Atur urutan & visibilitas setiap section

**Keunggulan:**
- ✅ Preview CV real-time di tab "Lihat CV" (segmented control modern)
- ✅ Custom Section — tambah section bebas dengan 5 template (Experience-like, Education-like, Skills-like, Bullet List, Paragraph)
- ✅ Drag & drop untuk mengatur urutan section
- ✅ Toggle visibilitas section tanpa menghapus data
- ✅ Export ke PDF (Download & Share)
- ✅ Auto-save ke Firestore & lokal

---

### 📊 CV Analyzer

Analisis mendalam kualitas CV menggunakan Gemini AI.

**Yang dianalisis:**
- 🎯 **ATS Score** — Seberapa ramah CV terhadap sistem ATS
- 📝 **Content Quality** — Kualitas konten dan relevansi
- 🔤 **Language & Grammar** — Tata bahasa dan ejaan
- 📐 **Format & Structure** — Keterbacaan dan layout
- 💡 **Improvement Suggestions** — Saran perbaikan spesifik

**Output:** Laporan lengkap dengan skor per kategori dan rekomendasi actionable.

---

### 🌐 CV Translator (ATS Converter)

Terjemahkan CV ke berbagai bahasa dengan mempertahankan format dan konteks profesional.

**Fitur:**
- Terjemahan berbasis AI yang memahami konteks karir
- Mempertahankan terminologi industri yang tepat
- Mendukung berbagai bahasa target
- Preview hasil terjemahan sebelum disimpan

---

### 🎤 Interview Prep

Simulator wawancara kerja yang realistis dengan AI interviewer.

**Alur Interview:**
1. **Setup** — Pilih CV, posisi, job description, preferensi bahasa & jumlah pertanyaan
2. **Session** — Wawancara real-time dengan speech-to-text
3. **Feedback** — Analisis mendalam per pertanyaan

**Feedback yang diberikan:**
- 📊 **Overall Score** — Skor keseluruhan (0-100)
- 🌟 **STAR Analysis** — Evaluasi Situation, Task, Action, Result
- 💬 **Detailed Feedback** — Komentar per pertanyaan
- 📈 **Improved Speech** — Contoh jawaban yang lebih baik
- 🎯 **Recommendations** — Saran pengembangan skill

---

## 📸 Screenshots

> 💡 *Tempatkan screenshot fitur di sini untuk menampilkan tampilan aplikasi.*

### CV Builder
<!-- Tambahkan screenshot CV Builder di sini -->
| Langkah 1 - Data Pribadi | Langkah 8 - Section Manager | Preview CV |
|:---:|:---:|:---:|
| ![CV Builder Step 1](docs/screenshots/cv_builder_step1.png) | ![Section Manager](docs/screenshots/cv_builder_manager.png) | ![CV Preview](docs/screenshots/cv_preview.png) |

### Interview Prep
<!-- Tambahkan screenshot Interview di sini -->
| Setup Interview | Sesi Wawancara | Feedback Detail |
|:---:|:---:|:---:|
| ![Interview Setup](docs/screenshots/interview_setup.png) | ![Interview Session](docs/screenshots/interview_session.png) | ![Interview Feedback](docs/screenshots/interview_feedback.png) |

### CV Analyzer & Translator
<!-- Tambahkan screenshot Analyzer & Translator di sini -->
| CV Analyzer | Hasil Analisis | CV Translator |
|:---:|:---:|:---:|
| ![CV Analyzer](docs/screenshots/cv_analyzer.png) | ![Analysis Result](docs/screenshots/analysis_result.png) | ![CV Translator](docs/screenshots/cv_translator.png) |

---

## 🏗️ Arsitektur

Resummy dibangun menggunakan **Clean Architecture** yang memisahkan concern secara tegas ke dalam 3 layer:

```
┌─────────────────────────────────────────────┐
│              Presentation Layer              │
│   Screens · Widgets · Providers (State)     │
├─────────────────────────────────────────────┤
│               Domain Layer                  │
│      Entities · Use Cases · Repositories    │
├─────────────────────────────────────────────┤
│                Data Layer                   │
│  Data Sources · Models · Repository Impl    │
└─────────────────────────────────────────────┘
```

### Struktur Folder

```
lib/
├── core/                          # Infrastruktur & utilitas global
│   ├── constants/                 # Konstanta app (API keys, config)
│   ├── di/                        # Dependency Injection (GetIt)
│   ├── l10n/                      # Lokalisasi (ARB files)
│   ├── providers/                 # Global state (Locale, Theme)
│   ├── routes/                    # Auto Route definitions
│   ├── services/
│   │   ├── gemini_pool_manager.dart  # ⭐ AI Round-Robin Engine
│   │   └── database_helper.dart      # ⭐ SQLite Offline DB
│   └── theme/                     # Color palette & ThemeData
│
├── features/                      # Modul fitur (Clean Architecture)
│   ├── auth/                      # Autentikasi & onboarding
│   ├── cv_tools/                  # CV Builder, Analyzer, Translator
│   │   ├── data/
│   │   │   ├── data_sources/      # Local (SQLite) & Remote (Firestore)
│   │   │   └── repositories/      # Implementasi repository
│   │   ├── domain/
│   │   │   ├── entities/          # CVData, SectionData, dll
│   │   │   └── use_cases/         # Business logic
│   │   └── presentation/
│   │       ├── providers/         # CVBuilderProvider
│   │       ├── screens/builder/   # 8 langkah CV Builder
│   │       └── widgets/           # CVCard, CvPreviewCard, dll
│   │
│   ├── interview/                 # Interview Prep
│   │   ├── data/
│   │   │   ├── data_sources/
│   │   │   │   ├── interview_remote_data_source.dart  # Gemini AI calls
│   │   │   │   ├── interview_local_data_source.dart   # SQLite
│   │   │   │   └── speech_data_source.dart            # STT via Gemini
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   └── entities/          # InterviewReport, QuestionFeedback
│   │   └── presentation/
│   │       ├── screens/setup/     # 4 langkah konfigurasi
│   │       ├── screens/session/   # Live interview
│   │       └── screens/feedback/  # Overview, Detail, Questions
│   │
│   ├── home/                      # Dashboard & hub screens
│   ├── history/                   # Riwayat aktivitas
│   └── profile/                   # Pengaturan pengguna
│
└── shared/
    └── widgets/                   # Komponen UI yang dapat digunakan ulang
        ├── app_section.dart       # Container section standar
        └── ...
```

---

## 🤖 Gemini AI Round-Robin

Salah satu inovasi teknis utama Resummy adalah sistem **Gemini AI Round-Robin** yang memungkinkan penggunaan AI tanpa batas dengan mengelola banyak API key secara cerdas.

### Masalah yang Dipecahkan

Gemini API memiliki **rate limit per key**. Saat banyak pengguna menggunakan fitur AI secara bersamaan, satu key akan cepat habis quotanya, menyebabkan error `429 Resource Exhausted`.

### Solusi: GeminiPoolManager

```
┌─────────────────────────────────────────────────────────┐
│                   GeminiPoolManager                     │
│                                                         │
│  Pool: cvAnalyzer    Pool: cvConverter   Pool: interview│
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │
│  │ Key 1   ←──┐│    │ Key 22 ←─┐  │    │ Key 37 ←─┐  │  │
│  │ Key 2      ││    │ Key 23   │  │    │ Key 38   │  │  │
│  │ Key 3      ││    │ Key 24   │  │    │ Key 39   │  │  │
│  │ ...        ││    │ ...      │  │    │ ...      │  │  │
│  │ Key 21  ───┘│    │ Key 36 ──┘  │    │ Key 51 ──┘  │  │
│  └─────────────┘    └─────────────┘    └─────────────┘  │
│   21 keys             15 keys            15 keys        │
└─────────────────────────────────────────────────────────┘
```

### Distribusi Key

| Pool | Jumlah Key | Digunakan Untuk |
|------|-----------|-----------------|
| `cvAnalyzer` | 21 keys | Analisis CV & ATS scoring |
| `cvConverter` | 15 keys | Terjemahan CV |
| `interview` | 15 keys | Analisis jawaban interview & STT |
| **Total** | **51 keys** | — |

### Cara Kerja

```dart
// Setiap request mengambil key berikutnya secara round-robin
GenerativeModel _getModel(GeminiPoolType type) {
  final pool = _pools[type]!;
  final model = pool[_indices[type]!];
  _indices[type] = (_indices[type]! + 1) % pool.length; // ← Circular rotation
  return model;
}
```

**Alur eksekusi dengan retry otomatis:**

```
Request masuk
     │
     ▼
Ambil model dari pool (index saat ini)
     │
     ▼
Kirim request ke Gemini API ──── Berhasil ──→ Return hasil
     │
     ▼ (Gagal: quota / 429)
Coba key berikutnya di pool
     │
     ▼
Ulangi hingga semua key dicoba
     │
     ▼ (Semua gagal)
Throw QuotaExceededException
```

### Konfigurasi API Keys

API keys dikonfigurasi melalui file `.env` (tidak di-commit ke repository):

```bash
# .env (buat file ini di root project)
GEMINI_API_KEY_1=AIza...
GEMINI_API_KEY_2=AIza...
# ... hingga key ke-51
GEMINI_API_KEY_51=AIza...
```

**Konfigurasi Minimum (1 key):**
```bash
# Cukup isi 1 key untuk development
GEMINI_API_KEY_1=AIza...
# Key lainnya boleh dikosongkan, sistem akan skip key kosong
```

**Konfigurasi Penuh (51 keys):**
Untuk production dengan banyak pengguna, isi semua 51 key untuk throughput maksimal.

### Keunggulan Sistem Ini

| Aspek | Tanpa Round-Robin | Dengan Round-Robin |
|-------|------------------|-------------------|
| Throughput | 1x | Hingga 51x |
| Downtime saat quota habis | ❌ Error langsung | ✅ Auto-fallback ke key lain |
| Biaya | Bergantung 1 akun | Distribusi ke banyak akun |
| Skalabilitas | Terbatas | Mudah ditambah key baru |

---

## 📦 Offline Architecture

Resummy dirancang sebagai **offline-first application** — semua data tersimpan lokal terlebih dahulu, kemudian disinkronkan ke cloud saat koneksi tersedia.

### Lapisan Penyimpanan

```
┌──────────────────────────────────────────────┐
│              Aplikasi (Flutter)              │
└──────────────────┬───────────────────────────┘
                   │
         ┌─────────┴─────────┐
         │                   │
         ▼                   ▼
┌─────────────────┐  ┌───────────────────┐
│  SQLite (Local) │  │ Firestore (Cloud) │
│  resummy_       │  │ (saat online)     │
│  offline.db     │  └───────────────────┘
└─────────────────┘
```

### Skema Database SQLite

```sql
-- Tabel CVs: Menyimpan semua data CV pengguna
CREATE TABLE cvs (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  title TEXT,
  source TEXT,          -- 'builder' | 'uploaded' | 'converted'
  data TEXT NOT NULL,   -- JSON serialized CVData
  pdfUrl TEXT,
  createdAt INTEGER NOT NULL,
  updatedAt INTEGER NOT NULL,
  syncStatus TEXT DEFAULT 'synced'  -- 'synced' | 'pending' | 'error'
);

-- Tabel Analysis History: Riwayat analisis CV
CREATE TABLE analysis_history (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  cvId TEXT,
  analysisData TEXT NOT NULL,  -- JSON hasil analisis
  score INTEGER,
  createdAt INTEGER NOT NULL,
  syncStatus TEXT DEFAULT 'synced'
);

-- Tabel Interviews: Riwayat sesi interview
CREATE TABLE interviews (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  jobPosition TEXT,
  data TEXT NOT NULL,          -- JSON InterviewReport
  createdAt INTEGER NOT NULL,
  completedAt INTEGER,
  isCompleted INTEGER DEFAULT 0,
  syncStatus TEXT DEFAULT 'synced'
);

-- Tabel Translations: Riwayat terjemahan CV
CREATE TABLE translations (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  originalCvId TEXT,
  translationData TEXT NOT NULL,
  fromLang TEXT,
  toLang TEXT,
  pdfUrl TEXT,
  createdAt INTEGER NOT NULL,
  syncStatus TEXT DEFAULT 'synced'
);

-- Sync Queue: Antrian operasi yang belum tersinkronisasi
CREATE TABLE sync_queue (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  operation TEXT NOT NULL,    -- 'INSERT' | 'UPDATE' | 'DELETE'
  tableName TEXT NOT NULL,
  recordId TEXT NOT NULL,
  data TEXT NOT NULL,
  createdAt INTEGER NOT NULL,
  retryCount INTEGER DEFAULT 0
);
```

### Alur Sinkronisasi

```
Pengguna membuat/edit data
         │
         ▼
Simpan ke SQLite (syncStatus = 'pending')
         │
         ▼
Cek koneksi internet
    │           │
  Online      Offline
    │           │
    ▼           ▼
Kirim ke     Tambahkan ke
Firestore    sync_queue
    │
    ▼
Update syncStatus = 'synced'
```

### Keunggulan Offline Architecture

- **Instant Response** — Data tersedia langsung dari SQLite tanpa menunggu network
- **Resilient** — App tetap berfungsi penuh saat offline
- **Conflict-free** — Sync queue memastikan tidak ada data yang hilang
- **Efficient** — Hanya data yang berubah yang disinkronkan

---

## 🎨 Theming System

### Palet Warna

| Token | Light Mode | Dark Mode | Penggunaan |
|-------|-----------|-----------|------------|
| `primary` | `#0EA5E9` Sky Blue | `#38BDF8` | Tombol utama, highlight |
| `secondary` | `#10B981` Emerald | `#4ADE80` | Status sukses, aksen |
| `error` | `#EF4444` Red | `#F87171` | Error, hapus |
| `surface` | `#FFFFFF` | `#1E293B` | Card, dialog |
| `background` | `#FAFAFA` | `#0F172A` | Background layar |

### Menggunakan Theme

```dart
// Dari ColorScheme (direkomendasikan)
final primary = Theme.of(context).colorScheme.primary;
final onSurface = Theme.of(context).colorScheme.onSurface;

// Dari AppColors (untuk nilai spesifik)
import 'package:resummy_app/core/theme/app_colors.dart';
final customColor = AppColors.primary500;
```

### Toggle Dark/Light Mode

```dart
final themeProvider = Provider.of<ThemeProvider>(context);

// Cek mode saat ini
bool isDark = themeProvider.isDarkMode;

// Toggle
themeProvider.toggleTheme();

// Set spesifik
themeProvider.setDarkMode(true);
```

Preferensi tema tersimpan otomatis di `SharedPreferences` dan di-load saat app restart.

---

## 🌍 Localization

Resummy mendukung **2 bahasa** dengan sistem lokalisasi Flutter bawaan:

- 🇮🇩 **Bahasa Indonesia** (default)
- 🇺🇸 **English**

### Menambah String Baru

**1. Tambahkan ke kedua file ARB:**

```json
// lib/core/l10n/arb/app_id.arb
{
  "welcomeMessage": "Selamat datang di Resummy!",
  "@welcomeMessage": {
    "description": "Pesan sambutan di halaman utama"
  }
}
```

```json
// lib/core/l10n/arb/app_en.arb
{
  "welcomeMessage": "Welcome to Resummy!"
}
```

**2. Generate file lokalisasi:**
```bash
flutter gen-l10n
```

**3. Gunakan di widget:**
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.welcomeMessage)
```

### Mengubah Bahasa

```dart
final localeProvider = Provider.of<LocaleProvider>(context);

localeProvider.setLocale(const Locale('id')); // Indonesia
localeProvider.setLocale(const Locale('en')); // English
```

---

## 🛣️ Navigasi

Resummy menggunakan [Auto Route](https://pub.dev/packages/auto_route) untuk navigasi yang **type-safe** dan deklaratif.

### Navigasi Dasar

```dart
// Push ke layar baru
context.router.push(const HomeRoute());

// Ganti layar saat ini
context.router.replace(const LoginRoute());

// Kembali
context.router.maybePop();

// Reset stack navigasi
context.router.replaceAll([const MainRoute(children: [CvToolsHubRoute()])]);

// Push dengan parameter
context.router.push(InterviewFeedbackDetailRoute(report: report));
```

### Regenerate Routes

Setelah menambah atau mengubah route:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## ⚙️ Konfigurasi

### Konfigurasi Default

Resummy berjalan dengan konfigurasi default yang sudah siap pakai:

| Konfigurasi | Default | Keterangan |
|-------------|---------|------------|
| Bahasa | `id` (Indonesia) | Dapat diubah di Settings |
| Tema | Light Mode | Dapat di-toggle |
| Jumlah pertanyaan interview | 5 | Dapat diubah saat setup |
| Bahasa interview | Indonesia | Dapat diubah saat setup |
| Sync ke cloud | Otomatis | Saat koneksi tersedia |

### Konfigurasi Kustom (`.env`)

Buat file `.env` di root project untuk mengkonfigurasi API keys:

```bash
# Minimum: 1 key (untuk development)
GEMINI_API_KEY_1=AIzaSy...

# Optimal: Isi semua pool untuk production
# Pool CV Analyzer (key 1-21)
GEMINI_API_KEY_1=AIzaSy...
GEMINI_API_KEY_2=AIzaSy...
# ...
GEMINI_API_KEY_21=AIzaSy...

# Pool CV Converter (key 22-36)
GEMINI_API_KEY_22=AIzaSy...
# ...
GEMINI_API_KEY_36=AIzaSy...

# Pool Interview (key 37-51)
GEMINI_API_KEY_37=AIzaSy...
# ...
GEMINI_API_KEY_51=AIzaSy...
```

> ⚠️ **Jangan commit file `.env` ke repository!** Pastikan `.env` ada di `.gitignore`.

### Konfigurasi Firebase

Lihat section [🔥 Firebase Setup](#-firebase-setup) untuk detail lengkap.

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart `>=3.0.0`
- Android Studio / VS Code
- Firebase account (untuk fitur cloud)
- Gemini API key (dari [Google AI Studio](https://aistudio.google.com/))

### Instalasi

```bash
# 1. Clone repository
git clone https://github.com/Asadell/resummy_app.git
cd resummy_app

# 2. Install dependencies
flutter pub get

# 3. Buat file .env dan isi API keys
cp .env.example .env
# Edit .env dan isi GEMINI_API_KEY_1 minimal

# 4. Generate kode otomatis (routes, dll)
dart run build_runner build --delete-conflicting-outputs

# 5. Generate lokalisasi
flutter gen-l10n

# 6. Setup Firebase (lihat section berikutnya)

# 7. Jalankan app
flutter run
```

### Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK (split per ABI untuk ukuran lebih kecil)
flutter build apk --split-per-abi --release

# App Bundle (untuk Google Play)
flutter build appbundle --release
```

---

## 🔥 Firebase Setup

> **Penting:** Setiap developer perlu setup Firebase sendiri karena SHA-1 fingerprint berbeda per mesin.

### Step 1: Install Tools

```bash
# Firebase CLI
npm install -g firebase-tools
firebase login

# FlutterFire CLI
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### Step 2: Configure

```bash
# Di root folder project
flutterfire configure
# Pilih project Firebase yang sudah ada
# Pilih platform: android
```

### Step 3: SHA-1 untuk Google Sign-In

```bash
# Dapatkan SHA-1 debug keystore
cd android
./gradlew signingReport
# Copy SHA-1 dari "Variant: debug"
```

Tambahkan SHA-1 di **Firebase Console → Project Settings → Your Apps → Android → Add Fingerprint**.

Lalu download `google-services.json` dan taruh di `android/app/`.

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /cvs/{cvId} {
      allow read, write: if request.auth != null && resource.data.userId == request.auth.uid;
    }
    match /interviews/{interviewId} {
      allow read, write: if request.auth != null && resource.data.userId == request.auth.uid;
    }
  }
}
```

### Troubleshooting Firebase

| Error | Solusi |
|-------|--------|
| `flutterfire: command not found` | `export PATH="$PATH":"$HOME/.pub-cache/bin"` |
| Google Sign-In gagal | Pastikan SHA-1 sudah ditambahkan di Firebase Console |
| `google-services.json` not found | Download dari Firebase Console → taruh di `android/app/` |
| Permission denied Firestore | Cek user sudah login & rules benar |

---

## 📦 Dependencies

### Core

| Package | Versi | Kegunaan |
|---------|-------|----------|
| `provider` | ^6.1.1 | State Management |
| `auto_route` | ^9.3.0 | Type-safe Navigation |
| `get_it` | ^8.3.0 | Dependency Injection |
| `google_generative_ai` | latest | Gemini AI SDK |

### Firebase & Storage

| Package | Versi | Kegunaan |
|---------|-------|----------|
| `firebase_core` | ^3.6.0 | Firebase Core |
| `firebase_auth` | ^5.3.0 | Autentikasi |
| `cloud_firestore` | ^5.4.4 | Cloud Database |
| `sqflite` | latest | SQLite Offline DB |
| `shared_preferences` | ^2.3.2 | Penyimpanan preferensi |

### UI & UX

| Package | Versi | Kegunaan |
|---------|-------|----------|
| `google_fonts` | ^6.1.0 | Tipografi premium |
| `iconsax_flutter` | latest | Icon pack modern |
| `audio_waveforms` | ^1.3.0 | Visualisasi audio |
| `syncfusion_flutter_pdfviewer` | latest | PDF viewer |

### Utilities

| Package | Versi | Kegunaan |
|---------|-------|----------|
| `envied` | latest | Secure env variables |
| `share_plus` | ^10.1.4 | Share file |
| `permission_handler` | ^11.4.0 | Runtime permissions |
| `file_picker` | latest | Pilih file dari device |

---

<p align="center">
  <br/>
  <strong>Dibuat dengan ❤️ oleh Tim Resummy</strong><br/>
  <em>Flutter Fusion · 2025</em>
</p>
