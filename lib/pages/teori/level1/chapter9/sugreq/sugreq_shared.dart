import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kSugReqAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

class Tip { final String title; final String text; const Tip(this.title, this.text); }

class SugReqVocab {
  final String phrase;     // EN
  final String indo;       // ID meaning
  final String type;       // 'suggestion' | 'request' | 'response'
  final String? note;      // short usage note
  final String? example;   // example sentence
  final String? ipa;
  final String? audio;
  const SugReqVocab({
    required this.phrase,
    required this.indo,
    required this.type,
    this.note,
    this.example,
    this.ipa,
    this.audio,
  });
}

class MCQItem {
  final String prompt;
  final List<String> options;
  final int correct;
  final String explain;
  const MCQItem({required this.prompt, required this.options, required this.correct, required this.explain});
}

class Pair { final String left; final String right; final String explain; const Pair({required this.left, required this.right, required this.explain}); }
class Choice { final int id; final String text; final String key; const Choice({required this.id, required this.text, required this.key}); }

const T_SUG = 'suggestion';
const T_REQ = 'request';
const T_RES = 'response';

final kSugReqVocab = <SugReqVocab>[
  // Suggestions
  SugReqVocab(phrase: 'You should + V1', indo: 'Kamu sebaiknya...', type: T_SUG, note: 'Netral, cukup langsung', example: 'You should talk to your teacher.'),
  SugReqVocab(phrase: 'How about + V-ing ...?', indo: 'Bagaimana kalau ...?', type: T_SUG, note: 'Santai/ramah', example: 'How about trying a different approach?'),
  SugReqVocab(phrase: 'Why don’t you + V1 ...?', indo: 'Kenapa tidak ...?', type: T_SUG, note: 'Sangat umum', example: 'Why don’t you call him now?'),
  SugReqVocab(phrase: 'Let’s + V1', indo: 'Ayo/Marilah ...', type: T_SUG, note: 'Mengajak bersama', example: 'Let’s take a break.'),
  SugReqVocab(phrase: 'If I were you, I would ...', indo: 'Kalau aku jadi kamu, aku akan ...', type: T_SUG, example: 'If I were you, I would apologize.'),
  SugReqVocab(phrase: 'I suggest (that) you + V1', indo: 'Saya menyarankan kamu untuk ...', type: T_SUG, note: 'Lebih formal', example: 'I suggest you back up your files.'),
  // Requests
  SugReqVocab(phrase: 'Can you + V1 ...?', indo: 'Bisakah kamu ...?', type: T_REQ, note: 'Netral', example: 'Can you help me with this?'),
  SugReqVocab(phrase: 'Could you + V1 ...?', indo: 'Dapatkah Anda ...?', type: T_REQ, note: 'Lebih sopan', example: 'Could you open the window, please?'),
  SugReqVocab(phrase: 'Would you mind + V-ing ...?', indo: 'Apakah Anda keberatan untuk ...?', type: T_REQ, note: 'Sangat sopan', example: 'Would you mind waiting here?'),
  SugReqVocab(phrase: 'May I + V1 ...?', indo: 'Bolehkah saya ...?', type: T_REQ, note: 'Meminta izin (formal)', example: 'May I use your phone?'),
  SugReqVocab(phrase: 'Can I + V1 ...?', indo: 'Bolehkah aku ...?', type: T_REQ, note: 'Meminta izin (netral)', example: 'Can I leave early today?'),
  // Responses
  SugReqVocab(phrase: 'Sure, no problem.', indo: 'Tentu, tidak masalah.', type: T_RES),
  SugReqVocab(phrase: 'I’m afraid I can’t.', indo: 'Maaf, saya tidak bisa.', type: T_RES),
  SugReqVocab(phrase: 'That sounds great.', indo: 'Kedengarannya bagus.', type: T_RES),
  SugReqVocab(phrase: 'I’d rather not.', indo: 'Saya lebih memilih tidak.', type: T_RES),
];

final kSugReqCategories = const [T_SUG, T_REQ, T_RES];

/// UI helpers
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

Widget infoBadge({required IconData icon, required String text, Color? color}) {
  final c = color ?? Colors.indigo;
  return Container(
    margin: const EdgeInsets.only(top: 4, bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: c.withValues(alpha:0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: c.withValues(alpha:0.25), width: 1),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: c, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]))),
      ],
    ),
  );
}

Widget vocabTile(SugReqVocab v, {Color color = Colors.teal, AudioService? audio}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha:0.25)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha:0.25)),
                ),
                child: Text(v.type.toUpperCase(), style: primaryTextStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(v.phrase, style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700))),
              if (audio != null)
                IconButton(
                  tooltip: 'Play',
                  onPressed: () => audio.playSound(v.audio ?? kSugReqAudioUrl),
                  icon: Icon(Icons.volume_up, color: color, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          Text(v.indo, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800])),
          if (v.ipa != null) Text(v.ipa!, style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700])),
          if (v.note != null) Text('Note: ${v.note!}', style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700])),
          if (v.example != null) ...[
            const SizedBox(height: 4),
            Text(v.example!, style: primaryTextStyle.copyWith(fontSize: 12)),
          ],
        ],
      ),
    ),
  );
}

/// Utils
List<SugReqVocab> byType(String type) => kSugReqVocab.where((e) => e.type == type).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
