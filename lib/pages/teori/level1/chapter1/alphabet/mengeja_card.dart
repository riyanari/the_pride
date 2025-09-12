import 'package:flutter/material.dart';

class MengejaCard extends StatelessWidget {
  final String letter;
  final String sound;
  final String word;
  final String imagePath;
  final String audioUrl;
  final Color color;
  final bool isPlaying;
  final VoidCallback onTap;

  const MengejaCard({
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Letter
              Text(
                letter,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isPlaying ? Colors.white : Colors.grey[800],
                ),
              ),
              // Image at the top
              Center(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withValues(alpha:0.3),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Word
              Center(
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isPlaying ? Colors.white : Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}