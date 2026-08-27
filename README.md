# 🚀 AreaKerja Mobile

<p align="center">
  <strong>Platform Karier & Rekrutmen Berbasis Mobile</strong>
</p>

<p align="center">
  Menghubungkan pencari kerja dengan perusahaan dalam satu platform yang mudah, cepat, dan modern.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Laravel-API-FF2D20?style=for-the-badge&logo=laravel&logoColor=white" alt="Laravel">
  <img src="https://img.shields.io/badge/MySQL-Database-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/State%20Management-BLoC-7C4DFF?style=flat-square" alt="BLoC">
  <img src="https://img.shields.io/badge/HTTP-Dio-00A8E8?style=flat-square" alt="Dio">
  <img src="https://img.shields.io/badge/Routing-GoRouter-00B894?style=flat-square" alt="GoRouter">
  <img src="https://img.shields.io/badge/Status-In%20Development-F39C12?style=flat-square" alt="Development">
</p>

---

## 📖 About

**AreaKerja Mobile** adalah aplikasi mobile yang dikembangkan sebagai bagian dari ekosistem **AreaKerja**, sebuah platform yang mempertemukan **job seeker** dengan **perusahaan**.

Aplikasi ini dirancang untuk memberikan pengalaman pencarian kerja yang lebih praktis melalui perangkat mobile, mulai dari mencari lowongan, melihat detail pekerjaan, mengelola profil dan CV, hingga mengirim serta memantau lamaran.

Untuk sisi perusahaan, aplikasi menyediakan berbagai fungsi untuk mengelola lowongan pekerjaan dan kandidat yang melamar.

### 🎯 Vision

> **Connecting Talent with Opportunity.**

AreaKerja bertujuan membantu talenta menemukan kesempatan kerja yang sesuai sekaligus membantu perusahaan menemukan kandidat yang tepat.

---

# ✨ Key Features

## 👤 Job Seeker

Pencari kerja dapat:

* 🔐 Register & Login
* 👤 Mengelola profil
* 📄 Mengelola CV
* 🎓 Mengelola pendidikan
* 💼 Mengelola pengalaman kerja
* 🛠️ Mengelola skill
* 🔍 Mencari lowongan pekerjaan
* 🎯 Filter lowongan berdasarkan kebutuhan
* 📋 Melihat detail lowongan
* ❤️ Menyimpan lowongan
* 📤 Mengirim lamaran
* 📊 Memantau status lamaran
* 📜 Melihat riwayat lamaran
* 💡 Membaca tips dunia kerja

---

## 🏢 Company

Perusahaan dapat:

* 🔐 Register & Login
* 🏢 Mengelola profil perusahaan
* 📢 Membuat lowongan pekerjaan
* ✏️ Mengedit lowongan
* 🗑️ Menghapus lowongan
* 📋 Melihat daftar lowongan
* 👥 Melihat kandidat
* 📄 Melihat CV kandidat
* 📊 Mengelola proses rekrutmen

---

# 🧩 Application Modules

```text
┌─────────────────────────────────────────────┐
│              AreaKerja Mobile               │
├─────────────────────────────────────────────┤
│                                             │
│  🔐 Authentication                          │
│      ├── Login                              │
│      ├── Register                           │
│      └── Logout                             │
│                                             │
│  🔍 Job Discovery                           │
│      ├── Search                             │
│      ├── Filter                             │
│      ├── Job Detail                         │
│      └── Saved Jobs                         │
│                                             │
│  📤 Application                             │
│      ├── Apply Job                          │
│      ├── Application History                │
│      └── Application Status                 │
│                                             │
│  👤 Profile                                 │
│      ├── Personal Information               │
│      ├── CV                                 │
│      ├── Education                          │
│      ├── Experience                         │
│      └── Skills                             │
│                                             │
│  🏢 Company                                 │
│      ├── Company Profile                    │
│      ├── Job Management                     │
│      └── Applicant Management               │
│                                             │
└─────────────────────────────────────────────┘
```

---

# 🏗️ Architecture

AreaKerja Mobile menggunakan pendekatan **Clean Architecture** dengan pemisahan antara:

* Presentation Layer
* Domain Layer
* Data Layer

Arsitektur utama:

```text
                     ┌──────────────────┐
                     │    Flutter UI    │
                     └────────┬─────────┘
                              │
                              ▼
                     ┌──────────────────┐
                     │      BLoC        │
                     └────────┬─────────┘
                              │
                              ▼
                     ┌──────────────────┐
                     │     Use Case     │
                     └────────┬─────────┘
                              │
                              ▼
                     ┌──────────────────┐
                     │   Repository     │
                     └────────┬─────────┘
                              │
                              ▼
                     ┌──────────────────┐
                     │   Data Source    │
                     └────────┬─────────┘
                              │
                              ▼
                     ┌──────────────────┐
                     │       Dio        │
                     └────────┬─────────┘
                              │
                              ▼
                     ┌──────────────────┐
                     │ Laravel REST API │
                     └────────┬─────────┘
                              │
                              ▼
                     ┌──────────────────┐
                     │      MySQL       │
                     └──────────────────┘
```

---

# 📂 Project Structure

```text
areakerja-mobile/
│
├── android/
├── ios/
├── web/
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── test/
│
├── lib/
│   │
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── api/
│   │   │   ├── dio_client.dart
│   │   │   ├── api_endpoints.dart
│   │   │   └── interceptors/
│   │   │
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── router/
│   │   │   └── app_router.dart
│   │   ├── storage/
│   │   ├── theme/
│   │   └── utils/
│   │
│   ├── shared/
│   │   ├── models/
│   │   └── widgets/
│   │
│   └── features/
│       │
│       ├── auth/
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │
│       ├── home/
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │
│       ├── lowongan/
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │
│       ├── lamaran/
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │
│       ├── profile/
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │
│       └── perusahaan/
│           ├── data/
│           ├── domain/
│           └── presentation/
│
├── .env
├── .env.example
├── .gitignore
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

---

# 🧱 Feature Architecture

Setiap feature menggunakan struktur:

```text
feature/
│
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

Contoh module authentication:

```text
auth/
│
├── data/
│   ├── datasources/
│   │   └── auth_remote_datasource.dart
│   │
│   ├── models/
│   │   └── login_response_model.dart
│   │
│   └── repositories/
│       └── auth_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   └── user.dart
│   │
│   ├── repositories/
│   │   └── auth_repository.dart
│   │
│   └── usecases/
│       └── login.dart
│
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart
    │   ├── auth_event.dart
    │   └── auth_state.dart
    │
    ├── pages/
    │   └── login_page.dart
    │
    └── widgets/
```

---

# 🛠️ Tech Stack

## Mobile Application

| Technology                 | Purpose                         |
| -------------------------- | ------------------------------- |
| **Flutter**                | Cross-platform mobile framework |
| **Dart**                   | Programming language            |
| **flutter_bloc**           | State management                |
| **Dio**                    | HTTP client                     |
| **GoRouter**               | Application routing             |
| **Flutter Secure Storage** | Secure token storage            |
| **Shared Preferences**     | Local preferences               |
| **flutter_dotenv**         | Environment configuration       |
| **Equatable**              | State comparison                |

## Backend

| Technology  | Purpose             |
| ----------- | ------------------- |
| **Laravel** | REST API            |
| **PHP**     | Backend language    |
| **MySQL**   | Relational database |

---

# 🔌 API Integration

AreaKerja Mobile berkomunikasi dengan backend melalui **REST API**.

Contoh struktur endpoint:

```text
/api/v1
│
├── /auth
│   ├── POST /login
│   ├── POST /register
│   └── POST /logout
│
├── /users
│   └── GET /profile
│
├── /lowongan
│   ├── GET /
│   ├── GET /{id}
│   ├── POST /
│   ├── PUT /{id}
│   └── DELETE /{id}
│
├── /lamaran
│   ├── GET /
│   ├── POST /
│   └── GET /{id}
│
└── /perusahaan
    ├── GET /profile
    └── PUT /profile
```

> Endpoint aktual mengikuti implementasi Laravel API pada backend AreaKerja.

---

# 🔐 Authentication Flow

Authentication menggunakan token dari backend.

```text
┌──────────────┐
│    Login     │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Laravel API  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Access Token │
└──────┬───────┘
       │
       ▼
┌────────────────────┐
│ Secure Local       │
│ Storage             │
└──────┬─────────────┘
       │
       ▼
┌────────────────────┐
│ Authenticated API  │
│ Request             │
└────────────────────┘
```

Token tidak disimpan secara hard-code di source code.

---

# 🌐 Environment Configuration

Gunakan `.env` untuk menyimpan konfigurasi environment.

### `.env.example`

```env
API_BASE_URL=
API_VERSION=v1
```

### `.env`

```env
API_BASE_URL=http://127.0.0.1:8000/api
API_VERSION=v1
```

> ⚠️ **Jangan commit `.env` ke Git.**

Pastikan `.gitignore` berisi:

```gitignore
.env
```

---

# 💻 Requirements

Sebelum menjalankan project, pastikan environment sudah memiliki:

* Flutter SDK
* Dart SDK
* Android Studio / Android SDK
* VS Code
* Git
* PHP
* Composer
* Laravel
* MySQL

Periksa environment Flutter:

```bash
flutter doctor
```

---

# ⚡ Getting Started

## 1. Clone Repository

```bash
git clone <repository-url>
```

Masuk ke project:

```bash
cd areakerja-mobile
```

---

## 2. Install Dependencies

```bash
flutter pub get
```

---

## 3. Setup Environment

Copy:

```text
.env.example
```

menjadi:

```text
.env
```

Kemudian konfigurasi:

```env
API_BASE_URL=http://127.0.0.1:8000/api
API_VERSION=v1
```

---

## 4. Jalankan Backend

Pastikan Laravel API sudah berjalan.

```bash
php artisan serve
```

Default:

```text
http://127.0.0.1:8000
```

---

## 5. Jalankan Flutter

Cek device:

```bash
flutter devices
```

Kemudian:

```bash
flutter run
```

---

# 🧪 Testing

Menjalankan unit/widget test:

```bash
flutter test
```

Menjalankan analyzer:

```bash
flutter analyze
```

Format kode:

```bash
dart format .
```

Sebelum melakukan Pull Request, pastikan ketiga command tersebut sudah dijalankan.

---

# 🧭 Routing

Routing menggunakan **GoRouter**.

Secara umum:

```text
                    ┌────────────┐
                    │    App     │
                    └─────┬──────┘
                          │
                    ┌─────▼──────┐
                    │ Auth Check │
                    └─────┬──────┘
                          │
              ┌───────────┴───────────┐
              │                       │
          Not Login                Login
              │                       │
              ▼                       ▼
        Login/Register          Check Role
                                      │
                          ┌───────────┴───────────┐
                          │                       │
                      Job Seeker              Company
                          │                       │
                          ▼                       ▼
                    User Home              Company Home
```

Route yang membutuhkan authentication dilindungi menggunakan route guard.

---

# 🔄 State Management

State management menggunakan **BLoC**.

Contoh alur:

```text
User Action
    │
    ▼
   Event
    │
    ▼
   BLoC
    │
    ▼
 Use Case
    │
    ▼
 Repository
    │
    ▼
    API
    │
    ▼
 Repository
    │
    ▼
   BLoC
    │
    ▼
   State
    │
    ▼
    UI
```

State umum:

```text
Initial
   ↓
Loading
   ↓
Success
   │
   └── Failure
```

---

# 🌿 Git Workflow

Project menggunakan Git Flow sederhana.

```text
main
 │
 └── develop
      │
      ├── feature/auth
      ├── feature/api/mobile
      ├── feature/lowongan
      ├── feature/lamaran
      ├── feature/profile
      └── feature/perusahaan
```

### Branch

| Branch      | Fungsi              |
| ----------- | ------------------- |
| `main`      | Production / stable |
| `develop`   | Development         |
| `feature/*` | Pengembangan fitur  |

---

## 🔀 Membuat Feature Branch

Selalu mulai dari `develop`:

```bash
git checkout develop
git pull origin develop
```

Buat branch:

```bash
git checkout -b feature/nama-feature
```

Contoh:

```bash
git checkout -b feature/auth
```

---

## 📝 Commit Convention

Gunakan format:

```text
type: description
```

Contoh:

```bash
git commit -m "feat: add login page"
git commit -m "feat: integrate login API"
git commit -m "fix: fix authentication token"
git commit -m "fix: fix job filtering"
git commit -m "refactor: improve repository structure"
git commit -m "docs: update README"
```

### Commit Types

| Type       | Penggunaan              |
| ---------- | ----------------------- |
| `feat`     | Fitur baru              |
| `fix`      | Perbaikan bug           |
| `refactor` | Perubahan struktur kode |
| `docs`     | Dokumentasi             |
| `test`     | Testing                 |
| `chore`    | Maintenance             |

---

# 🔀 Pull Request Workflow

```text
Create Branch
      │
      ▼
 Development
      │
      ▼
   Testing
      │
      ▼
   Commit
      │
      ▼
    Push
      │
      ▼
 Pull Request
      │
      ▼
 Code Review
      │
      ▼
 Merge → develop
```

Jangan melakukan development langsung pada:

```text
main
```

---

# 👥 Development Team

AreaKerja Mobile dikembangkan oleh **2 developer**.

### Developer 1 — Mobile Core & API

Fokus:

* Project architecture
* API client
* Dio
* Authentication
* Token management
* Secure storage
* Routing
* Core utilities

### Developer 2 — UI & Feature

Fokus:

* UI/UX
* Home
* Lowongan
* Lamaran
* Profile
* Company
* Reusable widgets

Pembagian dapat disesuaikan dengan kebutuhan project.

---

# 📋 Development Roadmap

## Phase 1 — Project Foundation

* [x] Project initialization
* [x] Git repository
* [x] Basic folder structure
* [ ] Environment configuration
* [ ] Dio configuration
* [ ] API client
* [ ] Error handling
* [ ] Routing
* [ ] Theme

## Phase 2 — Authentication

* [ ] Login
* [ ] Register
* [ ] Logout
* [ ] Token management
* [ ] Session management
* [ ] Role-based routing

## Phase 3 — Job Seeker

* [ ] Home
* [ ] Job listing
* [ ] Search
* [ ] Filter
* [ ] Job detail
* [ ] Saved jobs
* [ ] Apply job

## Phase 4 — Application

* [ ] Application history
* [ ] Application detail
* [ ] Application status
* [ ] Application tracking

## Phase 5 — Profile & CV

* [ ] Profile
* [ ] Edit profile
* [ ] CV
* [ ] Education
* [ ] Experience
* [ ] Skills

## Phase 6 — Company

* [ ] Company dashboard
* [ ] Company profile
* [ ] Create job
* [ ] Edit job
* [ ] Delete job
* [ ] Applicant list
* [ ] Candidate detail
* [ ] Candidate CV

## Phase 7 — Advanced Features

* [ ] Push notification
* [ ] Talent Hunter
* [ ] Recommendation system
* [ ] Payment
* [ ] Subscription
* [ ] Coin system
* [ ] Admin mobile

---

# 🔒 Security Guidelines

Beberapa aturan keamanan:

* Jangan commit `.env`.
* Jangan menyimpan password di source code.
* Jangan menyimpan API key secara hard-code.
* Gunakan secure storage untuk token.
* Validasi input dari user.
* Jangan mempercayai data dari client.
* Semua authorization tetap harus divalidasi oleh backend.
* Jangan menampilkan informasi sensitif pada log production.

---

# 📐 Development Guidelines

Untuk menjaga codebase tetap konsisten:

### 1. Pisahkan Business Logic

Hindari:

```text
UI → Dio → API
```

Gunakan:

```text
UI
 ↓
BLoC
 ↓
Use Case
 ↓
Repository
 ↓
Data Source
 ↓
API
```

### 2. Gunakan Reusable Widget

Jika komponen digunakan berkali-kali, letakkan di:

```text
shared/widgets/
```

### 3. Feature Tidak Saling Bergantung Secara Berlebihan

Contoh:

```text
features/
├── auth/
├── lowongan/
├── lamaran/
└── profile/
```

Setiap feature harus memiliki tanggung jawab yang jelas.

---

# 📸 Screenshots

Screenshot aplikasi dapat ditambahkan di folder:

```text
docs/
├── login.png
├── register.png
├── home.png
├── job-list.png
├── job-detail.png
├── application.png
└── profile.png
```

Kemudian tampilkan pada README:

```html
<p align="center">
  <img src="docs/login.png" width="200">
  <img src="docs/home.png" width="200">
  <img src="docs/job-detail.png" width="200">
  <img src="docs/profile.png" width="200">
</p>
```

---

# 🤝 Contribution

Contribution dilakukan melalui feature branch.

Sebelum membuat Pull Request:

```bash
flutter pub get
flutter analyze
flutter test
dart format .
```

Pastikan:

* Tidak ada error analyzer.
* Tidak ada test yang gagal.
* Tidak ada credential yang ikut ter-commit.
* Code mengikuti struktur project.
* Commit message sesuai convention.
* Tidak mengubah file milik feature lain tanpa koordinasi.

---

# 🐛 Bug Report

Jika menemukan bug, sertakan:

```text
1. Deskripsi masalah
2. Langkah untuk reproduce
3. Expected result
4. Actual result
5. Screenshot jika diperlukan
6. Device / OS
7. Flutter version
```

---

# 💡 Future Development

AreaKerja Mobile dirancang untuk terus dikembangkan menjadi platform karier yang lebih lengkap.

Pengembangan ke depan dapat mencakup:

```text
                    AreaKerja
                        │
          ┌─────────────┼─────────────┐
          │             │             │
          ▼             ▼             ▼
      Job Seeker     Company        Admin
          │             │             │
          ▼             ▼             ▼
      Find Job      Post Job       Manage
          │             │             │
          ▼             ▼             ▼
       Apply       Candidates      Platform
          │             │
          └──────┬──────┘
                 ▼
          Talent Matching
                 │
                 ▼
         Better Opportunity
```

Target akhirnya adalah membangun ekosistem yang mempertemukan **talent, opportunity, dan company** secara lebih efektif.

---

# 📄 License

Project **AreaKerja Mobile** dikembangkan untuk kebutuhan pengembangan platform AreaKerja.

---

<p align="center">

### 🚀 AreaKerja Mobile

**Connecting Talent with Opportunity**

Built with ❤️ using **Flutter + Laravel**

</p>
