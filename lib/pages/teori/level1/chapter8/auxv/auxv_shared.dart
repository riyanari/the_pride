import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kAuxAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }

class AuxVocab {
  final String aux;         // "be", "do", "have"
  final String forms;       // "am/is/are" dst.
  final String function;    // fungsi singkat
  final String category;    // 'be' | 'do' | 'have'
  final String? example;    // contoh kalimat
  final String? ipa;        // opsional
  final String? audio;      // opsional
  const AuxVocab({
    required this.aux,
    required this.forms,
    required this.function,
    required this.category,
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

/// ===== Categories =====
const CAT_BE   = 'be';
const CAT_DO   = 'do';
const CAT_HAVE = 'have';

final kAuxCategories = const [CAT_BE, CAT_DO, CAT_HAVE];

/// ===== Vocabulary =====
final List<AuxVocab> kAuxVocab = [
  // BE
  AuxVocab(
    aux: 'be',
    forms: 'am / is / are',
    function: 'Present continuous, nominal sentence, passive',
    category: CAT_BE,
    example: 'She is studying. / They are happy.',
    ipa: '/biː/',
  ),
  AuxVocab(
    aux: 'be',
    forms: 'was / were',
    function: 'Past continuous, nominal lampau, passive',
    category: CAT_BE,
    example: 'We were tired. / It was built in 1990.',
  ),

  // DO
  AuxVocab(
    aux: 'do',
    forms: 'do / does',
    function: 'Bantu present simple (tanya/negatif)',
    category: CAT_DO,
    example: 'Do you like tea? / He does not play.',
    ipa: '/duː/',
  ),
  AuxVocab(
    aux: 'do',
    forms: 'did',
    function: 'Bantu past simple (tanya/negatif)',
    category: CAT_DO,
    example: 'Did she call? / I did not go.',
  ),

  // HAVE
  AuxVocab(
    aux: 'have',
    forms: 'have / has',
    function: 'Present perfect (sudah/pernah)',
    category: CAT_HAVE,
    example: 'She has finished. / I have seen it.',
    ipa: '/hæv/',
  ),
  AuxVocab(
    aux: 'have',
    forms: 'had',
    function: 'Past perfect / kepemilikan lampau',
    category: CAT_HAVE,
    example: 'They had left before 6.',
  ),
];

/// ===== Helpers UI =====
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

Widget auxTile(AuxVocab v, {Color color = Colors.teal, AudioService? audio}) {
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
              Expanded(child: Text(v.aux.toUpperCase(), style: primaryTextStyle.copyWith(fontWeight: semiBold), maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (audio != null)
                SizedBox(
                  width: 32, height: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                    tooltip: 'Play',
                    onPressed: () => audio.playSound(v.audio ?? kAuxAudioUrl),
                    icon: Icon(Icons.volume_up, color: color, size: 20),
                  ),
                ),
            ],
          ),
          Text(v.forms, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(v.function, style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]), maxLines: null),
          if (v.example != null) ...[
            const SizedBox(height: 4),
            Text(v.example!, style: primaryTextStyle.copyWith(fontSize: 12), maxLines: 3, overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    ),
  );
}

/// Utils
List<AuxVocab> byCat(String cat) => kAuxVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
