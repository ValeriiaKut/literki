import 'package:flutter/material.dart';
import 'home_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Literki',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5C3D11),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Wybierz, czego chcesz się uczyć',
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF8D6E37),
              ),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ModuleButton(
                  label: 'Litery',
                  emoji: '🔤',
                  color: const Color(0xFF64B5F6),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  ),
                ),
                const SizedBox(width: 40),
                _ModuleButton(
                  label: 'Cyfry',
                  emoji: '🔢',
                  color: const Color(0xFF81C784),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleButton extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _ModuleButton({
    required this.label,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
