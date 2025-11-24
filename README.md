# 🇮🇩 NesiaWay - Blog Keindahan Indonesia

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

Aplikasi mobile blog untuk menjelajahi dan berbagi keindahan Indonesia. Dibangun dengan Flutter dan menggunakan Mock API untuk CRUD operations.

## ✨ Features

- 🔐 **Authentication** - Login dengan kredensial default
- 📝 **Blog CRUD** - Create, Read, Update, Delete blog posts
- 🔍 **Search & Filter** - Cari blog dan filter berdasarkan kategori
- 🖼️ **Image Gallery** - Banner dan galeri foto untuk setiap blog
- 👤 **User Profile** - Halaman profil pengguna
- 🎨 **Modern UI** - Desain modern dengan tema Indonesia
- 📱 **Responsive** - Tampilan yang optimal di berbagai ukuran layar

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0 atau lebih tinggi
- Dart 3.0 atau lebih tinggi
- Android Studio / VS Code dengan Flutter extension
- Emulator atau Physical Device

### Installation

1. **Clone atau Download Project**
   ```bash
   cd nesiaway
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## 🔑 Default Login Credentials

```
Email: admin@gmail.com
Password: admin12345
```

## 🌐 Mock API

Aplikasi ini menggunakan Mock API untuk CRUD operations:

**Base URL:** `https://691e876fbb52a1db22be25e9.mockapi.io/api/v1`

**Endpoint:** `/blogs`

### API Schema

```json
{
  "id": "string",
  "title": "string",
  "category": "string",
  "body": "string",
  "banner": "string (URL)",
  "images": ["string (URL)", "string (URL)"]
}
```

### Supported Categories

- Wisata Alam
- Kuliner
- Budaya
- Pantai
- Gunung
- Kuliner Tradisional
- Festival
- Arsitektur

## 📁 Project Structure

```
nesiaway/
├── lib/
│   ├── main.dart                 # Entry point
│   ├── models/
│   │   ├── blog_model.dart       # Blog data model
│   │   └── user_model.dart       # User data model
│   ├── services/
│   │   ├── api_service.dart      # HTTP API calls
│   │   └── auth_service.dart     # Authentication service
│   ├── providers/
│   │   ├── blog_provider.dart    # Blog state management
│   │   └── auth_provider.dart    # Auth state management
│   ├── screens/
│   │   ├── auth/
│   │   │   └── login_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── blog/
│   │   │   ├── blog_list_screen.dart
│   │   │   ├── blog_detail_screen.dart
│   │   │   └── blog_form_screen.dart
│   │   └── profile/
│   │       └── profile_screen.dart
│   ├── widgets/
│   │   ├── blog_card.dart        # Reusable blog card
│   │   └── custom_button.dart    # Reusable button
│   └── utils/
│       ├── constants.dart        # App constants
│       └── theme.dart            # App theme
├── pubspec.yaml
└── README.md
```

## 🎨 Tech Stack

- **Framework:** Flutter 3.0+
- **Language:** Dart 3.0+
- **State Management:** Provider
- **HTTP Client:** http package
- **Image Caching:** cached_network_image
- **Local Storage:** shared_preferences
- **Architecture:** Provider Pattern (MVVM-like)

## 📦 Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1              # State management
  http: ^1.1.0                  # HTTP requests
  cached_network_image: ^3.3.0 # Image caching
  shared_preferences: ^2.2.2   # Local storage
  intl: ^0.18.1                # Date formatting
  flutter_spinkit: ^5.2.0      # Loading indicators
```

## 🔧 Configuration

### Mengubah Base URL

Edit file `lib/utils/constants.dart`:

```dart
class Constants {
  static const String baseUrl = 'YOUR_NEW_BASE_URL';
  static const String blogEndpoint = 'YOUR_ENDPOINT';
}
```

### Mengubah Theme Colors

Edit file `lib/utils/constants.dart`:

```dart
class AppColors {
  static const Color primary = Color(0xFF1E88E5);
  static const Color secondary = Color(0xFFFF6B35);
  // ... customize other colors
}
```

## 📱 Screenshots

### Login Screen
- Modern login interface dengan Indonesian theme
- Form validation
- Default credentials info

### Blog List
- Grid/List view of blogs
- Search functionality
- Category filtering
- Pull to refresh

### Blog Detail
- Full blog content
- Image gallery
- Edit button

### Blog Form
- Create/Edit blog
- Category selection
- Multiple image support
- Form validation

### Profile
- User information
- App info
- Logout functionality

## 🎯 Fitur CRUD

### Create (Tambah Blog)
1. Tap tombol FAB "Buat Blog"
2. Isi form (judul, kategori, konten, banner, gambar)
3. Tap "Simpan Blog"

### Read (Lihat Blog)
1. Browse blog di halaman utama
2. Tap blog untuk melihat detail
3. Gunakan search dan filter untuk mencari blog

### Update (Edit Blog)
1. Buka detail blog
2. Tap tombol edit (FAB atau dalam card)
3. Edit form
4. Tap "Update Blog"

### Delete (Hapus Blog)
1. Di blog card, tap tombol "Hapus"
2. Konfirmasi penghapusan
3. Blog akan terhapus

## 🐛 Troubleshooting

### Build Issues

```bash
flutter clean
flutter pub get
flutter run
```

### API Connection Issues

- Pastikan device/emulator terkoneksi internet
- Cek Mock API endpoint masih aktif
- Periksa console untuk error messages

### Image Loading Issues

- Pastikan URL image valid
- Gunakan URL image dari sumber yang reliable
- Clear app data jika cache bermasalah

## 🤝 Contributing

Contributions are welcome! Untuk kontribusi:

1. Fork project
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.
**Made with ❤️ for Indonesia 🇮🇩**

*Bangga Menjelajah Indonesia*