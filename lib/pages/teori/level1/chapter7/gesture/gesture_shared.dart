import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kGestureAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }

class GestureVocab {
  final String term;        // thumbs-up, nod, etc.
  final String indo;        // arti Indonesia ringkas
  final String meaning;     // makna/ fungsi umumnya (EN/ID campur natural)
  final String category;    // positive/negative/neutral/greeting/cultural
  final String? example;    // contoh kalimat
  final String? note;       // catatan budaya
  final String emoji;       // ikon/emoji gestur (opsional)
  final String? audio;
  const GestureVocab({
    required this.term,
    required this.indo,
    required this.meaning,
    required this.category,
    required this.emoji,
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
const G_POS = 'positive';
const G_NEG = 'negative';
const G_NEU = 'neutral';
const G_GRE = 'greeting';
const G_CUL = 'cultural';

final kGestureCategories = const [G_POS, G_NEG, G_NEU, G_GRE, G_CUL];

/// ===== Vocabulary =====
final List<GestureVocab> kGestureVocab = [
  GestureVocab(term:'thumbs-up',  indo:'jempol', meaning:'setuju / bagus', category:G_POS, emoji:'👍', example:'He gave me a thumbs-up after my talk.'),
  GestureVocab(term:'nod',        indo:'mengangguk', meaning:'ya / setuju', category:G_POS, emoji:'🙂', example:'She nodded to show agreement.'),
  GestureVocab(term:'shake head', indo:'menggeleng', meaning:'tidak / menolak', category:G_NEG, emoji:'🙅', example:'He shook his head politely.'),
  GestureVocab(term:'wave',       indo:'melambaikan tangan', meaning:'salam/permisi', category:G_GRE, emoji:'👋', example:'They waved hello from across the street.'),
  GestureVocab(term:'handshake',  indo:'jabat tangan', meaning:'salam formal', category:G_GRE, emoji:'🤝', example:'We started the meeting with a handshake.'),
  GestureVocab(term:'shrug',      indo:'mengangkat bahu', meaning:'tidak tahu / tidak yakin', category:G_NEU, emoji:'🤷', example:'He shrugged when asked the question.'),
  GestureVocab(term:'eye contact',indo:'kontak mata', meaning:'perhatian / percaya diri', category:G_NEU, emoji:'👀', note:'Tingkat intensitas kontak mata bervariasi per budaya.'),
  GestureVocab(term:'bow',        indo:'membungkuk', meaning:'hormat (Jepang dsb.)', category:G_CUL, emoji:'🙇', note:'Dalam budaya Jepang, kedalaman/sudut membungkuk punya makna.'),
  GestureVocab(term:'high-five',  indo:'tos', meaning:'merayakan / sepakat', category:G_POS, emoji:'🙌'),
  GestureVocab(term:'fist bump',  indo:'salam tinju', meaning:'salam santai/akrab', category:G_GRE, emoji:'👊'),
  GestureVocab(term:'beckon',     indo:'melambai memanggil', meaning:'memanggil datang', category:G_NEU, emoji:'🫵', note:'Di beberapa budaya, memanggil dengan telapak menghadap atas dianggap kurang sopan.'),
  GestureVocab(term:'point',      indo:'menunjuk', meaning:'menunjukkan arah/objek', category:G_NEU, emoji:'☝️', note:'Menunjuk dengan telunjuk bisa dianggap tidak sopan; gunakan ibu jari/seluruh tangan.'),
  GestureVocab(term:'peace sign', indo:'isyarat V', meaning:'damai / salam', category:G_POS, emoji:'✌️', note:'Arah telapak tangan penting di UK/Australia.'),
  GestureVocab(term:'OK sign',    indo:'isyarat OK (jari O)', meaning:'OK / setuju', category:G_POS, emoji:'👌', note:'Bisa ofensif di beberapa negara; gunakan dengan hati-hati.'),
  GestureVocab(term:'crossed arms',indo:'menyilangkan tangan', meaning:'defensif / dingin', category:G_NEG, emoji:'🧍', example:'He stood with crossed arms during the debate.'),
  GestureVocab(term:'clap',       indo:'tepuk tangan', meaning:'apresiasi', category:G_POS, emoji:'👏'),
  GestureVocab(term:'facepalm',   indo:'tutup wajah', meaning:'frustrasi / malu', category:G_NEG, emoji:'🤦'),
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

Widget tipCard(Tip tip, Color color) => Container(
  margin: const EdgeInsets.only(bottom: 10),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: color.withValues(alpha:0.25)),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
  ),
  child: ListTile(
    leading: Icon(Icons.info_outline, color: color),
    title: Text(tip.title, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
    subtitle: Text(tip.text, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800])),
  ),
);

Widget gestureTile(GestureVocab v, {Color color = Colors.teal, AudioService? audio}) {
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
              Text(v.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              if (audio != null)
                SizedBox(
                  width: 32, height: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                    tooltip: 'Play',
                    onPressed: () => audio.playSound(v.audio ?? kGestureAudioUrl),
                    icon: Icon(Icons.volume_up, color: color, size: 20),
                  ),
                ),
            ],
          ),
          Text(v.term, style: primaryTextStyle.copyWith(fontWeight: semiBold),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text('${v.indo} • ${v.meaning}', style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]),
              maxLines: 3, overflow: TextOverflow.ellipsis, softWrap: true),
          if (v.example != null) ...[
            const SizedBox(height: 4),
            Text(v.example!, style: primaryTextStyle.copyWith(fontSize: 12),
                maxLines: null),
          ],
          if (v.note != null) ...[
            const SizedBox(height: 4),
            Text('Note: ${v.note!}', style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]),
                maxLines: null),
          ],
        ],
      ),
    ),
  );
}

/// Utils
List<GestureVocab> byCat(String cat) => kGestureVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
