import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Privacy Policy', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Chatterbox does not collect, store, or share any personal information. All conversations and data are stored locally on your device. No data is sent to any server except for AI text/image generation, which is handled by Pollinations.ai. The developer does not have access to your data.'),
              SizedBox(height: 24),
              Text('By using Chatterbox, you consent to this privacy policy.'),
            ],
          ),
        ),
      ),
    );
  }
}
