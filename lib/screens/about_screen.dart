// lib/screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Chatterbox'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/chatterbox_logo.png', // Corrected image path
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 120, color: Colors.redAccent);
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Chatterbox',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              const Text(
                'Your all-in-one AI assistant for text, images, and code. Built with Flutter and love.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 32),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.code, color: Colors.white),
                title: const Text('Source Code on GitHub', style: TextStyle(color: Colors.white)),
                onTap: () => _launchUrl('https://github.com/prateek54353/chatterbox'),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('Developed by Prateek', style: TextStyle(color: Colors.white)),
                onTap: () => _launchUrl('https://prateek.co'),
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.pinkAccent),
                title: const Text('Sponsor this project', style: TextStyle(color: Colors.white)),
                onTap: () => _launchUrl('https://coff.ee/prateek.aish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}