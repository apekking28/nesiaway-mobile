# 🇮🇩 NesiaWay - Blog Keindahan Indonesia

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![Status](https://img.shields.io/badge/Status-Development-yellow.svg)
![RBAC](https://img.shields.io/badge/RBAC-Enabled-success.svg)

Aplikasi mobile blog untuk menjelajahi dan berbagi keindahan Indonesia. Dibangun dengan Flutter menggunakan Clean Architecture, Provider state management, dan Mock API untuk backend operations. Dilengkapi dengan sistem Role-Based Access Control (RBAC).

---

## ✨ Features

### 🔐 Authentication & Authorization
- **Login** dengan password validation
- **Register** akun baru (role: user)
- Role-Based Access Control (Admin & User)
- Session management
- Secure logout

### 👥 User Management (Admin Only)
- Complete CRUD operations untuk users
- User detail dengan permissions overview
- Search & filter by role
- Password management dengan visibility toggle
- Self-edit protection

### 📝 Blog Management
- **Admin:** Full CRUD (Create, Read, Update, Delete)
- **User:** Read-only access
- Search & filter by category
- Image gallery support
- Multiple categories

### 🎨 UI/UX
- Material Design 3
- Indonesian-themed colors
- Responsive layouts
- Loading states & error handling
- Image caching & fallback

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / VS Code
- Internet connection

### Installation

```bash
# 1. Navigate to project
cd nesiaway

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run

# Or build APK
flutter build apk --release
adb install build/app/outputs/flutter-apk/app-release.apk
```

### First Time Setup

**Option 1: Register New Account**
1. Open app
2. Tap "Daftar" on login screen
3. Fill registration form (4 fields)
4. Submit
5. Login with new credentials
6. 🎉 Welcome! (Role: User)

**Option 2: Use Default Admin**
1. Open app
2. Login with default credentials
3. 🎉 Full access! (Role: Admin)

---

## 🔑 Login Credentials

### 🆕 Register New Account
```
1. Tap "Daftar" on login screen
2. Fill form:
   - Nama Lengkap (min 3 characters)
   - Email (valid format)
   - Password (min 6 characters)
   - Konfirmasi Password (must match)
3. Submit
4. Login with your new credentials
5. Role: User (default)
```

> 💡 **Note:** Semua akun baru otomatis mendapat role **User**.  
> Untuk membuat **Admin**, gunakan User Management (admin only).

---

### Default Admin (Always Available)
```
Email: admin@gmail.com
Password: admin12345
Role: Admin
```

### Sample Users (After running populate script)

**Admin Accounts:**
```
admin@nesiaway.com / admin123
budi.admin@nesiaway.com / admin123
siti.admin@nesiaway.com / admin123
```

**User Accounts:**
```
agus@example.com / user123
rina@example.com / user123
joko@example.com / user123
```

### Create Sample Users
```bash
chmod +x populate_users.sh
./populate_users.sh
```

---

## 🆕 User Registration

### How It Works

NesiaWay allows users to create their own accounts through a simple registration process.

**Registration Form:**
- ✅ **Nama Lengkap** (min 3 characters)
- ✅ **Email** (valid format, must be unique)
- ✅ **Password** (min 6 characters, with visibility toggle)
- ✅ **Konfirmasi Password** (must match password)

**Features:**
- 🔒 Email uniqueness check
- 🔒 Password strength validation
- 🔒 Automatic role assignment (User)
- 👁️ Password visibility toggle
- ✉️ Email format validation
- ⚡ Real-time validation feedback

**Default Role:**
- All new accounts = **User** role
- Admin role requires manual creation via User Management
- Security best practice (no self-admin registration)

**Flow:**
```
Login Screen → Tap "Daftar" → Fill Form → Validate → API Call → Success → Back to Login
```

**Create Admin:**
```
Method 1: Via User Management (Admin only)
  1. Login as admin
  2. Users tab → "+" button
  3. Fill form → Select "Admin" role
  4. Save

Method 2: Use default admin
  Email: admin@gmail.com
  Password: admin12345
```

---

## 🌐 Mock API

**Base URL:** `https://691e876fbb52a1db22be25e9.mockapi.io/api/v1`

### Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/blog` | GET, POST | Get all blogs / Create blog |
| `/blog/:id` | GET, PUT, DELETE | Get, Update, Delete blog |
| `/user` | GET, POST | Get all users / Create user |
| `/user/:id` | GET, PUT, DELETE | Get, Update, Delete user |

### Blog Schema
```json
{
  "id": "string",
  "title": "string",
  "category": "string",
  "body": "string",
  "banner": "string (URL)",
  "images": ["string (URL)"]
}
```

### User Schema
```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "password": "string",
  "role": "admin | user"
}
```

---

## 👑 RBAC - Permissions

### Permission Matrix

| Feature | Admin | User | Guest |
|---------|-------|------|-------|
| **Authentication** |
| Register account | ✅ | ✅ | ✅ |
| Login | ✅ | ✅ | - |
| Logout | ✅ | ✅ | - |
| **Blogs** |
| View blogs | ✅ | ✅ | ❌ |
| Search/Filter | ✅ | ✅ | ❌ |
| Create blog | ✅ | ❌ | ❌ |
| Edit blog | ✅ | ❌ | ❌ |
| Delete blog | ✅ | ❌ | ❌ |
| **Users** |
| View users | ✅ | ❌ | ❌ |
| Create user | ✅ | ❌ | ❌ |
| Edit user | ✅ | ❌ | ❌ |
| Delete user | ✅ | ❌ | ❌ |
| Change own role | ❌ | ❌ | ❌ |

> 💡 **Note:** Registration selalu membuat akun dengan role **User**.  
> Admin tidak bisa dibuat via registration untuk keamanan.

### UI Differences

**Admin:**
- 3 tabs: Blog, Users, Profil
- FAB "Buat Blog" visible
- Edit & Delete buttons on cards
- Full Users tab access

**User:**
- 2 tabs: Blog, Profil
- No create/edit/delete buttons
- Read-only access

---

## 📁 Project Structure

```
nesiaway/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── blog_model.dart
│   │   └── user_model.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── user_service.dart
│   │   └── auth_service.dart
│   ├── providers/
│   │   ├── blog_provider.dart
│   │   ├── user_provider.dart
│   │   └── auth_provider.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home/
│   │   ├── blog/
│   │   ├── user/
│   │   └── profile/
│   ├── widgets/
│   └── utils/
├── android/
├── docs/
├── scripts/
└── pubspec.yaml
```

---

## 🎨 Tech Stack

### Framework
- Flutter 3.0+
- Dart 3.0+

### Architecture
- Clean Architecture
- Provider Pattern (MVVM-like)
- Separation of concerns

### Key Dependencies
```yaml
dependencies:
  provider: ^6.1.1              # State management
  http: ^1.1.0                  # HTTP requests
  cached_network_image: ^3.3.0 # Image caching
  shared_preferences: ^2.2.2   # Local storage
  intl: ^0.18.1                # Date formatting
  flutter_spinkit: ^5.2.0      # Loading indicators
```

---

## 🔧 Configuration

### API Configuration
Edit `lib/utils/constants.dart`:

```dart
class Constants {
  static const String baseUrl = 
    '<your_mockup_api_url>';
  static const String blogEndpoint = 'blog';
  static const String userEndpoint = 'user';
}
```

### Theme Colors
Edit `lib/utils/constants.dart`:

```dart
class AppColors {
  static const Color primary = Color(0xFF1E88E5);      // Blue
  static const Color secondary = Color(0xFFFF6B35);    // Orange
  static const Color accent = Color(0xFFFFC107);       // Yellow
  static const Color success = Color(0xFF4CAF50);      // Green
  static const Color error = Color(0xFFF44336);        // Red
}
```

---

## 📱 How to Use

### 🆕 Registration (New Users)
1. **Open app** → Tap "Daftar"
2. **Fill form** (4 fields required):
   - **Nama Lengkap** - Nama lengkap Anda (min 3 karakter)
   - **Email** - Email valid (akan digunakan untuk login)
   - **Password** - Password (min 6 karakter)
   - **Konfirmasi Password** - Harus sama dengan password
3. **Submit** → Tap "Daftar" button
4. **Success** → Kembali ke login screen
5. **Login** → Gunakan email & password yang baru dibuat
6. **Welcome!** → Anda akan masuk sebagai **User** (default role)

> 💡 **Tips:**
> - Semua akun baru = **User** role
> - Tidak bisa self-register sebagai **Admin** (security)
> - Admin hanya bisa dibuat via User Management

---

### 🔐 Authentication
1. Buka app
2. Login dengan credentials
3. Navigasi ke home screen

### 📝 Blog Management (Admin)
1. **View:** Browse blogs di Blog tab
2. **Create:** Tap FAB "Buat Blog" → Isi form → Simpan
3. **Edit:** Tap blog → Tap edit FAB → Update → Simpan
4. **Delete:** Tap delete button di card → Konfirmasi
5. **Search:** Gunakan search bar
6. **Filter:** Tap kategori chip

### 👥 User Management (Admin)
1. **View:** Go to Users tab
2. **Create:** Tap FAB → Isi form → Simpan
3. **Detail:** Tap user card
4. **Edit:** Tap edit button → Update → Simpan
5. **Delete:** Tap delete button → Konfirmasi
6. **Search:** Ketik di search bar
7. **Filter:** Tap role chips (Semua/Admin/User)

> 💡 **Create Admin via User Management:**
> 1. Login sebagai admin
> 2. Go to Users tab
> 3. Tap "+" button
> 4. Fill form
> 5. Pilih role: **Admin**
> 6. Save

### 👤 User Experience (Non-Admin)
1. **View Blogs:** Browse & read semua blogs
2. **Search:** Cari blog by title/content
3. **Filter:** Filter by kategori
4. **Profile:** View & logout

---

## 🛠️ Build Scripts

### Build APK
```bash
# Clean build
flutter clean

# Install dependencies
flutter pub get

# Build release APK
flutter build apk --release

# Install to device
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Create Sample Data
```bash
# Create 15 sample users
chmod +x populate_users.sh
./populate_users.sh

# Verify users
./verify_users.sh
```

---

## 📋 Categories

- Wisata Alam
- Kuliner
- Budaya
- Pantai
- Gunung
- Kuliner Tradisional
- Festival
- Arsitektur

---

## 🎯 Current Status

### Completed Features ✅
- Authentication & login validation
- **User registration** (role: user)
- Role-Based Access Control (RBAC)
- User management (CRUD)
- Blog management (CRUD)
- Search & filter
- User detail screen
- Self-edit protection
- Dynamic role display
- Image caching

### In Development 🔄
- Dark theme
- Offline mode
- Multi-language support

---

**Made with ❤️ for Indonesia 🇮🇩**

*Bangga Menjelajah Indonesia*

---

**Version:** 1.0.0  
**Status:** 🔄 Development  
**Last Updated:** 2025-11-25
