import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

/// SoundLessonsTab
///
/// Pembelajaran terstruktur untuk:
/// 1) The sound of T
/// 2) The sound of S
/// 3) The sound of R
/// 4) ED-Ending (/t/ ~ /d/ ~ /ɪd/)
/// 5) The sound of "to" (weak/strong form & reductions)
///
/// Fitur:
/// - Pilih kategori via ChoiceChips
/// - (Opsional) pilih accent BE/AE untuk contoh yang relevan
/// - Kartu "Concept" berisi ringkasan aturan & tips
/// - Daftar pola + contoh kata + tombol play
/// - Minimal pairs/triples untuk latihan + tombol play
/// - Shuffle urutan
class SoundLessonsTab extends StatefulWidget {
  const SoundLessonsTab({
    super.key,
    required this.audioService,
    this.title = 'Sound Lessons',
  });

  final AudioService audioService;
  final String title;

  @override
  State<SoundLessonsTab> createState() => _SoundLessonsTabState();
}

enum _Lesson { t, s, r, edEnding, toWord }

extension _LessonX on _Lesson {
  String get label => switch (this) {
    _Lesson.t => 'Sound of T',
    _Lesson.s => 'Sound of S',
    _Lesson.r => 'Sound of R',
    _Lesson.edEnding => 'ED Ending',
    _Lesson.toWord => 'Sound of "to"',
  };

  Color get color => switch (this) {
    _Lesson.t => Colors.blue,
    _Lesson.s => Colors.green,
    _Lesson.r => Colors.red,
    _Lesson.edEnding => Colors.orange,
    _Lesson.toWord => Colors.purple,
  };
}

class _Rule {
  const _Rule({required this.title, required this.text});
  final String title;
  final String text; // markdown-ish plain text
}

class _PatternItem {
  const _PatternItem({
    required this.label, // nama pola: "T flap /ɾ/"
    required this.example, // contoh: "water → /ˈwɔːɾər/ (AE)"
    required this.audio,
  });
  final String label;
  final String example;
  final String audio;
}

class _PracticeItem {
  const _PracticeItem({
    required this.prompt, // kata/frase
    required this.ipa,
    required this.audio,
  });
  final String prompt;
  final String ipa;
  final String audio;
}

class _SoundLessonsTabState extends State<SoundLessonsTab> {
  static const _audio = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
  final _rand = Random();

  _Lesson _lesson = _Lesson.t;
  String _accent = 'Both'; // BE, AE, Both

  // ====== DATA ======
  late final Map<_Lesson, List<_Rule>> _rules = {
    _Lesson.t: [
      const _Rule(
        title: 'Allophones of T',
        text:
        'T dapat terdengar sebagai [t] (true T), [ɾ] (flap, umum di AE antara vokal bertekanan lemah), [ʔ] (glottal stop, umum di banyak aksen BE terutama sebelum konsonan), serta reduksi pada kluster (next → [neks]).',
      ),
      const _Rule(
        title: 'AE: Flap /ɾ/',
        text: 'Terjadi antara vokal ketika suku sebelumnya bertekanan: water, city, butter → /ˈwɔɾər, ˈsɪɾi, ˈbʌɾər/.',
      ),
      const _Rule(
        title: 'BE: Glottal /ʔ/',
        text: 'Sering muncul sebelum konsonan atau di tepi suku: football, butter → /ˈfʊʔbɔːl, ˈbʌʔə/. Bervariasi menurut dialek.',
      ),
    ],
    _Lesson.s: [
      const _Rule(
        title: 'Voiceless /s/ vs Voiced /z/',
        text:
        'Huruf S dapat berbunyi /s/ (voiceless) seperti **see**, atau /z/ (voiced) seperti **easy**. Plural -s juga mengikuti: cats /s/, dogs /z/.',
      ),
      const _Rule(
        title: 'Palato-alveolar /ʃ/ dari S',
        text: 'Dalam beberapa kata S berbunyi /ʃ/: sure /ʃʊə~ʃʊr/, sugar /ˈʃʊɡə~ˈʃʊɡər/.',
      ),
    ],
    _Lesson.r: [
      const _Rule(
        title: 'Rhotic vs Non-rhotic',
        text:
        'AE umumnya *rhotic* (R diucap di mana pun): car /kɑr/. Banyak BE *non-rhotic* (R diucap bila diikuti vokal): car /kɑː/.',
      ),
      const _Rule(
        title: 'Linking & Intrusive R',
        text:
        'BE: Linking R muncul saat kata berakhir huruf R namun diikuti vokal: **far away** → /fɑː ɹəˈweɪ/. Intrusive R: tambahan R pada akhir vokal tertentu: **law and order** → /lɔː ɹən ˈɔːdə/.',
      ),
    ],
    _Lesson.edEnding: [
      const _Rule(
        title: 'Tiga bunyi akhiran -ed',
        text:
        '1) /t/ setelah konsonan tak bersuara (p, k, f, s, ʃ, tʃ): **liked** /laɪkt/\n2) /d/ setelah vokal/konsonan bersuara: **loved** /lʌvd/\n3) /ɪd/ setelah /t/ atau /d/: **wanted** /ˈwɒntɪd/, **added** /ˈædɪd/.',
      ),
    ],
    _Lesson.toWord: [
      const _Rule(
        title: 'Weak vs Strong form',
        text:
        'Kata **to** biasanya bentuk lemah /tə/ dalam kalimat: *I want to go* → /aɪ ˈwɒnə ɡoʊ~ɡəʊ/. Bentuk kuat /tuː~tu/ dipakai saat ditekankan atau sebelum vokal pada beberapa aksen.',
      ),
      const _Rule(
        title: 'Reductions',
        text:
        'Frasa umum: **want to** → *wanna* /ˈwɒnə~ˈwɑːnə/, **going to** → *gonna* /ˈɡɒnə~ˈɡʌnə/. Perhatikan konteks formal vs informal.',
      ),
    ],
  };

  late List<_PatternItem> _tPatterns = [
    const _PatternItem(label: 'True T /t/', example: 'ten, until, attack', audio: _audio),
    const _PatternItem(label: 'Flap /ɾ/ (AE)', example: 'water, city, butter', audio: _audio),
    const _PatternItem(label: 'Glottal /ʔ/ (BE∼)', example: 'football, butter, got it', audio: _audio),
    const _PatternItem(label: 'Silent/weak in clusters', example: 'next → /neks/', audio: _audio),
  ];

  late List<_PracticeItem> _tPractice = [
    const _PracticeItem(prompt: 'water', ipa: 'AE /ˈwɔɾər/ | BE /ˈwɔːtə/', audio: _audio),
    const _PracticeItem(prompt: 'butter', ipa: 'AE /ˈbʌɾər/ | BE /ˈbʌtə~ˈbʌʔə/', audio: _audio),
    const _PracticeItem(prompt: 'city', ipa: 'AE /ˈsɪɾi/ | BE /ˈsɪti/', audio: _audio),
    const _PracticeItem(prompt: 'football', ipa: 'BE /ˈfʊʔbɔːl/ (varian)', audio: _audio),
  ];

  late List<_PatternItem> _sPatterns = [
    const _PatternItem(label: 'Voiceless /s/', example: 'see, cats, rice', audio: _audio),
    const _PatternItem(label: 'Voiced /z/', example: 'easy, dogs, music', audio: _audio),
    const _PatternItem(label: 'Palato-alveolar /ʃ/', example: 'sure, sugar', audio: _audio),
  ];

  late List<_PracticeItem> _sPractice = [
    const _PracticeItem(prompt: 'rice — rise', ipa: '/raɪs/ — /raɪz/', audio: _audio),
    const _PracticeItem(prompt: 'bus — buzz', ipa: '/bʌs/ — /bʌz/', audio: _audio),
    const _PracticeItem(prompt: 'pressure', ipa: '/ˈprɛʃər~ˈpreʃə/', audio: _audio),
  ];

  late List<_PatternItem> _rPatterns = [
    const _PatternItem(label: 'Rhotic R /ɹ/ (AE)', example: 'car /kɑr/, hard /hɑrd/', audio: _audio),
    const _PatternItem(label: 'Non-rhotic (BE)', example: 'car /kɑː/, hard /hɑːd/ (kecuali sebelum vokal)', audio: _audio),
    const _PatternItem(label: 'Linking R', example: 'far away → /fɑː ɹəˈweɪ/', audio: _audio),
    const _PatternItem(label: 'Intrusive R', example: 'law and order → /lɔː ɹən ˈɔːdə/', audio: _audio),
  ];

  late List<_PracticeItem> _rPractice = [
    const _PracticeItem(prompt: 'car — car engine', ipa: 'BE /kɑː/ — /kɑː ɹˈɛnʤɪn/', audio: _audio),
    const _PracticeItem(prompt: 'far away', ipa: '/fɑː ɹəˈweɪ/', audio: _audio),
    const _PracticeItem(prompt: 'four — four eggs', ipa: 'BE /fɔː/ — /fɔː ɹɛɡz/', audio: _audio),
  ];

  late List<_PatternItem> _edPatterns = [
    const _PatternItem(label: '/t/', example: 'liked /laɪkt/, watched /wɒtʃt/', audio: _audio),
    const _PatternItem(label: '/d/', example: 'loved /lʌvd/, played /pleɪd/', audio: _audio),
    const _PatternItem(label: '/ɪd/', example: 'wanted /ˈwɒntɪd/, needed /ˈniːdɪd/', audio: _audio),
  ];

  late List<_PracticeItem> _edPractice = [
    const _PracticeItem(prompt: 'work — worked', ipa: '/wɜːk — wɜːkt/', audio: _audio),
    const _PracticeItem(prompt: 'love — loved', ipa: '/lʌv — lʌvd/', audio: _audio),
    const _PracticeItem(prompt: 'add — added', ipa: '/æd — ˈædɪd/', audio: _audio),
  ];

  late List<_PatternItem> _toPatterns = [
    const _PatternItem(label: 'Weak form /tə/', example: 'I want to go → /aɪ ˈwɒnə ɡoʊ~ɡəʊ/', audio: _audio),
    const _PatternItem(label: 'Strong /tuː~tu/', example: 'I need **to** ask → /taɪˈniːd tuː ɑːsk~æsk/', audio: _audio),
    const _PatternItem(label: 'Reductions (gonna, wanna)', example: 'going to → gonna, want to → wanna', audio: _audio),
  ];

  late List<_PracticeItem> _toPractice = [
    const _PracticeItem(prompt: 'want to → wanna', ipa: '/ˈwɒnə~ˈwɑːnə/', audio: _audio),
    const _PracticeItem(prompt: 'to a', ipa: 'AE /t̬ə ə/ ~ /tə ə/; BE /tə ə/', audio: _audio),
    const _PracticeItem(prompt: 'to it', ipa: '/tuː ɪt/ (strong) ~ /tə ɪt/ (weak)', audio: _audio),
  ];

  void _shuffle() {
    setState(() {
      switch (_lesson) {
        case _Lesson.t:
          _tPatterns = [..._tPatterns]..shuffle(_rand);
          _tPractice = [..._tPractice]..shuffle(_rand);
          break;
        case _Lesson.s:
          _sPatterns = [..._sPatterns]..shuffle(_rand);
          _sPractice = [..._sPractice]..shuffle(_rand);
          break;
        case _Lesson.r:
          _rPatterns = [..._rPatterns]..shuffle(_rand);
          _rPractice = [..._rPractice]..shuffle(_rand);
          break;
        case _Lesson.edEnding:
          _edPatterns = [..._edPatterns]..shuffle(_rand);
          _edPractice = [..._edPractice]..shuffle(_rand);
          break;
        case _Lesson.toWord:
          _toPatterns = [..._toPatterns]..shuffle(_rand);
          _toPractice = [..._toPractice]..shuffle(_rand);
          break;
      }
    });
  }

  void _showConcept() {
    final list = _rules[_lesson] ?? const <_Rule>[];
    final text = list.map((r) => '• ${r.title}\n${r.text}').join('\n\n');

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Concept • ${_lesson.label}',
      desc: text,
      btnOkText: 'OK',
      btnOkOnPress: () {},
    ).show();
  }

  bool get _showAccentSelector => _lesson == _Lesson.t || _lesson == _Lesson.r || _lesson == _Lesson.toWord;

  @override
  Widget build(BuildContext context) {
    final color = _lesson.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: Column(
        children: [
          // Header & actions
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              if (_showAccentSelector)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kSecondaryColor.withValues(alpha: 0.25)),
                  ),
                  child: DropdownButton<String>(
                    value: _accent,
                    icon: const Icon(Icons.arrow_drop_down, size: 16),
                    elevation: 2,
                    style: primaryTextStyle.copyWith(fontSize: 12, fontWeight: semiBold),
                    underline: const SizedBox(),
                    onChanged: (v) => setState(() => _accent = v!),
                    items: const ['BE', 'AE', 'Both']
                        .map((s) => DropdownMenuItem<String>(value: s, child: Text(s)))
                        .toList(),
                  ),
                ),
              IconButton(onPressed: _showConcept, icon: Icon(Icons.lightbulb_outline, color: color)),
              IconButton(onPressed: _shuffle, icon: Icon(Icons.shuffle, color: color)),
            ],
          ),

          const SizedBox(height: 8),

          // Lesson selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final p in _Lesson.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(p.label),
                      selected: _lesson == p,
                      onSelected: (_) => setState(() => _lesson = p),
                      selectedColor: p.color.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Content
          Expanded(
            child: ListView(
              children: [
                _sectionTitle('Patterns', color),
                _buildPatternList(color),
                const SizedBox(height: 12),
                _sectionTitle('Practice', color),
                _buildPracticeList(color),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String s, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(s, style: primaryTextStyle.copyWith(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildPatternList(Color color) {
    final items = switch (_lesson) {
      _Lesson.t => _tPatterns,
      _Lesson.s => _sPatterns,
      _Lesson.r => _rPatterns,
      _Lesson.edEnding => _edPatterns,
      _Lesson.toWord => _toPatterns,
    };

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
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
          child: ListTile(
            title: Text(it.label, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
            subtitle: Text(it.example, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
            trailing: IconButton(
              tooltip: 'Play',
              onPressed: () => widget.audioService.playSound(it.audio),
              icon: Icon(Icons.volume_up, color: color),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPracticeList(Color color) {
    final items = switch (_lesson) {
      _Lesson.t => _tPractice,
      _Lesson.s => _sPractice,
      _Lesson.r => _rPractice,
      _Lesson.edEnding => _edPractice,
      _Lesson.toWord => _toPractice,
    };

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
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
          child: ListTile(
            title: Text(it.prompt, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
            subtitle: Text(it.ipa, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
            trailing: IconButton(
              tooltip: 'Play',
              onPressed: () => widget.audioService.playSound(it.audio),
              icon: Icon(Icons.volume_up, color: color),
            ),
          ),
        );
      },
    );
  }
}
