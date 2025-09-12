import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

/// GreetingsPage
/// Halaman (dengan 3 tab internal via CustomPageView) untuk pembelajaran sapaan:
/// 1) Pengertian
/// 2) Asking condition & its response
/// 3) Farewell / Parting
class GreetingsPage extends StatefulWidget {
  const GreetingsPage({super.key});

  @override
  State<GreetingsPage> createState() => _GreetingsPageState();
}

class _GreetingsPageState extends State<GreetingsPage> {
  final AudioService _audio = AudioService();
  final List<String> _pageTitles = const [
    'Pengertian',
    'Asking Condition',
    'Farewell / Parting',
  ];

  static const _audioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  // ===================== PENGERTIAN =====================
  Widget _buildPengertianTab() {
    final tips = [
      _Tip('Apa itu greeting?',
          'Greeting adalah ungkapan untuk menyapa atau membuka percakapan. Tujuan utamanya membangun kedekatan & sopan santun.'),
      _Tip('Register (Formal vs Informal)',
          'Pilih ungkapan sesuai konteks: formal (dengan atasan/dosen/klien) vs informal (teman/keluarga).'),
      _Tip('Time of Day', 'Beberapa sapaan mengikuti waktu: Good morning/afternoon/evening.'),
      _Tip('Small Talk', 'Setelah greeting, wajar dilanjutkan small talk: cuaca, kabar singkat, rencana, dsb.'),
    ];

    final examples = [
      _Phrase(
        phrase: 'Hello / Hi',
        ipa: ' /həˈləʊ ~ həˈloʊ/ | /haɪ/',
        note: 'Netral; “Hi” lebih santai. “Hello” lebih universal (formal/semiformal).',
        tags: const ['neutral', 'any time'],
      ),
      _Phrase(
        phrase: 'Good morning / afternoon / evening',
        ipa: ' /ɡʊd ˈmɔːnɪŋ/ …',
        note: 'Mengikuti waktu. “Good night” untuk berpamitan, bukan menyapa.',
        tags: const ['formal', 'time-of-day'],
      ),
      _Phrase(
        phrase: 'Hey',
        ipa: ' /heɪ/',
        note: 'Sangat informal; cocok untuk teman dekat.',
        tags: const ['informal'],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          _sectionTitle('Konsep Dasar', Colors.blue),
          const SizedBox(height: 8),
          for (final t in tips) _tipCard(t, Colors.blue),
          const SizedBox(height: 16),
          _sectionTitle('Contoh Ungkapan', Colors.green),
          const SizedBox(height: 8),
          for (final p in examples) _phraseCard(p, color: Colors.green, audio: _audio),
          const SizedBox(height: 8),
          _infoBadge(
            icon: Icons.lightbulb_outline,
            text:
            'Catatan: “Good night” biasanya dipakai saat berpamitan/menutup percakapan malam hari, bukan saat membuka.',
          ),
        ],
      ),
    );
  }

  // ===================== ASKING CONDITION =====================
  Widget _buildAskingTab() {
    final qa = <_QA>[
      _QA(
        question: 'How are you?',
        ipaQ: '/haʊ ɑː juː?/',
        level: 'netral',
        responses: const [
          'I’m fine, thanks. And you?',
          'Pretty good, thanks!',
          'Not bad. How about you?',
        ],
      ),
      _QA(
        question: 'How’s it going?',
        ipaQ: '/haʊz ɪt ˈɡoʊɪŋ?/',
        level: 'informal',
        responses: const [
          'Good! You?',
          'All good, thanks.',
        ],
      ),
      _QA(
        question: 'How are you doing?',
        ipaQ: '/haʊ ɑː juː ˈduːɪŋ?/',
        level: 'semiformal',
        responses: const [
          'I’m doing well, thank you.',
          'I’m doing great. And you?',
        ],
      ),
      _QA(
        question: 'You alright? (BE)',
        ipaQ: '/juː ɔːlˈraɪt?/',
        level: 'BE informal',
        responses: const [
          'Yeah, you?',
          'All right, cheers!',
        ],
      ),
      _QA(
        question: 'What’s up? / Sup?',
        ipaQ: '/wɒts ʌp/ ~ /wʌts ʌp/',
        level: 'sangat informal',
        responses: const [
          'Not much. You?',
          'Just chilling.',
        ],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          _sectionTitle('Asking Condition & Responses', Colors.purple),
          const SizedBox(height: 8),
          for (final item in qa) _qaCard(item, Colors.purple, _audio),
          const SizedBox(height: 12),
          _sectionTitle('Tips', Colors.orange),
          const SizedBox(height: 8),
          _tipCard(
            _Tip('Jawab singkat + balikan pertanyaan',
                'Umumnya direspon singkat lalu diikuti balikan: “I’m good, thanks. And you?”'),
            Colors.orange,
          ),
          _tipCard(
            _Tip('Konteks formal vs informal',
                'Gunakan bentuk lebih formal saat situasi resmi; bentuk slang untuk teman agar terdengar natural.'),
            Colors.orange,
          ),
        ],
      ),
    );
  }

  // ===================== FAREWELL / PARTING =====================
  Widget _buildFarewellTab() {
    final farewells = [
      _Phrase(
        phrase: 'Goodbye / Bye',
        ipa: '/ɡʊdˈbaɪ/ | /baɪ/',
        note: 'Umum. “Goodbye” lebih formal; “Bye” santai.',
        tags: const ['any time', 'neutral'],
      ),
      _Phrase(
        phrase: 'See you (later / soon / tomorrow)',
        ipa: '/siː juː …/',
        note: 'Lebih personal; cocok untuk rencana bertemu lagi.',
        tags: const ['friendly'],
      ),
      _Phrase(
        phrase: 'Take care',
        ipa: '/teɪk keə ~ ker/',
        note: 'Hangat dan sopan.',
        tags: const ['warm'],
      ),
      _Phrase(
        phrase: 'Have a good one / Have a nice day',
        ipa: '/hæv ə ɡʊd wʌn/ …',
        note: 'Umum di layanan/pelayanan (AE).',
        tags: const ['AE tendency'],
      ),
      _Phrase(
        phrase: 'Good night',
        ipa: '/ɡʊd ˈnaɪt/',
        note: 'Untuk berpamitan malam hari (bukan menyapa).',
        tags: const ['night'],
      ),
      _Phrase(
        phrase: 'Cheers (BE)',
        ipa: '/tʃɪəz/',
        note: 'Santai; bisa berarti “terima kasih” atau salam perpisahan (BE).',
        tags: const ['BE'],
      ),
    ];

    final miniDialog = [
      'A: It was nice talking to you.',
      'B: You too. See you tomorrow!'
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          _sectionTitle('Parting Expressions', Colors.teal),
          const SizedBox(height: 8),
          for (final p in farewells) _phraseCard(p, color: Colors.teal, audio: _audio),
          const SizedBox(height: 16),
          _sectionTitle('Mini Dialogue', Colors.indigo),
          const SizedBox(height: 8),
          _dialogCard(miniDialog, Colors.indigo),
          const SizedBox(height: 8),
          _infoBadge(
            icon: Icons.info_outline,
            text:
            '“See you later” tidak selalu berarti benar-benar bertemu “nanti”, bisa sekadar salam perpisahan ramah.',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Greetings', iconSize: 16.0),
      body: CustomPageView(
        pageTitles: _pageTitles,
        pages: [
          _buildPengertianTab(),
          _buildAskingTab(),
          _buildFarewellTab(),
        ],
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}

// ===================== UI HELPERS & MODELS =====================
class _Tip {
  final String title;
  final String text;
  const _Tip(this.title, this.text);
}

class _Phrase {
  final String phrase;
  final String? ipa;
  final String note;
  final List<String> tags;
  const _Phrase({required this.phrase, this.ipa, required this.note, this.tags = const []});
}

class _QA {
  final String question;
  final String ipaQ;
  final String level;
  final List<String> responses;
  const _QA({required this.question, required this.ipaQ, required this.level, required this.responses});
}

Widget _sectionTitle(String text, Color color) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(text, style: primaryTextStyle.copyWith(fontWeight: FontWeight.bold)),
      ),
    ],
  );
}

Widget _tipCard(_Tip tip, Color color) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 2)),
      ],
    ),
    child: ListTile(
      leading: Icon(Icons.info_outline, color: color),
      title: Text(tip.title, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
      subtitle: Text(tip.text, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800])),
    ),
  );
}

Widget _phraseCard(_Phrase p, {required Color color, required AudioService audio}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 2)),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(p.phrase, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
              ),
              IconButton(
                tooltip: 'Play',
                onPressed: () => audio.playSound(_GreetingsPageState._audioUrl),
                icon: Icon(Icons.volume_up, color: color),
              )
            ],
          ),
          if (p.ipa != null)
            Text(p.ipa!, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
          const SizedBox(height: 6),
          Text(p.note, style: primaryTextStyle.copyWith(fontSize: 12)),
          if (p.tags.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: -6,
              children: p.tags
                  .map((t) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.25)),
                ),
                child: Text(t, style: primaryTextStyle.copyWith(fontSize: 12)),
              ))
                  .toList(),
            ),
          ]
        ],
      ),
    ),
  );
}

Widget _qaCard(_QA qa, Color color, AudioService audio) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 2)),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(qa.question, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
              ),
              IconButton(
                tooltip: 'Play',
                onPressed: () => audio.playSound(_GreetingsPageState._audioUrl),
                icon: Icon(Icons.volume_up, color: color),
              ),
            ],
          ),
          Text(qa.ipaQ, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
          const SizedBox(height: 6),
          _chip('level: ${qa.level}', color),
          const SizedBox(height: 6),
          Text('Possible responses:', style: primaryTextStyle.copyWith(fontWeight: semiBold)),
          const SizedBox(height: 4),
          for (final r in qa.responses)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(child: Text(r, style: primaryTextStyle)),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _chip(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withValues(alpha: 0.25)),
    ),
    child: Text(text, style: primaryTextStyle.copyWith(fontSize: 12)),
  );
}

Widget _dialogCard(List<String> lines, Color color) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 2)),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final l in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(l, style: primaryTextStyle),
            ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                AwesomeDialog(
                  context: navigatorKey.currentContext ?? (throw 'No context'),
                  dialogType: DialogType.info,
                  title: 'Tips',
                  desc:
                  'Tekankan intonasi naik saat bertanya dan nada turun saat berpamitan. Senyum & kontak mata membantu naturalness.',
                  btnOkOnPress: () {},
                ).show();
              },
              icon: const Icon(Icons.info_outline, size: 16),
              label: const Text('Delivery Tips'),
            ),
          )
        ],
      ),
    ),
  );
}

Widget _infoBadge({required IconData icon, required String text, Color? color}) {
  final c = color ?? Colors.indigo;
  return Container(
    margin: const EdgeInsets.only(top: 4, bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: c.withValues(alpha:0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: c.withValues(alpha:0.25), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.06),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: c, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]),
          ),
        ),
      ],
    ),
  );
}


// NOTE: navigatorKey harus disediakan di MaterialApp agar AwesomeDialog dapat dipanggil dari helper ini.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
