import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';

/// PunctuationPage
/// Versi **HALAMAN** (bukan tab) untuk pembelajaran tanda baca.
/// Memuat: kategori tanda baca, ringkasan aturan & contoh (BE/AE),
/// serta quick quiz dengan skor dan feedback.
class Punctuation1Tab extends StatefulWidget {
  const Punctuation1Tab({super.key});

  @override
  State<Punctuation1Tab> createState() => _Punctuation1TabState();
}

enum _Style { BE, AE, Both }

enum _Cat {
  period,
  comma,
  question,
  exclamation,
  colon,
  semicolon,
  apostrophe,
  quotes,
  hyphenDash,
  parentheses,
  ellipsis,
  slash,
}

extension _CatX on _Cat {
  String get label => switch (this) {
    _Cat.period => 'Period (.)',
    _Cat.comma => 'Comma (,)',
    _Cat.question => 'Question (?)',
    _Cat.exclamation => 'Exclamation (!)',
    _Cat.colon => 'Colon (:)',
    _Cat.semicolon => 'Semicolon (;)',
    _Cat.apostrophe => 'Apostrophe (\' )',
    _Cat.quotes => 'Quotation Marks',
    _Cat.hyphenDash => 'Hyphen & Dashes',
    _Cat.parentheses => 'Parentheses/Brackets',
    _Cat.ellipsis => 'Ellipsis (…)',
    _Cat.slash => 'Slash (/)',
  };

  IconData get icon => switch (this) {
    _Cat.period => Icons.circle,
    _Cat.comma => Icons.short_text,
    _Cat.question => Icons.help_outline,
    _Cat.exclamation => Icons.priority_high,
    _Cat.colon => Icons.more_horiz,
    _Cat.semicolon => Icons.more_horiz,
    _Cat.apostrophe => Icons.edit_note,
    _Cat.quotes => Icons.format_quote,
    _Cat.hyphenDash => Icons.horizontal_rule,
    _Cat.parentheses => Icons.data_array,
    _Cat.ellipsis => Icons.more_horiz,
    _Cat.slash => Icons.call_split,
  };

  Color get color => switch (this) {
    _Cat.period => Colors.blue,
    _Cat.comma => Colors.green,
    _Cat.question => Colors.purple,
    _Cat.exclamation => Colors.red,
    _Cat.colon => Colors.orange,
    _Cat.semicolon => Colors.teal,
    _Cat.apostrophe => Colors.indigo,
    _Cat.quotes => Colors.brown,
    _Cat.hyphenDash => Colors.deepOrange,
    _Cat.parentheses => Colors.cyan,
    _Cat.ellipsis => Colors.pink,
    _Cat.slash => Colors.amber,
  };
}

class _Rule {
  const _Rule({required this.title, required this.text, this.examples = const []});
  final String title;
  final String text;
  final List<String> examples;
}

class _MCQ {
  const _MCQ({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
}

class _Punctuation1TabState extends State<Punctuation1Tab> {
  final _rand = Random();
  _Style _style = _Style.Both;
  _Cat _cat = _Cat.period;

  // ===== Rules data =====
  late final Map<_Cat, List<_Rule>> _rules = {
    _Cat.period: [
      const _Rule(
        title: 'Akhiri kalimat pernyataan',
        text: 'Gunakan titik untuk menutup kalimat pernyataan lengkap (declarative).',
        examples: ['She is reading a book.', 'They moved to London.'],
      ),
      const _Rule(
        title: 'Singkatan',
        text: 'AE lebih sering memakai titik pada singkatan (Mr., Dr., U.S.). BE kadang menghilangkan titik (Mr, Dr, US).',
        examples: ['Mr. Smith (AE) / Mr Smith (BE)'],
      ),
    ],
    _Cat.comma: [
      const _Rule(
        title: 'Pisahkan elemen dalam daftar',
        text: 'Gunakan koma untuk memisahkan tiga atau lebih item. Oxford comma opsional (lebih umum di AE).',
        examples: ['We bought apples, oranges, and bananas. (Oxford comma)'],
      ),
      const _Rule(
        title: 'Klausa pengantar & non-restrictive',
        text: 'Tambahkan koma setelah frasa pengantar dan di sekitar klausa non-restrictive.',
        examples: ['After dinner, we went for a walk.', 'My brother, who lives in Sydney, is visiting.'],
      ),
    ],
    _Cat.question: [
      const _Rule(
        title: 'Kalimat tanya langsung',
        text: 'Akhiri pertanyaan langsung dengan tanda tanya. Pertanyaan tidak langsung tidak memakai tanda tanya.',
        examples: ['Where are you going?', 'He asked where I was going.'],
      ),
    ],
    _Cat.exclamation: [
      const _Rule(
        title: 'Ekspresif & seruan',
        text: 'Gunakan tanda seru untuk emosi kuat atau seruan langsung. Hindari overuse di tulisan formal.',
        examples: ['Watch out!', 'That\'s amazing!'],
      ),
    ],
    _Cat.colon: [
      const _Rule(
        title: 'Perkenalkan daftar/penjelasan',
        text: 'Gunakan titik dua untuk memperkenalkan daftar, penjelasan, atau kutipan.',
        examples: ['She brought three things: a pen, a notebook, and a ruler.'],
      ),
    ],
    _Cat.semicolon: [
      const _Rule(
        title: 'Hubungkan dua klausa independen terkait',
        text: 'Pakai titik koma untuk menghubungkan klausa yang dekat maknanya tanpa konjungsi.',
        examples: ['It was late; we decided to leave.'],
      ),
      const _Rule(
        title: 'Daftar kompleks',
        text: 'Gunakan titik koma untuk memisahkan item daftar yang sudah mengandung koma.',
        examples: ['Guests included John, the host; Maria, the chef; and Lee, the DJ.'],
      ),
    ],
    _Cat.apostrophe: [
      const _Rule(
        title: 'Possession',
        text: 'Tambahkan apostrof + s untuk kepemilikan: singular (the teacher\'s book), plural regular (the teachers\' room).',
        examples: ['James\'s car / James\' car (dua gaya; konsisten).'],
      ),
      const _Rule(
        title: 'Contractions',
        text: 'Apostrof menandai penghilangan huruf: don\'t, I\'m, it\'s (ingat it\'s ≠ its).',
        examples: ["It\'s raining, but the cat lost its collar."],
      ),
    ],
    _Cat.quotes: [
      const _Rule(
        title: 'BE vs AE quotes',
        text: 'AE biasanya memakai double quotes untuk kutipan utama ("…") dan memosisikan koma/titik di dalam quotes. BE sering memakai single quotes (\'…\') dan menerapkan logical punctuation (tanda baca di luar bila bukan bagian kutipan).',
        examples: ['AE: He said, "I\'m ready."', "BE: He said, 'I\'m ready'."],
      ),
      const _Rule(
        title: 'Quotes dalam quotes',
        text: 'Ganti jenis kutip untuk tingkat kedua: AE "…\'…\'…"; BE \"…\'…\'…\" atau kebalikannya tergantung gaya.',
        examples: ['AE: "She called it \"a miracle\"."', "BE: 'She called it \"a miracle\"'."],
      ),
    ],
    _Cat.hyphenDash: [
      const _Rule(
        title: 'Hyphen (-) vs En dash (–) vs Em dash (—)',
        text: 'Hyphen menyambung kata (well-known). En dash untuk rentang (2019–2023). Em dash untuk jeda/penekanan—seperti ini.',
        examples: ['a twenty-year-old student', 'pages 10–15', 'She hesitated—then answered.'],
      ),
    ],
    _Cat.parentheses: [
      const _Rule(
        title: 'Parentheses ( ) & Brackets [ ]',
        text: 'Parentheses menambahkan info sampingan; brackets untuk sisipan/editorial/penjelasan dalam kutipan.',
        examples: ['He finally answered (after five minutes).', '"They [the committee] agreed to postpone."'],
      ),
    ],
    _Cat.ellipsis: [
      const _Rule(
        title: 'Menunjukkan penghilangan/jeda',
        text: 'Ellipsis (…) menandai teks yang dipotong atau jeda ragu. Jangan gabungkan terlalu banyak dengan tanda baca lain.',
        examples: ['Well… I\'m not sure.', 'The report states: "Results show… significant growth."'],
      ),
    ],
    _Cat.slash: [
      const _Rule(
        title: 'Pilihan atau hubungan',
        text: 'Slash untuk menandai pilihan (and/or) atau relasi (input/output). Di tulisan formal, gunakan kata penuh bila bisa.',
        examples: ['and/or, input/output, 24/7'],
      ),
    ],
  };

  // ===== Kuis data =====
  late List<_MCQ> _quiz = [
    const _MCQ(
      question: 'Pilih kalimat dengan koma yang benar (Oxford comma style):',
      options: [
        'We invited the dancers, the singers and the host.',
        'We invited the dancers, the singers, and the host.',
        'We invited the dancers the singers, and the host.',
      ],
      correctIndex: 1,
      explanation: 'Oxford comma sebelum item terakhir membuat daftar lebih jelas; gaya lain juga boleh asal konsisten.',
    ),
    const _MCQ(
      question: 'Penempatan titik dengan quotes (AE style):',
      options: [
        'He said, "I\'m ready".',
        'He said, "I\'m ready."',
        'He said, "I\'m ready" .',
      ],
      correctIndex: 1,
      explanation: 'AE menempatkan koma/titik di dalam tanda kutip.',
    ),
    const _MCQ(
      question: 'Pilih penggunaan titik koma yang benar:',
      options: [
        'It was getting late; we went home.',
        'It was getting late we went home;',
        'It was getting late, we went home.',
      ],
      correctIndex: 0,
      explanation: 'Titik koma menghubungkan dua klausa independen yang terkait.',
    ),
    const _MCQ(
      question: 'Apostrof kepemilikan yang benar:',
      options: [
        'the teachers room',
        "the teacher's room",
        "the teachers's room",
      ],
      correctIndex: 1,
      explanation: 'Singular noun → apostrof + s.',
    ),
    const _MCQ(
      question: 'Hyphen vs dash:',
      options: [
        'She is a well known writer.',
        'She is a well-known writer.',
        'She is a well—known writer.',
      ],
      correctIndex: 1,
      explanation: 'Compound adjective sebelum noun → hyphen: well-known writer.',
    ),
    const _MCQ(
      question: 'Parentheses yang tepat:',
      options: [
        'He answered (after five minutes).',
        'He answered) after five minutes(',
        'He answered after five minutes).(',
      ],
      correctIndex: 0,
      explanation: 'Tanda kurung harus berpasangan dan berada pada posisi yang logis.',
    ),
  ];

  final Map<int, int> _selected = {}; // nomor soal -> index opsi

  void _shuffleQuiz() {
    setState(() {
      _quiz = [..._quiz]..shuffle(_rand);
    });
  }

  void _submitQuiz() {
    int correct = 0;
    for (var i = 0; i < _quiz.length; i++) {
      final chosen = _selected[i];
      if (chosen != null && chosen == _quiz[i].correctIndex) correct++;
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Hasil Kuis',
      desc: 'Skor kamu: $correct / ${_quiz.length}',
      btnOkText: 'OK',
      btnOkOnPress: () {},
    ).show();
  }

  void _showConceptDialog(_Cat cat) {
    final color = cat.color;
    final rules = _rules[cat] ?? const <_Rule>[];
    final text = rules
        .map((r) => '• ${r.title}\n${r.text}${r.examples.isEmpty ? '' : '\nContoh: ' + r.examples.join(' | ')}')
        .join('\n\n');

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Concept • ${cat.label}',
      desc: text,
      btnOkText: 'OK',
      btnOkOnPress: () {},
      btnOkColor: color,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final color = _cat.color;

    return Scaffold(
      // appBar: CustomAppBar('Punctuation', iconSize: 16.0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
        child: Column(
          children: [
            // Header bar dalam page
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Learn Punctuation',
                    style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kSecondaryColor.withValues(alpha: 0.25)),
                  ),
                  child: DropdownButton<_Style>(
                    value: _style,
                    icon: const Icon(Icons.arrow_drop_down, size: 16),
                    elevation: 2,
                    style: primaryTextStyle.copyWith(fontSize: 12, fontWeight: semiBold),
                    underline: const SizedBox(),
                    onChanged: (v) => setState(() => _style = v!),
                    items: const [
                      DropdownMenuItem(value: _Style.BE, child: Text('BE')),
                      DropdownMenuItem(value: _Style.AE, child: Text('AE')),
                      DropdownMenuItem(value: _Style.Both, child: Text('Both')),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Concept',
                  onPressed: () => _showConceptDialog(_cat),
                  icon: Icon(Icons.lightbulb_outline, color: color),
                ),
                IconButton(
                  tooltip: 'Shuffle quiz',
                  onPressed: _shuffleQuiz,
                  icon: Icon(Icons.shuffle, color: color),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Category chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final c in _Cat.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        avatar: Icon(c.icon, size: 16, color: c.color),
                        label: Text(c.label),
                        selected: _cat == c,
                        onSelected: (_) => setState(() => _cat = c),
                        selectedColor: c.color.withValues(alpha: 0.2),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Content (Rules + Examples + Quiz)
            Expanded(
              child: ListView(
                children: [
                  _sectionTitle('Rules & Examples', color),
                  const SizedBox(height: 8),
                  _buildRulesCard(_cat, color),
                  const SizedBox(height: 16),
                  _sectionTitle('Quick Quiz', color),
                  const SizedBox(height: 8),
                  _buildQuizCard(color),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildRulesCard(_Cat cat, Color color) {
    final rules = _rules[cat] ?? const <_Rule>[];

    final extraStyleNotes = <String>[];
    if (cat == _Cat.quotes) {
      switch (_style) {
        case _Style.AE:
          extraStyleNotes.add('AE: Gunakan double quotes untuk kutipan utama; koma/titik biasanya di **dalam** quotes.');
          break;
        case _Style.BE:
          extraStyleNotes.add('BE: Single quotes sering dipakai; logical punctuation (tanda baca di **luar** jika bukan bagian dari kutipan).');
          break;
        case _Style.Both:
          extraStyleNotes.add('AE: "I\'m ready." | BE: \"I\'m ready\". Pilih gaya dan konsisten.');
          break;
      }
    } else if (cat == _Cat.comma) {
      switch (_style) {
        case _Style.AE:
          extraStyleNotes.add('AE: Oxford comma lebih umum dianjurkan dalam tulisan formal.');
          break;
        case _Style.BE:
          extraStyleNotes.add('BE: Oxford comma opsional dan sering dihindari kecuali untuk menghindari ambiguitas.');
          break;
        case _Style.Both:
          extraStyleNotes.add('Oxford comma: gunakan untuk kejelasan, apapun gaya yang dipilih.');
          break;
      }
    } else if (cat == _Cat.period) {
      switch (_style) {
        case _Style.AE:
          extraStyleNotes.add('AE: Titik pada singkatan (Mr., Dr., U.S.) lebih lazim.');
          break;
        case _Style.BE:
          extraStyleNotes.add('BE: Titik pada singkatan sering dihilangkan (Mr, Dr, US).');
          break;
        case _Style.Both:
          extraStyleNotes.add('Singkatan: sesuaikan gaya lembaga/pedoman penulisan.');
          break;
      }
    }

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
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final r in rules) ...[
              Text(r.title, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
              const SizedBox(height: 8),
              Text(r.text, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800])),
              if (r.examples.isNotEmpty) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    for (final ex in r.examples)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: color.withValues(alpha: 0.25)),
                        ),
                        child: Text(ex, style: primaryTextStyle.copyWith(fontSize: 12)),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
            ],

            if (extraStyleNotes.isNotEmpty) ...[
              const Divider(),
              Text('Style Notes', style: primaryTextStyle.copyWith(fontWeight: semiBold)),
              const SizedBox(height: 4),
              for (final n in extraStyleNotes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text('• $n', style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800])),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(Color color) {
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
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < _quiz.length; i++) ...[
              Text('Q${i + 1}. ${_quiz[i].question}', style: primaryTextStyle.copyWith(fontWeight: semiBold)),
              const SizedBox(height: 6),
              for (var j = 0; j < _quiz[i].options.length; j++)
                RadioListTile<int>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: j,
                  groupValue: _selected[i],
                  onChanged: (v) => setState(() => _selected[i] = v!),
                  title: Text(_quiz[i].options[j], style: primaryTextStyle.copyWith(fontSize: 13)),
                ),
              if (_selected[i] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _feedback(i),
                ),
              const Divider(),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submitQuiz,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Submit Kuis'),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _selected.clear();
                    _shuffleQuiz();
                  }),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _feedback(int i) {
    final chosen = _selected[i]!;
    final mcq = _quiz[i];
    final correct = chosen == mcq.correctIndex;
    final text = correct ? 'Benar! 🎉' : 'Kurang tepat. Coba lagi.';
    final color = correct ? Colors.green : Colors.red;
    return Row(
      children: [
        Icon(correct ? Icons.check_circle : Icons.cancel, color: color, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            mcq.explanation != null ? '$text ${mcq.explanation}' : text,
            style: primaryTextStyle.copyWith(fontSize: 12, color: color.shade700),
          ),
        ),
      ],
    );
  }
}
