import 'package:flutter/material.dart';
import '../widgets/_build_settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          buildSettingsTile(
            icon: Icons.brightness_6,
            title: 'Theme',
            onTap: () {
              // TODO: Implement theme switcher
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme switching coming soon!')),
              );
            },
          ),
          buildSettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              // TODO: Implement notifications settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications settings coming soon!')),
              );
            },
          ),
          const Divider(),
          buildSettingsTile(
            icon: Icons.delete_forever,
            title: 'Clear Chat History',
            onTap: () {
              // TODO: Implement clear chat history
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Clear chat history coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }
}
