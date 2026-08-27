# AreaKerja Mobile

<p align="center">
  <strong>Aplikasi Mobile Platform Lowongan Kerja AreaKerja</strong>
</p>

<p align="center">
  Dibangun menggunakan Flutter dan terintegrasi dengan REST API Laravel.
</p>

---

## 📱 Tentang AreaKerja Mobile

**AreaKerja Mobile** adalah aplikasi mobile untuk platform pencarian dan penyediaan lowongan kerja.

Aplikasi ini menghubungkan **pencari kerja** dengan **perusahaan** dalam satu platform. Pengguna dapat mencari lowongan, melihat detail pekerjaan, mengirim lamaran, mengelola profil/CV, serta memantau proses lamaran.

Sementara itu, perusahaan dapat membuat dan mengelola lowongan pekerjaan serta melihat kandidat yang melamar.

Aplikasi mobile ini menggunakan **Laravel API** sebagai backend dan **MySQL** sebagai database.

---

## 🎯 Tujuan

AreaKerja Mobile dikembangkan untuk:

* Mempermudah pencari kerja menemukan lowongan pekerjaan.
* Mempermudah pengguna melamar pekerjaan melalui perangkat mobile.
* Mempermudah perusahaan membuat dan mengelola lowongan.
* Mempermudah perusahaan melihat kandidat yang melamar.
* Menyediakan pengalaman pencarian kerja yang lebih praktis melalui aplikasi mobile.

---

## 👥 Role Pengguna

AreaKerja Mobile memiliki dua role utama:

### 1. Job Seeker / Pelamar

Pengguna yang mencari dan melamar pekerjaan.

Fitur utama:

* Registrasi dan login
* Mengelola profil
* Mengelola CV
* Mencari lowongan pekerjaan
* Filter lowongan
* Melihat detail lowongan
* Menyimpan lowongan
* Melamar pekerjaan
* Melihat riwayat lamaran
* Melihat status lamaran
* Melihat tips seputar pekerjaan

### 2. Company / Perusahaan

Pengguna yang mewakili perusahaan.

Fitur utama:

* Registrasi dan login
* Mengelola profil perusahaan
* Membuat lowongan pekerjaan
* Mengedit lowongan
* Menghapus lowongan
* Melihat daftar lowongan perusahaan
* Melihat kandidat yang melamar
* Melihat informasi/CV kandidat

---

## 🚀 Fitur Utama

### Authentication

* Login
* Register
* Logout
* Role-based access
* Session/token management

### Lowongan Pekerjaan

* Daftar lowongan
* Pencarian lowongan
* Filter lowongan
* Detail lowongan
* Simpan lowongan
* Lamar pekerjaan

### Profil & CV

* Profil pengguna
* Data pribadi
* Informasi pendidikan
* Pengalaman kerja
* Skill
* CV

### Lamaran

* Melamar pekerjaan
* Riwayat lamaran
* Status lamaran
* Detail lamaran

### Perusahaan

* Profil perusahaan
* Membuat lowongan
* Mengelola lowongan
* Melihat daftar pelamar
* Melihat CV kandidat

### Tips

* Tips mencari pekerjaan
* Tips membuat CV
* Informasi seputar dunia kerja

---

## 🏗️ Arsitektur Aplikasi

AreaKerja Mobile menggunakan pendekatan **layered architecture** dengan pemisahan antara presentation, domain, dan data.

```text
Flutter UI
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
 Data Source
    │
    ▼
   Dio
    │
    ▼
Laravel REST API
    │
    ▼
   MySQL
```

### Alur Data

```text
User
 │
 ▼
Flutter Application
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
API Data Source
 │
 ▼
Dio HTTP Client
 │
 ▼
Laravel API
 │
 ▼
MySQL
```

---

## 🛠️ Tech Stack

### Mobile

| Teknologi              | Penggunaan                |
| ---------------------- | ------------------------- |
| Flutter                | Mobile framework          |
| Dart                   | Programming language      |
| BLoC                   | State management          |
| Dio                    | HTTP client               |
| GoRouter               | Navigation & routing      |
| Flutter Secure Storage | Penyimpanan data sensitif |
| Shared Preferences     | Local preferences         |

### Backend

| Teknologi | Penggunaan                   |
| --------- | ---------------------------- |
| Laravel   | REST API                     |
| PHP       | Backend programming language |
| MySQL     | Database                     |

---

## 📂 Struktur Project

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
│   │   │   ├── endpoints.dart
│   │   │   ├── interceptors/
│   │   │   └── response/
│   │   │
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── router/
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
│       ├── lowongan/
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │
│       ├── pelamar/
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

## 📦 Penjelasan Struktur

### `core/`

Berisi konfigurasi dan komponen inti aplikasi yang digunakan oleh banyak feature.

Contohnya:

```text
core/
├── api/
├── constants/
├── errors/
├── router/
├── storage/
├── theme/
└── utils/
```

### `features/`

Berisi fitur utama aplikasi.

Setiap feature dipisahkan menjadi:

```text
feature/
├── data/
├── domain/
└── presentation/
```

#### Data

Berisi:

* API data source
* Repository implementation
* DTO/model response API

#### Domain

Berisi:

* Entity
* Repository interface
* Use case

#### Presentation

Berisi:

* Page
* Widget
* BLoC
* Event
* State

---

## 🔐 Environment Configuration

Konfigurasi API disimpan menggunakan environment variable.

Buat file:

```text
.env
```

Contoh:

```env
API_BASE_URL=http://127.0.0.1:8000/api
```

Jangan memasukkan file `.env` ke repository apabila terdapat informasi sensitif.

Gunakan:

```text
.env.example
```

sebagai template konfigurasi.

Contoh:

```env
API_BASE_URL=
```

---

## 💻 Requirements

Pastikan sudah menginstall:

* Flutter SDK
* Dart SDK
* Android Studio atau Android SDK
* VS Code
* Git
* Laravel API
* MySQL

Cek instalasi Flutter:

```bash
flutter doctor
```

---

## ⚙️ Installation

### 1. Clone Repository

```bash
git clone <repository-url>
```

Masuk ke directory project:

```bash
cd areakerja-mobile
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Setup Environment

Copy:

```text
.env.example
```

menjadi:

```text
.env
```

Kemudian sesuaikan URL backend:

```env
API_BASE_URL=http://127.0.0.1:8000/api
```

### 4. Jalankan Laravel API

Masuk ke project backend:

```bash
php artisan serve
```

Laravel biasanya berjalan pada:

```text
http://127.0.0.1:8000
```

Sesuaikan `API_BASE_URL` dengan environment yang digunakan.

### 5. Jalankan Flutter

```bash
flutter run
```

Untuk melihat device yang tersedia:

```bash
flutter devices
```

---

## 🌐 API Integration

AreaKerja Mobile berkomunikasi dengan backend menggunakan REST API.

Contoh endpoint:

```text
/api/v1/login
/api/v1/register
/api/v1/lowongan
/api/v1/lowongan/{id}
/api/v1/lamaran
/api/v1/profile
/api/v1/perusahaan
```

Endpoint aktual mengikuti konfigurasi API pada backend Laravel.

---

## 🔑 Authentication

Authentication menggunakan token yang diberikan oleh Laravel API.

Alur authentication:

```text
Login
  │
  ▼
Laravel API
  │
  ▼
Access Token
  │
  ▼
Flutter Storage
  │
  ▼
Authenticated Request
```

Token kemudian digunakan pada request API yang membutuhkan autentikasi.

---

## 🧭 Routing

Navigasi aplikasi menggunakan **GoRouter**.

Routing mempertimbangkan role pengguna.

Contoh konsep:

```text
Login
 │
 ├── Job Seeker
 │      └── Job Seeker Dashboard
 │
 └── Company
        └── Company Dashboard
```

Route yang membutuhkan authentication dilindungi menggunakan route guard.

---

## 🔄 State Management

Aplikasi menggunakan **BLoC** untuk mengelola state.

Contoh:

```text
UI
 │
 ▼
BLoC Event
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
BLoC State
 │
 ▼
UI
```

Contoh state:

```text
Initial
Loading
Success
Failure
```

---

## 🧪 Testing

Menjalankan seluruh test:

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

---

## 🌿 Git Workflow

Project menggunakan branch berdasarkan feature.

Contoh:

```text
main
 │
 └── develop
      │
      ├── feature/api/mobile
      ├── feature/auth
      ├── feature/lowongan
      └── feature/perusahaan
```

### Membuat branch baru

```bash
git checkout develop
git pull origin develop
git checkout -b feature/nama-feature
```

### Commit

Gunakan commit message yang jelas:

```bash
git add .
git commit -m "feat: add job listing API integration"
```

Contoh lainnya:

```text
feat: add login page
feat: add job detail
fix: fix authentication token
fix: fix job filtering
refactor: improve repository structure
docs: update README
```

### Push

```bash
git push origin feature/nama-feature
```

Kemudian buat Pull Request menuju:

```text
develop
```

---

## 👨‍💻 Development Rules

Untuk menjaga project tetap rapi:

1. Jangan langsung melakukan development pada `main`.
2. Gunakan `develop` sebagai branch development.
3. Gunakan feature branch untuk setiap fitur.
4. Jangan commit file `.env`.
5. Jangan menyimpan API key atau credential di repository.
6. Gunakan BLoC untuk state management.
7. Pisahkan logic dari UI.
8. Gunakan repository pattern untuk komunikasi data.
9. Gunakan model yang konsisten dengan response API.
10. Jalankan `flutter analyze` sebelum melakukan push.

---

## 🚧 Roadmap

Fitur yang direncanakan untuk pengembangan berikutnya:

* [ ] Candidate / Talent Hunter
* [ ] Notification
* [ ] Payment
* [ ] Coin / Subscription
* [ ] Admin Mobile
* [ ] Peningkatan sistem rekomendasi lowongan
* [ ] Peningkatan UX/UI
* [ ] Push notification
* [ ] Optimasi performa aplikasi

---

## 📌 MVP Scope

Fokus versi awal AreaKerja Mobile adalah:

### Job Seeker

* Authentication
* Profile
* CV
* Search lowongan
* Filter lowongan
* Detail lowongan
* Apply job
* Saved jobs
* Application history
* Tips pekerjaan

### Company

* Authentication
* Company profile
* Create job
* Manage job
* View applicants
* View candidate CV

Fitur seperti **Talent Hunter, notification, payment, coin/subscription, dan admin mobile** berada di tahap pengembangan selanjutnya.

---

## 🤝 Contribution

Kontribusi dilakukan melalui feature branch.

Flow:

```text
develop
   │
   ▼
Create Feature Branch
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

Sebelum membuat Pull Request, pastikan:

```bash
flutter analyze
flutter test
dart format .
```

tidak menghasilkan masalah yang belum diselesaikan.

---

## 📄 License

Project ini dikembangkan untuk kebutuhan pengembangan platform **AreaKerja**.

---

## 👨‍💻 Development Team

**AreaKerja Mobile Development Team**

> Project ini dikembangkan menggunakan Flutter sebagai aplikasi mobile dan Laravel REST API sebagai backend.
