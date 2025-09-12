import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kFamilyAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }

class FamilyVocab {
  final String term;       // EN
  final String indo;       // ID
  final String category;   // immediate/extended/marital/inlaw/step
  final String example;    // contoh EN
  final String? ipa;
  final String? audio;
  const FamilyVocab({
    required this.term,
    required this.indo,
    required this.category,
    required this.example,
    this.ipa,
    this.audio,
  });
}

class MCQItem {
  final String prompt;          // e.g. "brother" means...
  final List<String> options;   // options in Indonesian
  final int correct;
  final String explain;
  const MCQItem({required this.prompt, required this.options, required this.correct, required this.explain});
}

class Pair { final String left; final String right; final String explain; const Pair({required this.left, required this.right, required this.explain}); }
class Choice { final int id; final String text; final String key; const Choice({required this.id, required this.text, required this.key}); }

/// ===== Sample Vocabulary =====
const _I = 'immediate', _E = 'extended', _M = 'marital', _L = 'inlaw', _S = 'step';
final List<FamilyVocab> kFamilyVocab = [
  FamilyVocab(term: 'mother',           indo: 'ibu',                        category: _I, example: 'My mother is a teacher.',                 ipa: '/ˈmʌðə/'),
  FamilyVocab(term: 'father',           indo: 'ayah',                       category: _I, example: 'His father works in a bank.',            ipa: '/ˈfɑːðə/'),
  FamilyVocab(term: 'parents',          indo: 'orang tua',                  category: _I, example: 'I live with my parents.',                ipa: '/ˈpeərənts/'),
  FamilyVocab(term: 'son',              indo: 'anak laki-laki',             category: _I, example: 'Their son is five years old.',           ipa: '/sʌn/'),
  FamilyVocab(term: 'daughter',         indo: 'anak perempuan',             category: _I, example: 'Her daughter loves drawing.',            ipa: '/ˈdɔːtə/'),
  FamilyVocab(term: 'brother',          indo: 'saudara laki-laki',          category: _I, example: 'My brother plays guitar.',               ipa: '/ˈbrʌðə/'),
  FamilyVocab(term: 'sister',           indo: 'saudara perempuan',          category: _I, example: 'My sister is younger than me.',          ipa: '/ˈsɪstə/'),
  FamilyVocab(term: 'siblings',         indo: 'saudara kandung',            category: _I, example: 'How many siblings do you have?',         ipa: '/ˈsɪblɪŋz/'),

  FamilyVocab(term: 'grandmother',      indo: 'nenek',                      category: _E, example: 'My grandmother bakes cookies.',          ipa: '/ˈɡrænˌmʌðə/'),
  FamilyVocab(term: 'grandfather',      indo: 'kakek',                      category: _E, example: 'My grandfather tells stories.',          ipa: '/ˈɡrænˌfɑːðə/'),
  FamilyVocab(term: 'grandparents',     indo: 'kakek-nenek',                category: _E, example: 'We visit our grandparents every month.', ipa: '/ˈɡrænˌpeərənts/'),
  FamilyVocab(term: 'uncle',            indo: 'paman',                      category: _E, example: 'My uncle lives in Bali.',                ipa: '/ˈʌŋkəl/'),
  FamilyVocab(term: 'aunt',             indo: 'bibi/tante',                 category: _E, example: 'My aunt is very kind.',                  ipa: '/ɑːnt/'),
  FamilyVocab(term: 'cousin',           indo: 'sepupu',                     category: _E, example: 'I have many cousins.',                   ipa: '/ˈkʌzɪn/'),

  FamilyVocab(term: 'husband',          indo: 'suami',                      category: _M, example: 'Her husband is a chef.',                 ipa: '/ˈhʌzbənd/'),
  FamilyVocab(term: 'wife',             indo: 'istri',                      category: _M, example: 'His wife is a doctor.',                  ipa: '/waɪf/'),
  FamilyVocab(term: 'spouse',           indo: 'pasangan (suami/istri)',     category: _M, example: 'She came with her spouse.',              ipa: '/spaʊs/'),

  FamilyVocab(term: 'father-in-law',    indo: 'ayah mertua',                category: _L, example: 'My father-in-law is humorous.',          ipa: '/ˈfɑːðə ɪn lɔː/'),
  FamilyVocab(term: 'mother-in-law',    indo: 'ibu mertua',                 category: _L, example: 'Her mother-in-law is supportive.',       ipa: '/ˈmʌðə ɪn lɔː/'),
  FamilyVocab(term: 'son-in-law',       indo: 'menantu laki-laki',          category: _L, example: 'They like their son-in-law.',            ipa: '/ˈsʌn ɪn lɔː/'),
  FamilyVocab(term: 'daughter-in-law',  indo: 'menantu perempuan',          category: _L, example: 'She is my daughter-in-law.',             ipa: '/ˈdɔːtə ɪn lɔː/'),
  FamilyVocab(term: 'brother-in-law',   indo: 'ipar laki-laki',             category: _L, example: 'My brother-in-law is a pilot.',          ipa: '/ˈbrʌðə ɪn lɔː/'),
  FamilyVocab(term: 'sister-in-law',    indo: 'ipar perempuan',             category: _L, example: 'Her sister-in-law is friendly.',         ipa: '/ˈsɪstə ɪn lɔː/'),

  FamilyVocab(term: 'stepfather',       indo: 'ayah tiri',                  category: _S, example: 'He lives with his stepfather.',          ipa: '/ˈstɛpˌfɑːðə/'),
  FamilyVocab(term: 'stepmother',       indo: 'ibu tiri',                   category: _S, example: 'Her stepmother is caring.',              ipa: '/ˈstɛpˌmʌðə/'),
  FamilyVocab(term: 'stepbrother',      indo: 'saudara tiri laki-laki',     category: _S, example: 'I have a stepbrother.',                  ipa: '/ˈstɛpˌbrʌðə/'),
  FamilyVocab(term: 'stepsister',       indo: 'saudara tiri perempuan',     category: _S, example: 'She is my stepsister.',                  ipa: '/ˈstɛpˌsɪstə/'),
  FamilyVocab(term: 'half-brother',     indo: 'saudara se-ayah/ibu (laki-laki)', category: _S, example: 'He is my half-brother.',           ipa: '/ˌhɑːf ˈbrʌðə/'),
  FamilyVocab(term: 'half-sister',      indo: 'saudara se-ayah/ibu (perempuan)', category: _S, example: 'She is my half-sister.',           ipa: '/ˌhɑːf ˈsɪstə/'),
];


List<String> kFamilyCategories = const ['immediate', 'extended', 'marital', 'inlaw', 'step'];

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

Widget vocabTile(FamilyVocab v, {Color color = Colors.teal, AudioService? audio}) {
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
        mainAxisSize: MainAxisSize.min, // ⬅️ biar tinggi mengikuti konten
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  v.term,
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (audio != null)
                IconButton(
                  tooltip: 'Play',
                  onPressed: () => audio.playSound(v.audio ?? kFamilyAudioUrl),
                  icon: Icon(Icons.volume_up, color: color, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          if (v.ipa != null)
            Text(
              v.ipa!,
              style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          if (v.ipa != null)
            const SizedBox(height: 8),
          Text(
            v.indo,
            style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          const SizedBox(height: 4),
          Text(
            v.example,
            style: primaryTextStyle.copyWith(fontSize: 12),
            maxLines: 3,                // ⬅️ batasi 3 baris agar tidak meledak
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ],
      ),
    ),
  );
}


/// Utility
List<FamilyVocab> byCategory(String cat) => kFamilyVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
