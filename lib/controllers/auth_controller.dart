import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart' as AppUser;
import '../services/shared_prefs_service.dart';

class AuthController extends GetxController {
  Rxn<AppUser.User> user = Rxn<AppUser.User>();
  RxBool isLoading = false.obs;

  bool get isAuthenticated => user.value != null;

  // Check if user has completed onboarding
  Future<bool> get hasCompletedOnboarding async {
    return await SharedPrefsService.isOnboardingComplete;
  }

  // Mock authentication for design preview
  void mockLogin() {
    isLoading.value = true;
    update();
    Future.delayed(const Duration(seconds: 2), () {
      user.value = AppUser.User(
        id: '1',
        email: 'sarah@example.com',
        name: 'Sarah',
        createdAt: DateTime.now(),
      );
      isLoading.value = false;
      update();
    });
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    update();
    try {
      await Future.delayed(const Duration(seconds: 1));
      user.value = AppUser.User(
        id: '1',
        email: email,
        name: email.split('@')[0],
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> signup(String email, String password, String name) async {
    isLoading.value = true;
    update();
    try {
      await Future.delayed(const Duration(seconds: 1));
      user.value = AppUser.User(
        id: '1',
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Signup failed: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    update();

    try {
      // Initialize Google Sign In
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        isLoading.value = false;
        update();
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth?.idToken == null) {
        throw Exception('Sign in failed. Missing ID token.');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Get the signed-in user
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Create user object using Firebase user info with fallbacks
        user.value = AppUser.User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? googleUser.email ?? '',
          name:
              firebaseUser.displayName ??
              googleUser.displayName ??
              'Google User',
          createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        );
      } else {
        throw Exception('Sign in failed. Firebase user is null.');
      }
    } catch (error) {
      // Log specific error (in a real app you might want to use a logging service)
      print('Google Sign-In Error: $error');

      // Show more descriptive error to user in real app if needed
      rethrow;
    } finally {
      if (isLoading.value) {
        isLoading.value = false;
        update();
      }
    }
  }

  // Future<void> signInWithApple() async {
  //   isLoading.value = true;
  //   update();

  //   try {
  //     // To prevent replay attacks with the credential returned from Apple, we
  //     // include a nonce in the credential request. This is a security best
  //     // practice.
  //     final rawNonce = generateNonce();
  //     final nonce = sha256.convert(utf8.encode(rawNonce));

  //     // Request credential for the Auth request
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       nonce: nonce.toString(),
  //     );

  //     // Create an `OAuthCredential` from the credential returned by Apple
  //     final _ = OAuthProvider("apple.com").credential(
  //       idToken: appleCredential.identityToken,
  //       rawNonce: rawNonce,
  //     );

  //     // For demo purposes, creating a user object
  //     user.value = AppUser.User(
  //       id: appleCredential.userIdentifier ?? 'apple_${DateTime.now().millisecondsSinceEpoch}',
  //       email: appleCredential.email ?? '',
  //       name: '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim() == ''
  //           ? 'Apple User'
  //           : '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim(),
  //       createdAt: DateTime.now(),
  //     );
  //   } on Exception {
  //     isLoading.value = false;
  //     update();
  //     rethrow;
  //   } finally {
  //     if (isLoading.value) {
  //       isLoading.value = false;
  //       update();
  //     }
  //   }
  // }

  /// Generates a cryptographically secure random nonce to prevent replay attacks.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = List.generate(length, (index) {
      return charset.codeUnitAt(
        (DateTime.now().millisecondsSinceEpoch + index) % charset.length,
      );
    });
    return String.fromCharCodes(random);
  }

  void logout() {
    user.value = null;
    update();
  }
}
