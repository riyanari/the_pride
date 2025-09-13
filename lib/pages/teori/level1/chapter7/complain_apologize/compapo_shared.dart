import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kCompApoAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

class Tip { final String title; final String text; const Tip(this.title, this.text); }

/// category: complaint | apology | softener | solution | followup
class CompApoVocab {
  final String phrase;
  final String indo;
  final String category;
  final String? ipa;
  final String? example;
  final String? audio;
  const CompApoVocab({
    required this.phrase, required this.indo, required this.category,
    this.ipa, this.example, this.audio,
  });
}

class MCQItem {
  final String prompt; final List<String> options; final int correct; final String explain;
  const MCQItem({required this.prompt, required this.options, required this.correct, required this.explain});
}
class Pair { final String left; final String right; final String explain; const Pair({required this.left, required this.right, required this.explain}); }
class Choice { final int id; final String text; final String key; const Choice({required this.id, required this.text, required this.key}); }

const C_COMPLAINT = 'complaint';
const C_APOLOGY   = 'apology';
const C_SOFTENER  = 'softener';
const C_SOLUTION  = 'solution';
const C_FOLLOWUP  = 'followup';

final kCompApoCategories = const [C_COMPLAINT, C_APOLOGY, C_SOFTENER, C_SOLUTION, C_FOLLOWUP];

final List<CompApoVocab> kCompApoVocab = [
  // Complaints
  CompApoVocab(phrase: "I'm afraid there's a problem with...", indo: 'Sepertinya ada masalah dengan...', category: C_COMPLAINT, ipa: "/aɪm əˈfreɪd ðeəz ə ˈprɒbləm wɪð/", example: "I'm afraid there's a problem with my order."),
  CompApoVocab(phrase: "Sorry to bother you, but...", indo: 'Maaf mengganggu, tapi...', category: C_COMPLAINT, ipa: "/ˈsɒri tə ˈbɒðə juː, bʌt/"),
  CompApoVocab(phrase: "This item arrived damaged.", indo: 'Barang ini sampai dalam kondisi rusak.', category: C_COMPLAINT),
  CompApoVocab(phrase: "The service is taking too long.", indo: 'Layanannya terlalu lama.', category: C_COMPLAINT),

  // Softeners (hedging, politeness)
  CompApoVocab(phrase: "Could you possibly...?", indo: 'Bisakah Anda...?', category: C_SOFTENER, ipa: "/kʊd juː ˈpɒsəbli/"),
  CompApoVocab(phrase: "Would it be possible to...?", indo: 'Apakah memungkinkan untuk...?', category: C_SOFTENER),
  CompApoVocab(phrase: "I wonder if you could...", indo: 'Saya bertanya-tanya apakah Anda bisa...', category: C_SOFTENER),

  // Apologies
  CompApoVocab(phrase: "I'm (really) sorry for the inconvenience.", indo: 'Saya (sangat) minta maaf atas ketidaknyamanannya.', category: C_APOLOGY, ipa: "/aɪm ˈrɪəli ˈsɒri fə ðiː ˌɪnkənˈviːniəns/"),
  CompApoVocab(phrase: "I apologize for...", indo: 'Saya mohon maaf atas...', category: C_APOLOGY, ipa: "/aɪ əˈpɒlədʒaɪz fɔː/"),
  CompApoVocab(phrase: "It was my fault.", indo: 'Itu kesalahan saya.', category: C_APOLOGY),
  CompApoVocab(phrase: "It won’t happen again.", indo: 'Ini tidak akan terjadi lagi.', category: C_APOLOGY),

  // Solutions / Offers
  CompApoVocab(phrase: "Let me fix that for you.", indo: 'Biar saya perbaiki untuk Anda.', category: C_SOLUTION),
  CompApoVocab(phrase: "Would a replacement work for you?", indo: 'Apakah penggantian cocok untuk Anda?', category: C_SOLUTION),
  CompApoVocab(phrase: "We can issue a refund.", indo: 'Kami bisa memberikan pengembalian dana.', category: C_SOLUTION),

  // Follow-ups
  CompApoVocab(phrase: "Is there anything else I can help you with?", indo: 'Apakah ada yang bisa saya bantu lagi?', category: C_FOLLOWUP),
  CompApoVocab(phrase: "Thanks for your patience.", indo: 'Terima kasih atas kesabarannya.', category: C_FOLLOWUP),
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

Widget vocabTile(CompApoVocab v, {Color color = Colors.teal, AudioService? audio}) {
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
              Expanded(child: Text(v.phrase, style: primaryTextStyle.copyWith(fontWeight: semiBold), maxLines: 2, overflow: TextOverflow.ellipsis)),
              if (audio != null)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Play',
                  onPressed: () => audio.playSound(v.audio ?? kCompApoAudioUrl),
                  icon: Icon(Icons.volume_up, color: color, size: 20),
                ),
            ],
          ),
          Text(v.indo, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]), maxLines: 2, overflow: TextOverflow.ellipsis),
          if (v.ipa != null) Text(v.ipa!, style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]), maxLines: 1, overflow: TextOverflow.ellipsis),
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
List<CompApoVocab> byCat(String cat) => kCompApoVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
