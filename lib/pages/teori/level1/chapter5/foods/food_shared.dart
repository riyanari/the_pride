import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kFoodAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }

class FoodVocab {
  final String term;      // EN
  final String indo;      // ID
  final String category;  // staples/fruits/vegetables/protein/dairy/drinks/taste/cooking
  final String? ipa;      // IPA simple (BrE)
  final String? example;  // example sentence
  final String? audio;
  final String? image;    // optional asset/url for picture
  const FoodVocab({
    required this.term,
    required this.indo,
    required this.category,
    this.ipa,
    this.example,
    this.audio,
    this.image,
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
const C_STAPLES = 'staples';
const C_FRUITS  = 'fruits';
const C_VEGS    = 'vegetables';
const C_PROTEIN = 'protein';
const C_DAIRY   = 'dairy';
const C_DRINKS  = 'drinks';
const C_TASTE   = 'taste';
const C_COOK    = 'cooking';

final kFoodCategories = const [C_STAPLES, C_FRUITS, C_VEGS, C_PROTEIN, C_DAIRY, C_DRINKS, C_TASTE, C_COOK];

/// ===== Vocabulary (ringkas tapi padat) =====
final List<FoodVocab> kFoodVocab = [
  // staples
  FoodVocab(term:'rice',    indo:'nasi/beras', category:C_STAPLES, ipa:'/raɪs/', example:'We eat rice every day.'),
  FoodVocab(term:'bread',   indo:'roti',       category:C_STAPLES, ipa:'/brɛd/', example:'I like wholegrain bread.'),
  FoodVocab(term:'noodles', indo:'mi',         category:C_STAPLES, ipa:'/ˈnuːdəlz/'),

  // fruits
  FoodVocab(term:'apple',   indo:'apel',   category:C_FRUITS, ipa:'/ˈæpl/', example:'An apple a day is healthy.'),
  FoodVocab(term:'banana',  indo:'pisang', category:C_FRUITS, ipa:'/bəˈnɑːnə/'),
  FoodVocab(term:'orange',  indo:'jeruk',  category:C_FRUITS, ipa:'/ˈɒrɪndʒ/'),
  FoodVocab(term:'grapes',  indo:'anggur', category:C_FRUITS, ipa:'/ɡreɪps/'),

  // vegetables
  FoodVocab(term:'carrot',  indo:'wortel', category:C_VEGS, ipa:'/ˈkærət/'),
  FoodVocab(term:'spinach', indo:'bayam',  category:C_VEGS, ipa:'/ˈspɪnɪtʃ/'),
  FoodVocab(term:'cabbage', indo:'kubis',  category:C_VEGS, ipa:'/ˈkæbɪdʒ/'),
  FoodVocab(term:'tomato',  indo:'tomat',  category:C_VEGS, ipa:'/təˈmɑːtəʊ/'),

  // protein
  FoodVocab(term:'chicken', indo:'ayam',      category:C_PROTEIN, ipa:'/ˈtʃɪkɪn/'),
  FoodVocab(term:'beef',    indo:'daging sapi', category:C_PROTEIN, ipa:'/biːf/'),
  FoodVocab(term:'fish',    indo:'ikan',      category:C_PROTEIN, ipa:'/fɪʃ/'),
  FoodVocab(term:'egg',     indo:'telur',     category:C_PROTEIN, ipa:'/eɡ/'),

  // dairy
  FoodVocab(term:'milk',  indo:'susu',   category:C_DAIRY, ipa:'/mɪlk/'),
  FoodVocab(term:'cheese',indo:'keju',   category:C_DAIRY, ipa:'/tʃiːz/'),
  FoodVocab(term:'yogurt',indo:'yogurt', category:C_DAIRY, ipa:'/ˈjəʊɡət/'),

  // drinks
  FoodVocab(term:'water',     indo:'air',      category:C_DRINKS, ipa:'/ˈwɔːtə/'),
  FoodVocab(term:'tea',       indo:'teh',      category:C_DRINKS, ipa:'/tiː/'),
  FoodVocab(term:'coffee',    indo:'kopi',     category:C_DRINKS, ipa:'/ˈkɒfi/'),
  FoodVocab(term:'juice',     indo:'jus',      category:C_DRINKS, ipa:'/dʒuːs/'),
  FoodVocab(term:'soda',      indo:'soda',     category:C_DRINKS, ipa:'/ˈsəʊdə/'),

  // taste adjectives
  FoodVocab(term:'sweet',   indo:'manis',     category:C_TASTE, ipa:'/swiːt/'),
  FoodVocab(term:'salty',   indo:'asin',      category:C_TASTE, ipa:'/ˈsɔːlti/'),
  FoodVocab(term:'sour',    indo:'asam',      category:C_TASTE, ipa:'/ˈsaʊə/'),
  FoodVocab(term:'bitter',  indo:'pahit',     category:C_TASTE, ipa:'/ˈbɪtə/'),
  FoodVocab(term:'spicy',   indo:'pedas',     category:C_TASTE, ipa:'/ˈspaɪsi/'),
  FoodVocab(term:'savory',  indo:'gurih',     category:C_TASTE, ipa:'/ˈseɪvəri/'),

  // cooking verbs / methods (ringkas)
  FoodVocab(term:'boil',    indo:'merebus', category:C_COOK, ipa:'/bɔɪl/'),
  FoodVocab(term:'fry',     indo:'menggoreng', category:C_COOK, ipa:'/fraɪ/'),
  FoodVocab(term:'grill',   indo:'memanggang (panggang)', category:C_COOK, ipa:'/ɡrɪl/'),
  FoodVocab(term:'steam',   indo:'mengukus', category:C_COOK, ipa:'/stiːm/'),
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

Widget vocabTile(FoodVocab v, {Color color = Colors.teal, AudioService? audio}) => Container(
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
            Expanded(child: Text(v.term, style: primaryTextStyle.copyWith(fontWeight: semiBold), maxLines: 4, overflow: TextOverflow.ellipsis)),
            if (audio != null)
              SizedBox(
                width: 32, height: 32,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                  tooltip: 'Play',
                  onPressed: () => audio.playSound(v.audio ?? kFoodAudioUrl),
                  icon: Icon(Icons.volume_up, color: color, size: 20),
                ),
              ),
          ],
        ),
        if (v.ipa != null) Text(v.ipa!, style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]), maxLines: 4, overflow: TextOverflow.ellipsis),
        Text(v.indo, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]), maxLines: 4, overflow: TextOverflow.ellipsis),
        if (v.example != null) ...[
          const SizedBox(height: 4),
          Text(v.example!, style: primaryTextStyle.copyWith(fontSize: 12), maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ],
    ),
  ),
);

/// Utils
List<FoodVocab> byCat(String cat) => kFoodVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
