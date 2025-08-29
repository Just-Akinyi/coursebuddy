// ✅ The Dart way to conditionally run code only in debug mode is to use:

// assert(() {
//   print("Something in debug only");
//   return true;
// }());
import 'package:coursebuddy/auth/login_screen.dart';
import 'package:coursebuddy/utils/user_router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  static const int maxDaysLoggedIn = 7;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) return const LoginScreen();

        final lastSignIn = user.metadata.lastSignInTime ?? DateTime.now();
        final daysDiff = DateTime.now().difference(lastSignIn).inDays;

        // ✅ Debug-only log
        if (kDebugMode) {
          print("User last signed in: ${user.metadata.lastSignInTime}");
        }

        if (daysDiff > maxDaysLoggedIn) {
          FirebaseAuth.instance.signOut();
          return const LoginScreen();
        }

        return FutureBuilder<Widget>(
          future: getDashboardForUser(user.email ?? ""),
          builder: (ctx, snap) {
            if (!snap.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return snap.data!;
          },
        );
      },
    );
  }
}
