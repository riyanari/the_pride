import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kQWAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }

class QWVocab {
  final String word;      // who, what, how many...
  final String indo;      // siapa, apa, dst
  final String category;  // basic/compound
  final String? ipa;      // optional IPA
  final String? example;  // contoh kalimat
  final String? note;     // catatan singkat
  final String? audio;
  const QWVocab({
    required this.word,
    required this.indo,
    required this.category,
    this.ipa,
    this.example,
    this.note,
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
const CAT_BASIC    = 'basic';
const CAT_COMPOUND = 'compound';

final kQWCategories = const [CAT_BASIC, CAT_COMPOUND];

/// ===== Vocabulary =====
final List<QWVocab> kQWVocab = [
  // Basic
  QWVocab(word: 'who', indo: 'siapa', category: CAT_BASIC, ipa: '/huː/', example: 'Who is your teacher?', note: 'Menanyakan orang.'),
  QWVocab(word: 'what', indo: 'apa', category: CAT_BASIC, ipa: '/wɒt/', example: 'What is this?', note: 'Menanyakan benda/hal umum.'),
  QWVocab(word: 'where', indo: 'di mana', category: CAT_BASIC, ipa: '/weə/', example: 'Where do you live?', note: 'Lokasi/tempat.'),
  QWVocab(word: 'when', indo: 'kapan', category: CAT_BASIC, ipa: '/wen/', example: 'When is your birthday?', note: 'Waktu.'),
  QWVocab(word: 'why', indo: 'mengapa', category: CAT_BASIC, ipa: '/waɪ/', example: 'Why are you late?', note: 'Alasan/penyebab.'),
  QWVocab(word: 'which', indo: 'yang mana', category: CAT_BASIC, ipa: '/wɪtʃ/', example: 'Which bag is yours?', note: 'Pilihan tertentu.'),
  QWVocab(word: 'whose', indo: 'milik siapa', category: CAT_BASIC, ipa: '/huːz/', example: 'Whose book is this?', note: 'Kepemilikan.'),
  QWVocab(word: 'whom', indo: 'siapa (objek)', category: CAT_BASIC, ipa: '/huːm/', example: 'Whom did you meet?', note: 'Bersifat formal; objek.'),
  QWVocab(word: 'how', indo: 'bagaimana', category: CAT_BASIC, ipa: '/haʊ/', example: 'How are you?', note: 'Cara/kondisi.'),

  // Compound
  QWVocab(word: 'how many', indo: 'berapa (benda dapat dihitung)', category: CAT_COMPOUND, example: 'How many apples?', note: 'Countable.'),
  QWVocab(word: 'how much', indo: 'berapa (tak terhitung/harga)', category: CAT_COMPOUND, example: 'How much water / How much is it?', note: 'Uncountable/harga.'),
  QWVocab(word: 'how old', indo: 'berapa umur', category: CAT_COMPOUND, example: 'How old are you?'),
  QWVocab(word: 'how long', indo: 'berapa lama', category: CAT_COMPOUND, example: 'How long is the movie?'),
  QWVocab(word: 'how far', indo: 'seberapa jauh', category: CAT_COMPOUND, example: 'How far is the station?'),
  QWVocab(word: 'how often', indo: 'seberapa sering', category: CAT_COMPOUND, example: 'How often do you exercise?'),
  QWVocab(word: 'how tall', indo: 'seberapa tinggi', category: CAT_COMPOUND, example: 'How tall is he?'),
  QWVocab(word: 'how fast', indo: 'seberapa cepat', category: CAT_COMPOUND, example: 'How fast can you run?'),
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

Widget qwTile(QWVocab v, {Color color = Colors.teal, AudioService? audio}) {
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
              Expanded(child: Text(v.word, style: primaryTextStyle.copyWith(fontWeight: semiBold), maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (audio != null)
                SizedBox(
                  width: 32, height: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                    tooltip: 'Play',
                    onPressed: () => audio.playSound(v.audio ?? kQWAudioUrl),
                    icon: Icon(Icons.volume_up, color: color, size: 20),
                  ),
                ),
            ],
          ),
          Text(v.indo, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true),
          if (v.ipa != null) Text(v.ipa!, style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]), maxLines: 1, overflow: TextOverflow.ellipsis),
          if (v.note != null) Text(v.note!, style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]), maxLines: 2, overflow: TextOverflow.ellipsis),
          if (v.example != null) ...[
            const SizedBox(height: 4),
            Text(v.example!, style: primaryTextStyle.copyWith(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    ),
  );
}

/// Utils
List<QWVocab> byCat(String cat) => kQWVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
