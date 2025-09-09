import 'package:flutter/material.dart';

class AlphabetCard extends StatelessWidget {
  final String letter;
  final String sound;
  final String audioUrl;
  final Color color;
  final bool isPlaying;
  final VoidCallback onTap;

  const AlphabetCard({
    super.key,
    required this.letter,
    required this.sound,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              letter,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isPlaying ? Colors.white : Colors.grey[800],
              ),
            ),
            Text(
              sound,
              style: TextStyle(
                fontSize: 16,
                color: isPlaying ? Colors.white70 : Colors.grey[700],
              ),
            ),
            // if (isPlaying)
            //   const Padding(
            //     padding: EdgeInsets.only(top: 8.0),
            //     child: SizedBox(
            //       width: 20,
            //       height: 20,
            //       child: CircularProgressIndicator(
            //         strokeWidth: 2,
            //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}