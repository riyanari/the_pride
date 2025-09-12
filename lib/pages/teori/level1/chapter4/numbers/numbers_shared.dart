import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kNumbersAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }

class NumberVocab {
  final String numeral;   // "21"
  final String word;      // "twenty-one"
  final String indo;      // "dua puluh satu"
  final String category;  // "cardinal_basic" | "cardinal_tens" | "large" | "ordinal"
  final String? ipa;      // IPA (BrE) sederhana
  final String? example;  // kalimat contoh
  final String? audio;    // audio url optional
  const NumberVocab({
    required this.numeral,
    required this.word,
    required this.indo,
    required this.category,
    this.ipa,
    this.example,
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
const C_BASIC = 'cardinal_basic';
const C_TEENS = 'cardinal_teens';
const C_TENS  = 'cardinal_tens';
const C_LARGE = 'large_numbers';
const C_ORD   = 'ordinal';

final List<String> kNumberCategories = const [C_BASIC, C_TEENS, C_TENS, C_LARGE, C_ORD];

/// ===== Vocabulary =====
/// Catatan IPA sederhana (BrE) agar ringan. Kamu bisa lengkapi/ubah sesuai style app.
final List<NumberVocab> kNumberVocab = [
  // 0–10
  NumberVocab(numeral: '0', word: 'zero',    indo: 'nol', category: C_BASIC, ipa: '/ˈzɪərəʊ/', example: 'Room number zero.'),
  NumberVocab(numeral: '1', word: 'one',     indo: 'satu', category: C_BASIC, ipa: '/wʌn/', example: 'One apple.'),
  NumberVocab(numeral: '2', word: 'two',     indo: 'dua', category: C_BASIC, ipa: '/tuː/', example: 'Two books.'),
  NumberVocab(numeral: '3', word: 'three',   indo: 'tiga', category: C_BASIC, ipa: '/θriː/', example: 'Three pens.'),
  NumberVocab(numeral: '4', word: 'four',    indo: 'empat', category: C_BASIC, ipa: '/fɔː/', example: 'Four chairs.'),
  NumberVocab(numeral: '5', word: 'five',    indo: 'lima', category: C_BASIC, ipa: '/faɪv/', example: 'Five stars.'),
  NumberVocab(numeral: '6', word: 'six',     indo: 'enam', category: C_BASIC, ipa: '/sɪks/', example: 'Six people.'),
  NumberVocab(numeral: '7', word: 'seven',   indo: 'tujuh', category: C_BASIC, ipa: '/ˈsevən/', example: 'Seven days.'),
  NumberVocab(numeral: '8', word: 'eight',   indo: 'delapan', category: C_BASIC, ipa: '/eɪt/', example: 'Eight hours.'),
  NumberVocab(numeral: '9', word: 'nine',    indo: 'sembilan', category: C_BASIC, ipa: '/naɪn/', example: 'Nine lives.'),
  NumberVocab(numeral: '10', word: 'ten',    indo: 'sepuluh', category: C_BASIC, ipa: '/ten/', example: 'Ten students.'),

  // 11–19
  NumberVocab(numeral: '11', word: 'eleven', indo: 'sebelas', category: C_TEENS, ipa: '/ɪˈlevən/', example: 'Eleven players.'),
  NumberVocab(numeral: '12', word: 'twelve', indo: 'dua belas', category: C_TEENS, ipa: '/twelv/', example: 'Twelve months.'),
  NumberVocab(numeral: '13', word: 'thirteen', indo: 'tiga belas', category: C_TEENS, ipa: '/ˌθɜːˈtiːn/', example: 'Thirteen pages.'),
  NumberVocab(numeral: '14', word: 'fourteen', indo: 'empat belas', category: C_TEENS, ipa: '/ˌfɔːˈtiːn/'),
  NumberVocab(numeral: '15', word: 'fifteen', indo: 'lima belas', category: C_TEENS, ipa: '/ˌfɪfˈtiːn/'),
  NumberVocab(numeral: '16', word: 'sixteen', indo: 'enam belas', category: C_TEENS, ipa: '/ˌsɪksˈtiːn/'),
  NumberVocab(numeral: '17', word: 'seventeen', indo: 'tujuh belas', category: C_TEENS, ipa: '/ˌsevənˈtiːn/'),
  NumberVocab(numeral: '18', word: 'eighteen', indo: 'delapan belas', category: C_TEENS, ipa: '/ˌeɪˈtiːn/'),
  NumberVocab(numeral: '19', word: 'nineteen', indo: 'sembilan belas', category: C_TEENS, ipa: '/ˌnaɪnˈtiːn/'),

  // puluhan
  NumberVocab(numeral: '20', word: 'twenty', indo: 'dua puluh', category: C_TENS, ipa: '/ˈtwenti/'),
  NumberVocab(numeral: '30', word: 'thirty', indo: 'tiga puluh', category: C_TENS, ipa: '/ˈθɜːti/'),
  NumberVocab(numeral: '40', word: 'forty',  indo: 'empat puluh', category: C_TENS, ipa: '/ˈfɔːti/'),
  NumberVocab(numeral: '50', word: 'fifty',  indo: 'lima puluh', category: C_TENS, ipa: '/ˈfɪfti/'),
  NumberVocab(numeral: '60', word: 'sixty',  indo: 'enam puluh', category: C_TENS, ipa: '/ˈsɪksti/'),
  NumberVocab(numeral: '70', word: 'seventy', indo: 'tujuh puluh', category: C_TENS, ipa: '/ˈsevnti/'),
  NumberVocab(numeral: '80', word: 'eighty', indo: 'delapan puluh', category: C_TENS, ipa: '/ˈeɪti/'),
  NumberVocab(numeral: '90', word: 'ninety', indo: 'sembilan puluh', category: C_TENS, ipa: '/ˈnaɪnti/'),

  // contoh gabungan umum
  NumberVocab(numeral: '21', word: 'twenty-one', indo: 'dua puluh satu', category: C_TENS, ipa: '/ˌtwenti ˈwʌn/'),
  NumberVocab(numeral: '35', word: 'thirty-five', indo: 'tiga puluh lima', category: C_TENS, ipa: '/ˌθɜːti ˈfaɪv/'),
  NumberVocab(numeral: '48', word: 'forty-eight', indo: 'empat puluh delapan', category: C_TENS, ipa: '/ˌfɔːti ˈeɪt/'),
  NumberVocab(numeral: '99', word: 'ninety-nine', indo: 'sembilan puluh sembilan', category: C_TENS, ipa: '/ˌnaɪnti ˈnaɪn/'),

  // large numbers
  NumberVocab(numeral: '100', word: 'one hundred', indo: 'seratus', category: C_LARGE, ipa: '/wʌn ˈhʌndrəd/', example: 'One hundred students.'),
  NumberVocab(numeral: '1,000', word: 'one thousand', indo: 'seribu', category: C_LARGE, ipa: '/wʌn ˈθaʊzənd/'),
  NumberVocab(numeral: '10,000', word: 'ten thousand', indo: 'sepuluh ribu', category: C_LARGE, ipa: '/ten ˈθaʊzənd/'),
  NumberVocab(numeral: '100,000', word: 'one hundred thousand', indo: 'seratus ribu', category: C_LARGE, ipa: '/wʌn ˈhʌndrəd ˈθaʊzənd/'),
  NumberVocab(numeral: '1,000,000', word: 'one million', indo: 'satu juta', category: C_LARGE, ipa: '/wʌn ˈmɪljən/'),

  // ordinals
  NumberVocab(numeral: '1st', word: 'first',   indo: 'pertama', category: C_ORD, ipa: '/fɜːst/'),
  NumberVocab(numeral: '2nd', word: 'second',  indo: 'kedua', category: C_ORD, ipa: '/ˈsekənd/'),
  NumberVocab(numeral: '3rd', word: 'third',   indo: 'ketiga', category: C_ORD, ipa: '/θɜːd/'),
  NumberVocab(numeral: '4th', word: 'fourth',  indo: 'keempat', category: C_ORD, ipa: '/fɔːθ/'),
  NumberVocab(numeral: '5th', word: 'fifth',   indo: 'kelima', category: C_ORD, ipa: '/fɪfθ/'),
  NumberVocab(numeral: '6th', word: 'sixth',   indo: 'keenam', category: C_ORD, ipa: '/sɪksθ/'),
  NumberVocab(numeral: '7th', word: 'seventh', indo: 'ketujuh', category: C_ORD, ipa: '/ˈsevənθ/'),
  NumberVocab(numeral: '8th', word: 'eighth',  indo: 'kedelapan', category: C_ORD, ipa: '/eɪtθ/'),
  NumberVocab(numeral: '9th', word: 'ninth',   indo: 'kesembilan', category: C_ORD, ipa: '/naɪnθ/'),
  NumberVocab(numeral: '10th', word: 'tenth',  indo: 'kesepuluh', category: C_ORD, ipa: '/tenθ/'),
  NumberVocab(numeral: '11th', word: 'eleventh', indo: 'kesebelas', category: C_ORD, ipa: '/ɪˈlevənθ/'),
  NumberVocab(numeral: '12th', word: 'twelfth',  indo: 'kedua belas', category: C_ORD, ipa: '/twelfθ/'),
  NumberVocab(numeral: '20th', word: 'twentieth', indo: 'ke-20', category: C_ORD, ipa: '/ˈtwentiɪθ/'),
  NumberVocab(numeral: '21st', word: 'twenty-first', indo: 'ke-21', category: C_ORD, ipa: '/ˌtwenti ˈfɜːst/'),
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

Widget numberTile(NumberVocab v, {Color color = Colors.teal, AudioService? audio}) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.25)),
                ),
                child: Text(
                  v.numeral,
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                ),
              ),

              if (audio != null)
              // ciutkan IconButton supaya gak dorong ke kanan
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                    tooltip: 'Play',
                    onPressed: () => audio.playSound(v.audio ?? kNumbersAudioUrl),
                    icon: Icon(Icons.volume_up, color: color, size: 20),
                  ),
                ),
            ],
          ),
          // teks dibiarkan wrap di dalam Expanded
          Text(
            v.word,
            style: primaryTextStyle.copyWith(fontWeight: semiBold),
            softWrap: true,
            maxLines: 3,                    // boleh kamu naikkan jika perlu
            overflow: TextOverflow.visible, // jangan ellipsis biar kebaca
          ),
          if (v.ipa != null)
            Text(v.ipa!, style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]),
                maxLines: 4, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Text(v.indo, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]),
              maxLines: 4, overflow: TextOverflow.ellipsis),
          if (v.example != null) ...[
            const SizedBox(height: 4),
            Text(v.example!, style: primaryTextStyle.copyWith(fontSize: 12),
                maxLines: 3, overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    ),
  );
}

/// Utility
List<NumberVocab> byCat(String cat) => kNumberVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
String normalizeWords(String s) => s.toLowerCase().replaceAll(RegExp(r'[\s\-]'), '');
