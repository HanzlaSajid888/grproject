import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('users');

  User? _user;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _userData?['isAdmin'] == true;

  AuthProvider() {
    _auth.authStateChanges().listen((User? newUser) async {
      _user = newUser;
      if (newUser != null) {
        await fetchUserData(newUser.uid);
      } else {
        _userData = null;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> fetchUserData(String uid) async {
    final snapshot = await _dbRef.child(uid).get();
    if (snapshot.exists) {
      _userData = Map<String, dynamic>.from(snapshot.value as Map);
      notifyListeners();
    }
  }

  Future<void> updateProfile({required String name, required String phone, required String address}) async {
    if (_user == null) return;
    await _dbRef.child(_user!.uid).update({
      'name': name,
      'phone': phone,
      'address': address,
    });
    await fetchUserData(_user!.uid);
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Auto-assign admin role to specific email
        bool isUserAdmin = email.toLowerCase() == 'admin@luxemart.com';

        // Save user profile to Realtime Database
        await _dbRef.child(credential.user!.uid).set({
          'name': name,
          'email': email,
          'isAdmin': isUserAdmin,
          'createdAt': ServerValue.timestamp,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
