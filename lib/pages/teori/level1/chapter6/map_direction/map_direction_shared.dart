import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kMapDirAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }

class MapDirVocab {
  final String term;     // EN phrase/word: "turn left", "next to"
  final String indo;     // ID: "belok kiri", "di sebelah"
  final String category; // category id
  final String? ipa;     // optional IPA (BrE simple)
  final String? example; // example sentence
  final String? audio;   // optional audio

  const MapDirVocab({
    required this.term,
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
const C_VERB   = 'verb_direction';      // go straight, turn left, cross the street...
const C_PREP   = 'preposition_place';   // next to, between, across from...
const C_LAND   = 'landmarks';           // bank, hospital, bus stop...
const C_MAP    = 'map_words';           // street, avenue, block, traffic light...
const C_PHRASE = 'question_phrases';    // how do I get to..., where is...

final kMapDirCategories = const [C_VERB, C_PREP, C_LAND, C_MAP, C_PHRASE];

/// ===== Vocabulary =====
final List<MapDirVocab> kMapDirVocab = [
  // verbs for directions
  MapDirVocab(term:'go straight', indo:'jalan lurus', category:C_VERB, ipa:'/ɡəʊ ˈstreɪt/', example:'Go straight for two blocks.'),
  MapDirVocab(term:'turn left', indo:'belok kiri', category:C_VERB, ipa:'/tɜːn left/', example:'Turn left at the traffic light.'),
  MapDirVocab(term:'turn right', indo:'belok kanan', category:C_VERB, ipa:'/tɜːn raɪt/', example:'Turn right after the bank.'),
  MapDirVocab(term:'take the second left', indo:'ambil kiri kedua', category:C_VERB, example:'Take the second left onto Oak Street.'),
  MapDirVocab(term:'cross the street', indo:'menyeberang jalan', category:C_VERB, example:'Cross the street at the crosswalk.'),
  MapDirVocab(term:'follow the road', indo:'ikuti jalan', category:C_VERB),
  MapDirVocab(term:'make a U-turn', indo:'putar balik', category:C_VERB),

  // prepositions (place)
  MapDirVocab(term:'next to', indo:'di sebelah', category:C_PREP, example:'The café is next to the library.'),
  MapDirVocab(term:'between', indo:'di antara (2 objek)', category:C_PREP, example:'The park is between the school and the hospital.'),
  MapDirVocab(term:'across from', indo:'berseberangan dengan', category:C_PREP, example:'The bus stop is across from the bank.'),
  MapDirVocab(term:'in front of', indo:'di depan', category:C_PREP),
  MapDirVocab(term:'behind', indo:'di belakang', category:C_PREP),
  MapDirVocab(term:'on the corner of', indo:'di pojok (persimpangan)', category:C_PREP),

  // landmarks
  MapDirVocab(term:'bank', indo:'bank', category:C_LAND),
  MapDirVocab(term:'hospital', indo:'rumah sakit', category:C_LAND),
  MapDirVocab(term:'bus stop', indo:'halte bus', category:C_LAND),
  MapDirVocab(term:'train station', indo:'stasiun kereta', category:C_LAND),
  MapDirVocab(term:'subway station', indo:'stasiun kereta bawah tanah', category:C_LAND),
  MapDirVocab(term:'gas station', indo:'pom bensin', category:C_LAND),
  MapDirVocab(term:'police station', indo:'kantor polisi', category:C_LAND),
  MapDirVocab(term:'post office', indo:'kantor pos', category:C_LAND),
  MapDirVocab(term:'supermarket', indo:'supermarket', category:C_LAND),
  MapDirVocab(term:'park', indo:'taman', category:C_LAND),
  MapDirVocab(term:'library', indo:'perpustakaan', category:C_LAND),
  MapDirVocab(term:'school', indo:'sekolah', category:C_LAND),
  MapDirVocab(term:'mall', indo:'mal/pusat perbelanjaan', category:C_LAND),

  // map words / road features
  MapDirVocab(term:'street (St.)', indo:'jalan', category:C_MAP),
  MapDirVocab(term:'avenue (Ave.)', indo:'avenu/jalan besar', category:C_MAP),
  MapDirVocab(term:'block', indo:'blok (jarak antar persimpangan)', category:C_MAP),
  MapDirVocab(term:'intersection', indo:'perempatan/persimpangan', category:C_MAP),
  MapDirVocab(term:'roundabout', indo:'bundaran', category:C_MAP),
  MapDirVocab(term:'traffic light', indo:'lampu lalu lintas', category:C_MAP),
  MapDirVocab(term:'crosswalk', indo:'zebra cross', category:C_MAP),
  MapDirVocab(term:'bridge', indo:'jembatan', category:C_MAP),
  MapDirVocab(term:'river', indo:'sungai', category:C_MAP),

  // question/request phrases
  MapDirVocab(term:'How do I get to …?', indo:'Bagaimana saya menuju …?', category:C_PHRASE),
  MapDirVocab(term:'Where is the …?', indo:'Di mana …?', category:C_PHRASE),
  MapDirVocab(term:'Could you tell me the way to …?', indo:'Bisakah Anda beri tahu arah ke …?', category:C_PHRASE),
  MapDirVocab(term:'Is it far from here?', indo:'Apakah jauh dari sini?', category:C_PHRASE),
  MapDirVocab(term:'How long does it take?', indo:'Butuh waktu berapa lama?', category:C_PHRASE),
  MapDirVocab(term:'Which bus should I take?', indo:'Saya harus naik bus yang mana?', category:C_PHRASE),
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

Widget vocabTile(MapDirVocab v, {Color color = Colors.teal, AudioService? audio}) {
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
              Expanded(
                child: Text(v.term, style: primaryTextStyle.copyWith(fontWeight: semiBold), maxLines: null),
              ),
              if (audio != null)
                SizedBox(
                  width: 32, height: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                    tooltip: 'Play',
                    onPressed: () => audio.playSound(v.audio ?? kMapDirAudioUrl),
                    icon: Icon(Icons.volume_up, color: color, size: 20),
                  ),
                ),
            ],
          ),
          if (v.ipa != null) Text(v.ipa!, style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]), maxLines: 1, overflow: TextOverflow.ellipsis),
          SizedBox(height: 10,),
          Text(v.indo, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]), maxLines: null),
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
List<MapDirVocab> byCat(String cat) => kMapDirVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
