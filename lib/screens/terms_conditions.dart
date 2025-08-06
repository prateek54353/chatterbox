import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Terms & Conditions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('By using Chatterbox, you agree to use the app for lawful purposes only. You may not use the app to harass, abuse, or harm others, or to submit content that is illegal or offensive. The app is provided as-is, without warranties of any kind. The developer is not liable for any damages arising from your use of the app.'),
              SizedBox(height: 24),
              Text('Your continued use of Chatterbox constitutes acceptance of these terms.'),
            ],
          ),
        ),
      ),
    );
  }
}
