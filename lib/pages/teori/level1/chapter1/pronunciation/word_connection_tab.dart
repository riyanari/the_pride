import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

/// WordConnectionTab
/// Belajar penggabungan bunyi: CV, CC, VV, dan kombinasi (CVC/CCV/VCV...).
/// - Pilih kategori via ChoiceChips
/// - Setiap item menampilkan pasangan/urutan bunyi, contoh kata, dan tombol play
/// - Tombol shuffle untuk mengacak urutan
/// - Tombol info menampilkan tips kategori
class WordConnectionTab extends StatefulWidget {
  const WordConnectionTab({
    super.key,
    required this.audioService,
    this.title = 'Word Connections',
  });

  final AudioService audioService;
  final String title;

  @override
  State<WordConnectionTab> createState() => _WordConnectionTabState();
}

enum _Pattern { cv, cc, vv, combo }

extension _PatternX on _Pattern {
  String get label => switch (this) {
    _Pattern.cv => 'C + V',
    _Pattern.cc => 'C + C',
    _Pattern.vv => 'V + V',
    _Pattern.combo => 'Combination',
  };

  Color get color => switch (this) {
    _Pattern.cv => Colors.green,
    _Pattern.cc => Colors.blue,
    _Pattern.vv => Colors.orange,
    _Pattern.combo => Colors.purple,
  };
}

class _ConnItem {
  const _ConnItem({
    required this.left,
    required this.right,
    required this.blend,
    required this.example,
    required this.audio,
    this.ipa,
  });
  final String left; // fonem/grapheme kiri
  final String right; // fonem/grapheme kanan
  final String blend; // hasil gabungan (mis. "tr", "ba", "eɪ", dst.)
  final String example; // contoh kata
  final String audio; // url audio
  final String? ipa; // /transkripsi/ opsional
}

class _ComboItem {
  const _ComboItem({
    required this.parts, // urutan elemen ["st","ɒ","p"]
    required this.word,
    required this.audio,
    this.ipa,
  });
  final List<String> parts;
  final String word;
  final String audio;
  final String? ipa;
}

class _WordConnectionTabState extends State<WordConnectionTab> {
  static const _audio = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
  _Pattern _pattern = _Pattern.cv;
  final _rand = Random();

  // Tips per kategori
  final Map<_Pattern, String> _tips = const {
    _Pattern.cv:
    'C + V (Consonant + Vowel) membentuk suku kata dasar. Perhatikan perbedaan kualitas vokal (æ, ɪ, ə, ɑ, dsb.).',
    _Pattern.cc:
    'C + C (Consonant cluster) sering muncul di awal/akhir suku kata: st-, pr-, tr-, -sk, -nd. Jaga transisi bunyi tetap jelas.',
    _Pattern.vv:
    'V + V umumnya membentuk diftong (eɪ, aɪ, ɔɪ, aʊ, oʊ). Mulai dari vokal pertama lalu meluncur ke vokal kedua.',
    _Pattern.combo:
    'Combination adalah pola suku kata/katanya (CVC, CCV, VCV, dst.). Pecah kata menjadi bagian kecil, lalu rangkai perlahan.',
  };

  // ====== DATA ======
  late List<_ConnItem> _cvItems = [
    _ConnItem(left: 'b', right: 'æ', blend: 'bæ', example: 'bat /bæt/', audio: _audio, ipa: '/bæt/'),
    _ConnItem(left: 'k', right: 'æ', blend: 'kæ', example: 'cat /kæt/', audio: _audio, ipa: '/kæt/'),
    _ConnItem(left: 's', right: 'i', blend: 'si', example: 'see /siː/', audio: _audio, ipa: '/siː/'),
    _ConnItem(left: 'm', right: 'ə', blend: 'mə', example: 'machine /məˈʃiːn/', audio: _audio, ipa: '/məˈʃiːn/'),
    _ConnItem(left: 'h', right: 'ɑ', blend: 'hɑ', example: 'hot /hɑt~hɒt/', audio: _audio, ipa: '/hɑt ~ hɒt/'),
  ];

  late List<_ConnItem> _ccItems = [
    _ConnItem(left: 's', right: 't', blend: 'st', example: 'stop', audio: _audio),
    _ConnItem(left: 'p', right: 'r', blend: 'pr', example: 'price', audio: _audio),
    _ConnItem(left: 't', right: 'r', blend: 'tr', example: 'train', audio: _audio),
    _ConnItem(left: 's', right: 'k', blend: 'sk', example: 'sky', audio: _audio),
    _ConnItem(left: 'b', right: 'l', blend: 'bl', example: 'blue', audio: _audio),
  ];

  late List<_ConnItem> _vvItems = [
    _ConnItem(left: 'a', right: 'ɪ', blend: 'aɪ', example: 'my /maɪ/', audio: _audio, ipa: '/maɪ/'),
    _ConnItem(left: 'a', right: 'ʊ', blend: 'aʊ', example: 'now /naʊ/', audio: _audio, ipa: '/naʊ/'),
    _ConnItem(left: 'e', right: 'ɪ', blend: 'eɪ', example: 'say /seɪ/', audio: _audio, ipa: '/seɪ/'),
    _ConnItem(left: 'o', right: 'ʊ', blend: 'oʊ', example: 'go /ɡoʊ/', audio: _audio, ipa: '/ɡoʊ/'),
    _ConnItem(left: 'ɔ', right: 'ɪ', blend: 'ɔɪ', example: 'boy /bɔɪ/', audio: _audio, ipa: '/bɔɪ/'),
  ];

  late List<_ComboItem> _comboItems = [
    _ComboItem(parts: ['k', 'æ', 't'], word: 'cat', ipa: '/kæt/', audio: _audio), // CVC
    _ComboItem(parts: ['st', 'ɒ', 'p'], word: 'stop (BE)', ipa: '/stɒp/', audio: _audio), // CCVC
    _ComboItem(parts: ['st', 'ɑ', 'p'], word: 'stop (AE)', ipa: '/stɑp/', audio: _audio), // CCVC
    _ComboItem(parts: ['p', 'leɪ'], word: 'play', ipa: '/pleɪ/', audio: _audio), // CCV
    _ComboItem(parts: ['ə', 'baʊ', 't'], word: 'about', ipa: '/əˈbaʊt/', audio: _audio), // VCV C
  ];

  void _shuffle() {
    setState(() {
      switch (_pattern) {
        case _Pattern.cv:
          _cvItems = [..._cvItems]..shuffle(_rand);
          break;
        case _Pattern.cc:
          _ccItems = [..._ccItems]..shuffle(_rand);
          break;
        case _Pattern.vv:
          _vvItems = [..._vvItems]..shuffle(_rand);
          break;
        case _Pattern.combo:
          _comboItems = [..._comboItems]..shuffle(_rand);
          break;
      }
    });
  }

  void _showTips() {
    final tip = _tips[_pattern] ?? '';
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Tips • ${_pattern.label}',
      desc: tip,
      btnOkText: 'OK',
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final color = _pattern.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                tooltip: 'Tips',
                onPressed: _showTips,
                icon: Icon(Icons.info_outline, color: color),
              ),
              IconButton(
                tooltip: 'Shuffle',
                onPressed: _shuffle,
                icon: Icon(Icons.shuffle, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Pattern selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final p in _Pattern.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(p.label),
                      selected: _pattern == p,
                      onSelected: (_) => setState(() => _pattern = p),
                      selectedColor: p.color.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: Builder(
              builder: (context) {
                switch (_pattern) {
                  case _Pattern.cv:
                    return _buildConnList(_cvItems, color);
                  case _Pattern.cc:
                    return _buildConnList(_ccItems, color);
                  case _Pattern.vv:
                    return _buildConnList(_vvItems, color);
                  case _Pattern.combo:
                    return _buildComboList(color);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildConnList(List<_ConnItem> items, Color color) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final it = items[i];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // left + right → blend
                _piece(it.left, color),
                Icon(Icons.add, size: 18, color: color),
                _piece(it.right, color),
                Icon(Icons.arrow_right_alt, color: color),
                _piece(it.blend, color, bold: true),
                const SizedBox(width: 8),
                // example word
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(it.example, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                      if (it.ipa != null)
                        Text(it.ipa!, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Play',
                  onPressed: () => widget.audioService.playSound(it.audio),
                  icon: Icon(Icons.volume_up, color: color),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildComboList(Color color) {
    return ListView.separated(
      itemCount: _comboItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final it = _comboItems[i];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // parts chips
                Wrap(
                  spacing: 6,
                  runSpacing: -6,
                  children: [
                    for (final p in it.parts) _chip(p, color),
                  ],
                ),
                Icon(Icons.arrow_right_alt, color: color),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(it.word, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                      if (it.ipa != null)
                        Text(it.ipa!, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Play',
                  onPressed: () => widget.audioService.playSound(it.audio),
                  icon: Icon(Icons.volume_up, color: color),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _piece(String s, Color color, {bool bold = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        s,
        style: primaryTextStyle.copyWith(
          fontWeight: bold ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    );
  }

  Widget _chip(String s, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(s, style: primaryTextStyle.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}
