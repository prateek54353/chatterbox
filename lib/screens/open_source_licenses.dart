import 'package:flutter/material.dart';

class OpenSourceLicensesScreen extends StatelessWidget {
  const OpenSourceLicensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Source Licenses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Open Source Licenses', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Chatterbox uses open-source packages including Flutter, Pollinations.ai API, and others. For a full list of dependencies and their licenses, see the pubspec.yaml and the LICENSE files of each dependency.'),
              SizedBox(height: 24),
              Text('This app is open source and available on GitHub.'),
            ],
          ),
        ),
      ),
    );
  }
}
