import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kHobbyAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }

class HobbyVocab {
  final String term;       // EN (gerund/noun)
  final String indo;       // ID
  final String category;   // category key
  final String example;    // contoh EN kalimat
  final String? ipa;       // IPA (BrE) optional
  final String? audio;     // audio url optional
  final String? imageAsset;// optional asset path
  const HobbyVocab({
    required this.term,
    required this.indo,
    required this.category,
    required this.example,
    this.ipa,
    this.audio,
    this.imageAsset,
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
const _SP = 'sports_outdoor', _AR = 'arts_crafts', _MU = 'music_performance', _RM = 'reading_media',
    _GA = 'games_puzzles', _FD = 'food_cooking', _TR = 'travel_culture', _WL = 'wellness_mindfulness',
    _CN = 'collection_nature', _TD = 'tech_diy';

final List<String> kHobbyCategories = const [
  _SP, _AR, _MU, _RM, _GA, _FD, _TR, _WL, _CN, _TD
];

/// ===== Vocabulary (isi imageAsset sesuai aset kamu) =====
final List<HobbyVocab> kHobbyVocab = [
  HobbyVocab(term: 'reading',        indo: 'membaca',             category: _RM, example: 'I enjoy reading novels.', ipa: '/ˈriːdɪŋ/', imageAsset: 'assets/images/hobbies/reading.png'),
  HobbyVocab(term: 'writing',        indo: 'menulis',             category: _RM, example: 'She loves creative writing.', ipa: '/ˈraɪtɪŋ/'),
  HobbyVocab(term: 'watching movies',indo: 'menonton film',       category: _RM, example: 'We like watching movies on weekends.', ipa: '/ˈwɒtʃɪŋ ˈmuːviz/'),
  HobbyVocab(term: 'photography',    indo: 'fotografi',           category: _AR, example: 'Photography helps me relax.', ipa: '/fəˈtɒɡrəfi/', imageAsset: 'assets/images/hobbies/photography.png'),
  HobbyVocab(term: 'painting',       indo: 'melukis',             category: _AR, example: 'He is into watercolor painting.', ipa: '/ˈpeɪntɪŋ/'),
  HobbyVocab(term: 'drawing',        indo: 'menggambar',          category: _AR, example: 'Drawing portraits is fun.', ipa: '/ˈdrɔːɪŋ/'),
  HobbyVocab(term: 'calligraphy',    indo: 'kaligrafi',           category: _AR, example: 'She practices calligraphy daily.', ipa: '/kəˈlɪɡrəfi/'),
  HobbyVocab(term: 'woodworking',    indo: 'pertukangan kayu',    category: _AR, example: 'Woodworking requires patience.', ipa: '/ˈwʊdˌwɜːkɪŋ/'),
  HobbyVocab(term: 'pottery',        indo: 'keramik/pembuat tembikar', category: _AR, example: 'Pottery classes are popular.', ipa: '/ˈpɒtəri/'),

  HobbyVocab(term: 'music',          indo: 'musik',               category: _MU, example: 'He studies music theory.', ipa: '/ˈmjuːzɪk/'),
  HobbyVocab(term: 'singing',        indo: 'bernyanyi',           category: _MU, example: 'Singing in a choir is enjoyable.', ipa: '/ˈsɪŋɪŋ/'),
  HobbyVocab(term: 'playing guitar', indo: 'bermain gitar',       category: _MU, example: 'I am learning to play the guitar.', ipa: '/ˈpleɪɪŋ ɡɪˈtɑː/'),
  HobbyVocab(term: 'dancing',        indo: 'menari',              category: _MU, example: 'She takes dancing lessons.', ipa: '/ˈdɑːnsɪŋ/'),

  HobbyVocab(term: 'cooking',        indo: 'memasak',             category: _FD, example: 'Cooking is my favourite hobby.', ipa: '/ˈkʊkɪŋ/', imageAsset: 'assets/images/hobbies/cooking.png'),
  HobbyVocab(term: 'baking',         indo: 'membuat kue',         category: _FD, example: 'He enjoys baking bread.', ipa: '/ˈbeɪkɪŋ/'),
  HobbyVocab(term: 'coffee brewing', indo: 'meracik kopi',        category: _FD, example: 'Coffee brewing is an art.', ipa: '/ˈkɒfi ˈbruːɪŋ/'),

  HobbyVocab(term: 'hiking',         indo: 'mendaki',             category: _SP, example: 'We go hiking in the hills.', ipa: '/ˈhaɪkɪŋ/', imageAsset: 'assets/images/hobbies/hiking.png'),
  HobbyVocab(term: 'cycling',        indo: 'bersepeda',           category: _SP, example: 'Cycling keeps me fit.', ipa: '/ˈsaɪklɪŋ/'),
  HobbyVocab(term: 'running',        indo: 'lari',                category: _SP, example: 'She is into long-distance running.', ipa: '/ˈrʌnɪŋ/'),
  HobbyVocab(term: 'swimming',       indo: 'berenang',            category: _SP, example: 'Swimming is great exercise.', ipa: '/ˈswɪmɪŋ/'),
  HobbyVocab(term: 'fishing',        indo: 'memancing',           category: _SP, example: 'They go fishing at the lake.', ipa: '/ˈfɪʃɪŋ/'),

  HobbyVocab(term: 'gaming',         indo: 'bermain gim',         category: _GA, example: 'He spends time gaming online.', ipa: '/ˈɡeɪmɪŋ/', imageAsset: 'assets/images/hobbies/gaming.png'),
  HobbyVocab(term: 'chess',          indo: 'catur',               category: _GA, example: 'Chess improves strategic thinking.', ipa: '/tʃes/'),
  HobbyVocab(term: 'puzzles',        indo: 'teka-teki',           category: _GA, example: 'She likes solving puzzles.', ipa: '/ˈpʌzlz/'),
  HobbyVocab(term: 'board games',    indo: 'papan permainan',     category: _GA, example: 'Board games are fun with friends.', ipa: '/bɔːd ɡeɪmz/'),

  HobbyVocab(term: 'yoga',           indo: 'yoga',                category: _WL, example: 'Yoga helps me relax.', ipa: '/ˈjəʊɡə/'),
  HobbyVocab(term: 'meditation',     indo: 'meditasi',            category: _WL, example: 'Meditation reduces stress.', ipa: '/ˌmedɪˈteɪʃn/'),
  HobbyVocab(term: 'gardening',      indo: 'berkebun',            category: _WL, example: 'Gardening is very therapeutic.', ipa: '/ˈɡɑːdənɪŋ/'),

  HobbyVocab(term: 'birdwatching',   indo: 'mengamati burung',    category: _CN, example: 'Birdwatching requires patience.', ipa: '/ˈbɜːdˌwɒtʃɪŋ/'),
  HobbyVocab(term: 'collecting stamps', indo: 'mengumpulkan prangko', category: _CN, example: 'He enjoys collecting stamps.', ipa: '/kəˈlektɪŋ stæmps/'),

  HobbyVocab(term: 'coding',         indo: 'ngoding/pemrograman', category: _TD, example: 'Coding small apps is fun.', ipa: '/ˈkəʊdɪŋ/'),
  HobbyVocab(term: 'DIY electronics',indo: 'elektronik DIY',      category: _TD, example: 'DIY electronics projects are exciting.', ipa: '/ˌdiː aɪ ˈwaɪ ɪˌlekˈtrɒnɪks/'),
  HobbyVocab(term: 'blogging',       indo: 'menulis blog',        category: _TD, example: 'She is blogging about travel.', ipa: '/ˈblɒɡɪŋ/'),

  HobbyVocab(term: 'traveling',      indo: 'bepergian',           category: _TR, example: 'Traveling broadens your mind.', ipa: '/ˈtrævəlɪŋ/', imageAsset: 'assets/images/hobbies/travel.png'),
  HobbyVocab(term: 'learning languages', indo: 'belajar bahasa',  category: _TR, example: 'He loves learning languages.', ipa: '/ˈlɜːnɪŋ ˈlæŋɡwɪdʒɪz/'),
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

Widget vocabTile(HobbyVocab v, {Color color = Colors.teal, AudioService? audio}) {
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
          if (v.imageAsset != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Image.asset(
                  v.imageAsset!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  ),
                ),
              ),
            ),
          if (v.imageAsset != null) const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(v.term, style: primaryTextStyle.copyWith(fontWeight: semiBold),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              if (audio != null)
                IconButton(
                  tooltip: 'Play',
                  onPressed: () => audio.playSound(v.audio ?? kHobbyAudioUrl),
                  icon: Icon(Icons.volume_up, color: color, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          Text(v.indo, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          if (v.ipa != null)
            Text(v.ipa!, style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(v.example, style: primaryTextStyle.copyWith(fontSize: 12), maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
  );
}

/// Utility
List<HobbyVocab> byCat(String cat) => kHobbyVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
