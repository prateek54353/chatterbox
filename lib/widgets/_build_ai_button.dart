import 'package:flutter/material.dart';

Widget buildAiButton({required String title, required String description, required IconData icon, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 16),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    ),
  );
}
