import 'package:flutter/material.dart';

Widget buildSettingsTile({required IconData icon, required String title, required VoidCallback onTap}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: onTap,
  );
}
