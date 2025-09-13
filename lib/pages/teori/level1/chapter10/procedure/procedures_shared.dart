import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kProcAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }

class ProcVocab {
  final String term;      // kata/frasal kerja/penanda urutan
  final String indo;      // arti Indonesia
  final String category;  // sequencer | verb | notice | tool | unit
  final String? ipa;      // opsional
  final String? example;  // contoh
  final String? audio;    // opsional
  const ProcVocab({required this.term, required this.indo, required this.category, this.ipa, this.example, this.audio});
}

class MCQItem {
  final String prompt; final List<String> options; final int correct; final String explain;
  const MCQItem({required this.prompt, required this.options, required this.correct, required this.explain});
}

class Pair { final String left; final String right; final String explain; const Pair({required this.left, required this.right, required this.explain}); }
class Choice { final int id; final String text; final String key; const Choice({required this.id, required this.text, required this.key}); }

/// ===== Categories =====
const C_SEQ   = 'sequencers';
const C_VERB  = 'imperative_verbs';
const C_NOTICE= 'notices';
const C_TOOL  = 'tools_materials';
const C_UNIT  = 'time_temp_units';

final kProcCategories = const [C_SEQ, C_VERB, C_NOTICE, C_TOOL, C_UNIT];

/// ===== Vocabulary =====
final List<ProcVocab> kProcVocab = [
  // Sequencers
  ProcVocab(term:'first',    indo:'pertama', category:C_SEQ, example:'First, wash your hands.'),
  ProcVocab(term:'next',     indo:'selanjutnya', category:C_SEQ, example:'Next, chop the onions.'),
  ProcVocab(term:'then',     indo:'lalu', category:C_SEQ),
  ProcVocab(term:'after that', indo:'setelah itu', category:C_SEQ),
  ProcVocab(term:'finally',  indo:'terakhir', category:C_SEQ, example:'Finally, serve warm.'),
  ProcVocab(term:'meanwhile', indo:'sementara itu', category:C_SEQ),

  // Imperative verbs
  ProcVocab(term:'mix',       indo:'campurkan', category:C_VERB, example:'Mix the flour and sugar.'),
  ProcVocab(term:'stir',      indo:'aduk', category:C_VERB),
  ProcVocab(term:'boil',      indo:'rebus', category:C_VERB),
  ProcVocab(term:'preheat',   indo:'panaskan terlebih dahulu', category:C_VERB, example:'Preheat the oven to 180°C.'),
  ProcVocab(term:'attach',    indo:'pasangkan', category:C_VERB),
  ProcVocab(term:'tighten',   indo:'kencangkan', category:C_VERB),
  ProcVocab(term:'unplug',    indo:'cabut (colokan)', category:C_VERB),
  ProcVocab(term:'press',     indo:'tekan', category:C_VERB),

  // Notices
  ProcVocab(term:'warning',   indo:'peringatan', category:C_NOTICE),
  ProcVocab(term:'caution',   indo:'hati-hati', category:C_NOTICE),
  ProcVocab(term:'note',      indo:'catatan', category:C_NOTICE, example:'Note: Do not overmix.'),
  ProcVocab(term:'must',      indo:'harus', category:C_NOTICE),
  ProcVocab(term:'should',    indo:'sebaiknya', category:C_NOTICE),

  // Tools / materials
  ProcVocab(term:'screwdriver', indo:'obeng', category:C_TOOL),
  ProcVocab(term:'wrench',      indo:'kunci inggris', category:C_TOOL),
  ProcVocab(term:'bowl',        indo:'mangkuk', category:C_TOOL),
  ProcVocab(term:'pan',         indo:'wajan', category:C_TOOL),
  ProcVocab(term:'gloves',      indo:'sarung tangan', category:C_TOOL),

  // Units
  ProcVocab(term:'minute(s)',   indo:'menit', category:C_UNIT),
  ProcVocab(term:'hour(s)',     indo:'jam', category:C_UNIT),
  ProcVocab(term:'degree(s) Celsius', indo:'derajat Celsius', category:C_UNIT),
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
      border: Border.all(color: c.withValues(alpha:0.25)),
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

Widget procTile(ProcVocab v, {Color color = Colors.teal, AudioService? audio}) {
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
              Expanded(child: Text(v.term, style: primaryTextStyle.copyWith(fontWeight: semiBold), maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (audio != null)
                IconButton(
                  tooltip: 'Play',
                  onPressed: () => audio.playSound(v.audio ?? kProcAudioUrl),
                  icon: Icon(Icons.volume_up, color: color, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          Text(v.indo, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]), maxLines: null),
          if (v.ipa != null) Text(v.ipa!, style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]), maxLines: null),
          if (v.example != null) ...[
            const SizedBox(height: 4),
            Text(v.example!, style: primaryTextStyle.copyWith(fontSize: 12), maxLines: null),
          ],
        ],
      ),
    ),
  );
}

/// Utils
List<ProcVocab> byCat(String cat) => kProcVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
