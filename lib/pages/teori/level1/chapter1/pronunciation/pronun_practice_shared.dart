import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';

/// ==== Models ====
class ShadowLine {
  final String text;
  final String audio;
  const ShadowLine(this.text, this.audio);
}

class MinimalPair {
  final String aWord; final String bWord;
  final String aAudio; final String bAudio;
  final String contrast;
  const MinimalPair({
    required this.aWord, required this.bWord,
    required this.aAudio, required this.bAudio,
    required this.contrast,
  });
}

class SyllableItem {
  final String word; final int count;
  const SyllableItem(this.word, this.count);
}

class StressItem {
  final String word; final List<String> syl; final int stress;
  const StressItem(this.word, this.syl, this.stress);
}

/// ==== UI helpers ====
Widget sectionTitle(String text, Color color) => Row(
  children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Text(text, style: primaryTextStyle.copyWith(fontWeight: FontWeight.bold)),
    ),
  ],
);

Widget infoBadge({required IconData icon, required String text, required Color color}) {
  return Container(
    margin: const EdgeInsets.only(top: 4, bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: color.withValues(alpha:0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha:0.25), width: 1),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]))),
      ],
    ),
  );
}

Widget bigChoiceButton(String text, VoidCallback onTap) {
  return SizedBox(
    width: 150, height: 56,
    child: ElevatedButton(
      onPressed: onTap,
      child: Text(text, style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 18)),
    ),
  );
}
