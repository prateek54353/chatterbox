import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _Dot(size: 8, color: Colors.grey),
        SizedBox(width: 4),
        _Dot(size: 8, color: Colors.grey),
        SizedBox(width: 4),
        _Dot(size: 8, color: Colors.grey),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final double size;
  final Color color;

  const _Dot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
