// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatterbox/screens/home_screen.dart';
import 'package:chatterbox/screens/onboarding_screen.dart';
import 'package:chatterbox/screens/about_screen.dart';
import 'package:chatterbox/screens/settings_screen.dart';
import 'package:chatterbox/screens/terms_conditions.dart';
import 'package:chatterbox/screens/privacy_policy.dart';
import 'package:chatterbox/screens/open_source_licenses.dart';
import 'package:chatterbox/screens/recent_chats_screen.dart';

void main() {
  // This is the global error handler.
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // --- Flutter Error Handling ---
    // Catches errors that occur within the Flutter framework.
    FlutterError.onError = (FlutterErrorDetails details) {
      // In a real app, you would log this to a service like Sentry, Firebase Crashlytics, etc.
      // You could also show a dialog to the user here if appropriate.
    };

    runApp(const ChatterboxApp());
  }, (error, stack) {
    // --- Dart Error Handling ---
    // Catches errors that occur outside of the Flutter framework (in the Dart Zone).
    // Again, log this to a remote service in a production app.
  });
}

class ChatterboxApp extends StatelessWidget {
  const ChatterboxApp({super.key});

  Future<bool> _isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatterbox',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.tealAccent,
          surface: Colors.black,
          error: Colors.redAccent,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _isOnboardingComplete(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return const Scaffold(body: Center(child: Text('Error loading preferences.')));
          }
          final bool onboardingComplete = snapshot.data ?? false;
          return onboardingComplete ? const HomeScreen() : const OnboardingScreen();
        },
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutScreen());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/terms':
            return MaterialPageRoute(builder: (_) => const TermsConditionsScreen());
          case '/privacy':
            return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
          case '/licenses':
            return MaterialPageRoute(builder: (_) => const OpenSourceLicensesScreen());
          case '/recent_chats':
            return MaterialPageRoute(builder: (_) => const RecentChatsScreen());
          default:
            return null; // Let onUnknownRoute handle it
        }
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
      },
    );
  }
}