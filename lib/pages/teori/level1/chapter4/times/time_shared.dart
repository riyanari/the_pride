import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kTimeAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }

class TimeVocab {
  final String term;     // e.g. "quarter past"
  final String indo;     // "seperempat lewat"
  final String category; // "clock" | "preposition" | "time_of_day" | "frequency" | "duration"
  final String? ipa;     // IPA sederhana (BrE)
  final String? example; // contoh kalimat
  final String? audio;
  const TimeVocab({required this.term, required this.indo, required this.category, this.ipa, this.example, this.audio});
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
const C_CLOCK      = 'clock_phrases';
const C_PREP       = 'preposition_time';
const C_TOD        = 'time_of_day';
const C_FREQ       = 'frequency';
const C_DURATION   = 'duration';

final kTimeCategories = const [C_CLOCK, C_PREP, C_TOD, C_FREQ, C_DURATION];

/// ===== Vocabulary =====
final List<TimeVocab> kTimeVocab = [
  // clock phrases
  TimeVocab(term: "o'clock", indo: 'tepat (jam)', category: C_CLOCK, ipa: '/əˈklɒk/', example: "It's three o'clock."),
  TimeVocab(term: "quarter past", indo: 'seperempat lewat', category: C_CLOCK, ipa: '/ˈkwɔːtə pɑːst/', example: "It's a quarter past seven."),
  TimeVocab(term: "half past", indo: 'setengah lewat', category: C_CLOCK, ipa: '/hɑːf pɑːst/', example: "It's half past two."),
  TimeVocab(term: "quarter to", indo: 'seperempat menuju', category: C_CLOCK, ipa: '/ˈkwɔːtə tuː/', example: "It's a quarter to six."),
  TimeVocab(term: "AM", indo: 'pagi (00:00–11:59)', category: C_CLOCK, ipa: '/ˌeɪ ˈɛm/', example: "8 AM."),
  TimeVocab(term: "PM", indo: 'siang/malam (12:00–23:59)', category: C_CLOCK, ipa: '/ˌpiː ˈɛm/', example: "8 PM."),
  TimeVocab(term: "noon", indo: 'tengah hari (12:00)', category: C_CLOCK, ipa: '/nuːn/', example: "Let's meet at noon."),
  TimeVocab(term: "midnight", indo: 'tengah malam (00:00)', category: C_CLOCK, ipa: '/ˈmɪdnaɪt/', example: "He arrived at midnight."),
  TimeVocab(term: "ten past", indo: 'sepuluh lewat', category: C_CLOCK, ipa: '/ten pɑːst/', example: "It's ten past nine."),
  TimeVocab(term: "twenty to", indo: 'dua puluh menuju', category: C_CLOCK, ipa: '/ˈtwenti tuː/', example: "It's twenty to five."),

  // prepositions of time
  TimeVocab(term: "at", indo: 'pada (jam/point)', category: C_PREP, ipa: '/æt/', example: "at 7 o'clock, at noon, at night"),
  TimeVocab(term: "on", indo: 'pada (hari/tanggal)', category: C_PREP, ipa: '/ɒn/', example: "on Monday, on May 2nd"),
  TimeVocab(term: "in", indo: 'di/dalam (bulan, tahun, periode)', category: C_PREP, ipa: '/ɪn/', example: "in June, in 2025, in the morning"),

  // time of day
  TimeVocab(term: "morning", indo: 'pagi', category: C_TOD, ipa: '/ˈmɔːnɪŋ/', example: "in the morning"),
  TimeVocab(term: "afternoon", indo: 'siang/sore', category: C_TOD, ipa: '/ˌɑːftəˈnuːn/'),
  TimeVocab(term: "evening", indo: 'petang/malam awal', category: C_TOD, ipa: '/ˈiːvnɪŋ/'),
  TimeVocab(term: "night", indo: 'malam', category: C_TOD, ipa: '/naɪt/'),
  TimeVocab(term: "dawn", indo: 'fajar', category: C_TOD, ipa: '/dɔːn/'),
  TimeVocab(term: "dusk", indo: 'senja', category: C_TOD, ipa: '/dʌsk/'),

  // frequency
  TimeVocab(term: "always", indo: 'selalu', category: C_FREQ, ipa: '/ˈɔːlweɪz/'),
  TimeVocab(term: "usually", indo: 'biasanya', category: C_FREQ, ipa: '/ˈjuːʒuəli/'),
  TimeVocab(term: "often", indo: 'sering', category: C_FREQ, ipa: '/ˈɒfn/'),
  TimeVocab(term: "sometimes", indo: 'kadang-kadang', category: C_FREQ, ipa: '/ˈsʌmtaɪmz/'),
  TimeVocab(term: "rarely", indo: 'jarang', category: C_FREQ, ipa: '/ˈreəli/'),
  TimeVocab(term: "never", indo: 'tidak pernah', category: C_FREQ, ipa: '/ˈnevə/'),

  // duration
  TimeVocab(term: "minute", indo: 'menit', category: C_DURATION, ipa: '/ˈmɪnɪt/'),
  TimeVocab(term: "hour", indo: 'jam', category: C_DURATION, ipa: '/ˈaʊə/'),
  TimeVocab(term: "day", indo: 'hari', category: C_DURATION, ipa: '/deɪ/'),
  TimeVocab(term: "week", indo: 'minggu', category: C_DURATION, ipa: '/wiːk/'),
  TimeVocab(term: "month", indo: 'bulan', category: C_DURATION, ipa: '/mʌnθ/'),
  TimeVocab(term: "year", indo: 'tahun', category: C_DURATION, ipa: '/jɪə/'),
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

Widget vocabTile(TimeVocab v, {Color color = Colors.teal, AudioService? audio}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.25)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 2))],
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,          // ⬅️ biar tinggi mengikuti konten
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  v.term,
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                  maxLines: 1,                    // ⬅️ batasi judul
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (audio != null)
                SizedBox(
                  width: 32, height: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                    tooltip: 'Play',
                    onPressed: () => audio.playSound(v.audio ?? kTimeAudioUrl),
                    icon: Icon(Icons.volume_up, color: color, size: 20),
                  ),
                ),
            ],
          ),
          Text(
            v.indo,
            style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]),
            maxLines: 1,                          // ⬅️ arti Indonesia 1 baris
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          if (v.ipa != null)
            Text(
              v.ipa!,
              style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]),
              maxLines: 1,                        // ⬅️ IPA 1 baris
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          if (v.example != null) ...[
            const SizedBox(height: 4),
            Text(
              v.example!,
              style: primaryTextStyle.copyWith(fontSize: 12),
              maxLines: 2,                        // ⬅️ contoh dibatasi 2 baris
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ],
        ],
      ),
    ),
  );
}

/// ===== Utils =====
List<TimeVocab> byCat(String cat) => kTimeVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];

String hourName(int h) {
  final int hh = ((h - 1) % 12) + 1; // 1..12
  const names = ['', 'one','two','three','four','five','six','seven','eight','nine','ten','eleven','twelve'];
  return names[hh];
}

String timePhrase(int hour, int minute) {
  // Return natural 12-hour phrase: "a quarter past seven", "twenty to five", etc.
  final h = hour % 24;
  final next = (h + 1) % 24;
  final hn = hourName(h == 0 ? 12 : h);
  final nextHn = hourName(next == 0 ? 12 : next);
  if (minute == 0)   return "${hn} o'clock";
  if (minute == 15)  return "a quarter past $hn";
  if (minute == 30)  return "half past $hn";
  if (minute == 45)  return "a quarter to $nextHn";
  if (minute < 30)   return "$minute past $hn";
  final to = 60 - minute;
  return "$to to $nextHn";
}

Widget tipCard(Tip tip, Color color) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha:0.25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.06),
          blurRadius: 6,
          offset: const Offset(0, 2),
        )
      ],
    ),
    child: ListTile(
      leading: Icon(Icons.info_outline, color: color),
      title: Text(
        tip.title,
        style: primaryTextStyle.copyWith(fontWeight: semiBold),
      ),
      subtitle: Text(
        tip.text,
        style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]),
      ),
    ),
  );
}

String twoDigits(int n) => n.toString().padLeft(2, '0');
