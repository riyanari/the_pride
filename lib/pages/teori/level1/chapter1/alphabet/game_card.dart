import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String letter;
  final String sound;
  final String word;
  final String imagePath;
  final String audioUrl;
  final Color color;
  final bool isPlaying;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.letter,
    required this.sound,
    required this.word,
    required this.imagePath,
    required this.audioUrl,
    required this.color,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isPlaying ? color.withValues(alpha:0.8) : color.withValues(alpha:0.6),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha:0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isPlaying
                ? [color, color.withValues(alpha:0.7)]
                : [color.withValues(alpha:0.7), color.withValues(alpha:0.4)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text("belum tau apa"),
          ),
        ),
      ),
    );
  }
}