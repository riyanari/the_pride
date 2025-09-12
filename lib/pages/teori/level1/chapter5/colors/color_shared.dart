import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kColorAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }

class ColorVocab {
  final String term;      // EN
  final String indo;      // ID
  final String category;  // basic | extended | adjective | pattern
  final String? ipa;
  final String? example;
  final String? audio;
  final int? hex;         // warna swatch (0xFFRRGGBB)
  const ColorVocab({
    required this.term,
    required this.indo,
    required this.category,
    this.ipa,
    this.example,
    this.audio,
    this.hex,
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
const C_BASIC   = 'basic';
const C_EXT     = 'extended';
const C_ADJ     = 'adjectives';
const C_PATTERN = 'patterns';

final kColorCategories = const [C_BASIC, C_EXT, C_ADJ, C_PATTERN];

Color col(int hex) => Color(hex | 0xFF000000);

/// ===== Vocabulary =====
final List<ColorVocab> kColorVocab = [
  // Basic
  ColorVocab(term:'red',    indo:'merah',        category:C_BASIC, ipa:'/rɛd/',        example:'Red apple.',         hex:0xFFE53935),
  ColorVocab(term:'blue',   indo:'biru',         category:C_BASIC, ipa:'/bluː/',       example:'Blue sky.',          hex:0xFF1E88E5),
  ColorVocab(term:'yellow', indo:'kuning',       category:C_BASIC, ipa:'/ˈjɛləʊ/',     example:'Yellow bus.',        hex:0xFFFDD835),
  ColorVocab(term:'green',  indo:'hijau',        category:C_BASIC, ipa:'/ɡriːn/',      example:'Green leaf.',        hex:0xFF43A047),
  ColorVocab(term:'orange', indo:'oranye',       category:C_BASIC, ipa:'/ˈɒrɪndʒ/',    hex:0xFFFB8C00),
  ColorVocab(term:'purple', indo:'ungu',         category:C_BASIC, ipa:'/ˈpɜːpl/',     hex:0xFF8E24AA),
  ColorVocab(term:'pink',   indo:'merah muda',   category:C_BASIC, ipa:'/pɪŋk/',       hex:0xFFD81B60),
  ColorVocab(term:'brown',  indo:'cokelat',      category:C_BASIC, ipa:'/braʊn/',      hex:0xFF6D4C41),
  ColorVocab(term:'black',  indo:'hitam',        category:C_BASIC, ipa:'/blæk/',       hex:0xFF000000),
  ColorVocab(term:'white',  indo:'putih',        category:C_BASIC, ipa:'/waɪt/',       hex:0xFFFFFFFF),
  ColorVocab(term:'gray',   indo:'abu-abu',      category:C_BASIC, ipa:'/ɡreɪ/',       hex:0xFF9E9E9E),

  // Extended
  ColorVocab(term:'navy',     indo:'biru dongker', category:C_EXT, ipa:'/ˈneɪvi/',      hex:0xFF001F3F),
  ColorVocab(term:'turquoise',indo:'pirus',        category:C_EXT, ipa:'/ˈtɜːkwɔɪz/',   hex:0xFF1ABC9C),
  ColorVocab(term:'teal',     indo:'hijau kebiruan',category:C_EXT,ipa:'/tiːl/',        hex:0xFF00897B),
  ColorVocab(term:'beige',    indo:'krem',         category:C_EXT, ipa:'/beɪʒ/',        hex:0xFFF5F5DC),
  ColorVocab(term:'maroon',   indo:'marun',        category:C_EXT, ipa:'/məˈruːn/',     hex:0xFF800000),
  ColorVocab(term:'gold',     indo:'emas',         category:C_EXT, ipa:'/ɡəʊld/',       hex:0xFFFFD700),
  ColorVocab(term:'silver',   indo:'perak',        category:C_EXT, ipa:'/ˈsɪlvə/',      hex:0xFFC0C0C0),

  // Adjectives (deskripsi warna)
  ColorVocab(term:'light',  indo:'muda/terang', category:C_ADJ, ipa:'/laɪt/',   example:'Light blue.'),
  ColorVocab(term:'dark',   indo:'tua/gelap',   category:C_ADJ, ipa:'/dɑːk/',   example:'Dark green.'),
  ColorVocab(term:'bright', indo:'cerah',       category:C_ADJ, ipa:'/braɪt/',  example:'Bright yellow.'),
  ColorVocab(term:'pale',   indo:'pucat',       category:C_ADJ, ipa:'/peɪl/',   example:'Pale pink.'),

  // Patterns (pola)
  ColorVocab(term:'striped', indo:'bergaris', category:C_PATTERN, ipa:'/straɪpt/', example:'A striped shirt.'),
  ColorVocab(term:'dotted',  indo:'berbintik', category:C_PATTERN, ipa:'/ˈdɒtɪd/', example:'A dotted dress.'),
  ColorVocab(term:'plaid',   indo:'kotak-kotak', category:C_PATTERN, ipa:'/plæd/', example:'A plaid scarf.'),
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

Widget colorTile(ColorVocab v, {Color color = Colors.teal, AudioService? audio}) {
  final swatch = v.hex != null ? col(v.hex!) : Colors.white;
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha:0.25)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          // Swatch
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: swatch,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black.withValues(alpha:0.08)),
            ),
          ),
          const SizedBox(width: 10),
          // Texts
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(v.term, style: primaryTextStyle.copyWith(fontWeight: semiBold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    if (audio != null)
                      SizedBox(
                        width: 32, height: 32,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                          tooltip: 'Play',
                          onPressed: () => audio.playSound(v.audio ?? kColorAudioUrl),
                          icon: Icon(Icons.volume_up, color: color, size: 20),
                        ),
                      ),
                  ],
                ),
                if (v.ipa != null)
                  Text(v.ipa!, style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]), maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 8,),
                Text(v.indo, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]), maxLines: 1, overflow: TextOverflow.ellipsis),

                if (v.example != null)
                  Text(v.example!, style: primaryTextStyle.copyWith(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Utils
List<ColorVocab> byCat(String cat) => kColorVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
