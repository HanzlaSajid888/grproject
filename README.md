[readme gr.md](https://github.com/user-attachments/files/28171510/readme.gr.md)
# 🛍️ LuxeMart — Flutter E-Commerce App

A full-featured, real-world E-Commerce mobile application built with **Flutter & Firebase**. Started as a class project and evolved into a complete, production-ready app with both a user-facing storefront and a powerful admin panel.

---

## 📱 Screenshots

| Home Screen | Admin Panel | Payment |
|---|---|---|
| ![Home](screenshots/ss_home.jpeg) | ![Admin](screenshots/ss_admin.jpeg) | ![Payment](screenshots/ss_payment.jpeg) |

---

## ✨ Features

### 👤 User Side
- 🔐 Sign Up / Sign In with Firebase Authentication
- 🏠 Home Screen with product listings
- 🔍 Search & Category browsing
- 📦 Product Detail page
- ❤️ Wishlist management
- 🛒 Add to Cart & Cart management
- 📋 Order Information & Checkout flow
- 💳 Payment page
- 👤 Profile & Edit Profile

### 👨‍💼 Admin Panel
- ➕ Add new products
- 📦 Manage existing products
- 📋 Manage & track orders

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| Flutter | UI Framework |
| Dart | Programming Language |
| Firebase Auth | User Authentication |
| Firebase Realtime Database | Real-time data sync |
| Cloud Firestore | Product & order storage |
| Provider | State Management |
| Google Fonts | Typography |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.9.2`
- Dart SDK
- Firebase project setup
- Android Studio / VS Code

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/HanzlaSajid888/grproject.git
cd luxemart
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Firebase Setup**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable **Authentication** (Email/Password)
   - Enable **Firestore Database**
   - Enable **Realtime Database**
   - Download `google-services.json` and place it in `android/app/`
   - Replace `lib/firebase_options.dart` with your own Firebase config

4. **Run the app**
```bash
flutter run
```

---

## 📁 Project Structure

```
lib/
├── admin/
│   ├── admin_dashboard.dart
│   ├── add_product_page.dart
│   ├── manage_products_page.dart
│   └── manage_orders_page.dart
├── models/
│   ├── product.dart
│   └── cart_item.dart
├── providers/
│   ├── auth_provider.dart
│   ├── cart_provider.dart
│   ├── product_provider.dart
│   └── wishlist_provider.dart
├── widgets/
│   └── product_card.dart
├── home_screen.dart
├── product_detail_page.dart
├── cart_page.dart
├── checkout_page.dart
├── payment_page.dart
├── wishlist_page.dart
├── search_page.dart
├── category_page.dart
├── profile_page.dart
├── edit_profile_page.dart
├── sign_in_page.dart
├── sign_up_page.dart
├── splash_screen.dart
└── main.dart
```

---

## 🔑 Admin Access

To access the Admin Panel, use the admin credentials set up in your Firebase project. The admin dashboard provides full control over products and orders.

---

## 📦 Dependencies

```yaml
google_fonts: ^8.1.0
firebase_core: ^4.8.0
firebase_auth: ^6.5.0
firebase_database: ^12.4.0
cloud_firestore: ^6.4.0
provider: ^6.1.5+1
cupertino_icons: ^1.0.8
```

---

## 🎓 About This Project

This project started as a **university class assignment** and was later converted into a fully functional, real-world application. Every screen and feature was built from scratch — from authentication to checkout to admin control.

---

## 🙌 Connect With Me

- LinkedIn: [Hanzla Sajid](https://www.linkedin.com/in/hanzla-sajid-flutter/)
- GitHub: [HanzlaSajid888](https://github.com/HanzlaSajid888/grproject)

---

> ⭐ If you found this project helpful, please give it a star!
