import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Sign out from Google (ignore errors if not signed in)
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    // ✅ Navigate only if context is still mounted
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  } catch (e) {
    // handle logout errors
    debugPrint('Logout error: $e');
  }
}
