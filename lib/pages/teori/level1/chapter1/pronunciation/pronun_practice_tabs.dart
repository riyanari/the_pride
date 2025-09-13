import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

// ========== UI Helpers ==========
Widget _titlePill(String text, Color c) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  decoration: BoxDecoration(
    color: c.withValues(alpha:0.1),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: c.withValues(alpha:0.3)),
  ),
  child: Text(text, style: primaryTextStyle.copyWith(fontWeight: FontWeight.bold)),
);

Widget _info(IconData icon, String text, Color c) => Container(
  margin: const EdgeInsets.only(top: 4, bottom: 8),
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  decoration: BoxDecoration(
    color: c.withValues(alpha:0.08),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: c.withValues(alpha:0.25)),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
  ),
  child: Row(children: [
    Icon(icon, color: c, size: 18), const SizedBox(width: 8),
    Expanded(child: Text(text, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]))),
  ]),
);

SizedBox _bigBtn(String text, VoidCallback onTap) => SizedBox(
  width: 150, height: 56,
  child: ElevatedButton(onPressed: onTap, child: Text(text, style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 18))),
);

// =====================================================
//                   ENTRY WIDGET (di tab Practice)
// =====================================================
class PronunPracticeTabs extends StatelessWidget {
  final AudioService audioService;
  final String title;
  const PronunPracticeTabs({super.key, required this.audioService, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul tab
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
            child: Text(title, style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          // TabBar lokal (tanpa AppBar baru)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Material(
              color: Colors.transparent,
              child: const TabBar(
                isScrollable: true,
                labelColor: Colors.indigo,
                tabs: [
                  Tab(text: 'Shadowing'),
                  Tab(text: 'Minimal Pairs'),
                  Tab(text: 'Syllable Count'),
                  Tab(text: 'Word Stress'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Konten tiap tab
          Expanded(
            child: TabBarView(
              children: [
                _ShadowingTab(audio: audioService),
                _MinimalPairsTab(audio: audioService),
                const _SyllableCountTab(),
                const _WordStressTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
//                       TAB 1: SHADOWING
// =====================================================
class _ShadowLine { final String text, audio; const _ShadowLine(this.text, this.audio); }

class _ShadowingTab extends StatelessWidget {
  final AudioService audio;
  const _ShadowingTab({required this.audio});

  static const lines = <_ShadowLine>[
    _ShadowLine('Good morning!', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    _ShadowLine('How are you today?', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    _ShadowLine('I’d like a cup of coffee, please.', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    _ShadowLine('Could you say that again?', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    _ShadowLine('Thanks for your help!', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
  ];

  @override
  Widget build(BuildContext context) {
    const c = Colors.green;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      children: [
        _titlePill('Shadowing (listen → imitate)', c),
        _info(Icons.info_outline, 'Play → tirukan 2–3× → Record → Play Yours untuk bandingkan. Beri rating untuk tracking progres.', c),
        const SizedBox(height: 4),
        for (final s in lines) _ShadowTile(line: s, color: c, audio: audio),
      ],
    );
  }
}

class _ShadowTile extends StatefulWidget {
  final _ShadowLine line; final Color color; final AudioService audio;
  const _ShadowTile({required this.line, required this.color, required this.audio});
  @override State<_ShadowTile> createState() => _ShadowTileState();
}

class _ShadowTileState extends State<_ShadowTile> {
  final _rec = AudioRecorder();
  final _local = AudioPlayer();
  bool _recOn = false;
  String? _path;
  Amplitude? _amp;
  int _stars = 0;
  StreamSubscription<Amplitude>? _ampSub;

  @override
  void dispose() {
    _ampSub?.cancel();
    _local.dispose();
    _rec.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_recOn) {
      final p = await _rec.stop();
      await _ampSub?.cancel();
      setState(() { _recOn = false; _path = p; _amp = null; });
    } else {
      if (await _rec.hasPermission()) {
        await _local.stop();
        await _rec.start(const RecordConfig(
          encoder: AudioEncoder.aacLc,
          sampleRate: 44100,
          bitRate: 128000,
        ), path: '');
        _ampSub?.cancel();
        _ampSub = _rec.onAmplitudeChanged(const Duration(milliseconds: 120))
            .listen((a) => setState(() => _amp = a));
        setState(() => _recOn = true);
      }
    }
  }

  Future<void> _playModel() async { if (_recOn) await _toggle(); await _local.stop(); await widget.audio.playSound(widget.line.audio); }
  Future<void> _playMine() async { if (_path == null) return; if (_recOn) await _toggle(); await _local.stop(); await _local.play(DeviceFileSource(_path!)); }

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    final barDb = (_amp?.current ?? -45).clamp(-45, 0);
    final barPct = (barDb + 45) / 45;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha:0.25)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.line.text, style: primaryTextStyle),
        const SizedBox(height: 8),
        Row(children: [
          OutlinedButton.icon(onPressed: _playModel, icon: const Icon(Icons.volume_up), label: const Text('Model')),
          const SizedBox(width: 8),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: _recOn ? Colors.red : null),
              onPressed: _toggle, icon: Icon(_recOn ? Icons.stop : Icons.mic), label: Text(_recOn ? 'Stop' : 'Record')),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: _path == null ? null : _playMine, icon: const Icon(Icons.play_circle_outline), label: const Text('Yours')),
        ]),
        if (_recOn) ...[
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(color: c.withValues(alpha:0.15), borderRadius: BorderRadius.circular(4)),
            child: FractionallySizedBox(widthFactor: barPct, alignment: Alignment.centerLeft,
              child: Container(decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(4))),
            ),
          ),
        ],
        const SizedBox(height: 8),
        Row(children: [
          for (int i = 1; i <= 5; i++)
            IconButton(
                iconSize: 22, padding: EdgeInsets.zero,
                onPressed: () => setState(() => _stars = i),
                icon: Icon(i <= _stars ? Icons.star : Icons.star_border, color: i <= _stars ? Colors.amber : Colors.grey)),
          const SizedBox(width: 6),
          Text(_stars == 0 ? 'Rate your imitation' : 'Rated: $_stars★'),
          const Spacer(),
          if (_path != null) Icon(Icons.check_circle, color: Colors.green.shade500, size: 18),
        ]),
      ]),
    );
  }
}

// =====================================================
//                    TAB 2: MINIMAL PAIRS
// =====================================================
class _MinimalPair { final String a, b, aAudio, bAudio, contrast; const _MinimalPair(this.a,this.b,this.aAudio,this.bAudio,this.contrast); }

class _MinimalPairsTab extends StatefulWidget {
  final AudioService audio; const _MinimalPairsTab({required this.audio});
  @override State<_MinimalPairsTab> createState() => _MinimalPairsTabState();
}
class _MinimalPairsTabState extends State<_MinimalPairsTab> {
  final r = Random();
  late List<_MinimalPair> pairs; int idx = 0; bool playA = true; int score = 0;

  @override
  void initState() {
    super.initState();
    pairs = const [
      _MinimalPair('ship','sheep', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3','https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3','/ɪ/ vs /iː/'),
      _MinimalPair('full','fool', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3','https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3','/ʊ/ vs /uː/'),
      _MinimalPair('bet','bat', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3','https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3','/e/ vs /æ/'),
      _MinimalPair('cot','caught', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3','https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3','/ɒ/ vs /ɔː/'),
    ].toList()..shuffle(r);
    playA = r.nextBool();
  }

  void _play() => widget.audio.playSound(playA ? pairs[idx].aAudio : pairs[idx].bAudio);

  void _answer(bool chooseA) {
    final ok = (chooseA && playA) || (!chooseA && !playA);
    if (ok) score++;
    final p = pairs[idx];

    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(ok ? 'Benar! 🎉' : 'Belum tepat'),
      content: Text(ok ? 'Kamu mendengar: ${playA ? p.a : p.b} (${p.contrast})' : 'Jawaban benar: ${playA ? p.a : p.b} (${p.contrast})'),
      actions: [TextButton(
        onPressed: () {
          Navigator.pop(context);
          if (idx < pairs.length - 1) { setState(() { idx++; playA = r.nextBool(); }); _play(); }
          else {
            showDialog(context: context, builder: (_) => AlertDialog(
              title: const Text('Selesai'), content: Text('Skor: $score / ${pairs.length}'),
              actions: [TextButton(onPressed: () { Navigator.pop(context); setState(() { score=0; idx=0; pairs.shuffle(r); playA=r.nextBool(); }); _play(); }, child: const Text('Main Lagi'))],
            ));
          }
        },
        child: const Text('OK'),
      )],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final p = pairs[idx];
    const c = Colors.indigo;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      children: [
        _titlePill('Minimal Pairs — Listen & Choose', c),
        _info(Icons.hearing, 'Dengar audio, lalu pilih kata yang kamu dengar. Kontras: ${p.contrast}', c),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: _play, icon: const Icon(Icons.volume_up), label: const Text('Play'))),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: c.withValues(alpha:0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: c.withValues(alpha:0.25))),
            child: Text('Skor: $score', style: primaryTextStyle),
          ),
        ]),
        const SizedBox(height: 10),
        Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: [
          _bigBtn(p.a, () => _answer(true)),
          _bigBtn(p.b, () => _answer(false)),
        ]),
      ],
    );
  }
}

// =====================================================
//                    TAB 3: SYLLABLE COUNT
// =====================================================
class _SylItem { final String word; final int count; const _SylItem(this.word, this.count); }

class _SyllableCountTab extends StatefulWidget { const _SyllableCountTab(); @override State<_SyllableCountTab> createState() => _SyllableCountTabState(); }
class _SyllableCountTabState extends State<_SyllableCountTab> {
  final r = Random();
  final items = <_SylItem>[
    const _SylItem('cat', 1),
    const _SylItem('table', 2),
    const _SylItem('computer', 3),
    const _SylItem('photograph', 3),
    const _SylItem('banana', 3),
    const _SylItem('university', 5),
  ];
  int idx = 0, score = 0;

  @override void initState() { super.initState(); items.shuffle(r); }

  void _answer(int n) {
    final it = items[idx];
    final ok = n == it.count; if (ok) score++;
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(ok ? 'Benar! 🎉' : 'Belum tepat'),
      content: Text(ok ? 'Jumlah suku kata: ${it.count}' : 'Yang benar: ${it.count}'),
      actions: [TextButton(onPressed: () {
        Navigator.pop(context);
        if (idx < items.length - 1) setState(() => idx++); else {
          showDialog(context: context, builder: (_) => AlertDialog(
            title: const Text('Selesai'), content: Text('Skor: $score / ${items.length}'),
            actions: [TextButton(onPressed: () { Navigator.pop(context); setState(() { score=0; idx=0; items.shuffle(r); }); }, child: const Text('Main Lagi'))],
          ));
        }
      }, child: const Text('OK'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final it = items[idx];
    const c = Colors.deepPurple;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      children: [
        _titlePill('Syllable Count', c),
        _info(Icons.touch_app, 'Tentukan jumlah suku kata untuk kata berikut.', c),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withValues(alpha:0.25)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 6, offset: const Offset(0,2))]),
          child: Center(child: Text(it.word, style: primaryTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10, runSpacing: 10, alignment: WrapAlignment.center,
          children: List.generate(6, (i) => i + 1).map((n) =>
              ChoiceChip(label: Text('$n syllable${n==1?'':'s'}'), selected: false, onSelected: (_) => _answer(n))
          ).toList(),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: c.withValues(alpha:0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: c.withValues(alpha:0.25))),
            child: Text('Skor: $score', style: primaryTextStyle),
          ),
        ),
      ],
    );
  }
}

// =====================================================
//                    TAB 4: WORD STRESS
// =====================================================
class _StressItem { final List<String> syl; final int stress; const _StressItem(this.syl, this.stress); }

class _WordStressTab extends StatefulWidget { const _WordStressTab(); @override State<_WordStressTab> createState() => _WordStressTabState(); }
class _WordStressTabState extends State<_WordStressTab> {
  final r = Random();
  final bank = <_StressItem>[
    const _StressItem(['ba','na','na'], 1),      // ba-NA-na
    const _StressItem(['com','pu','ter'], 1),    // com-PU-ter
    const _StressItem(['pho','to','graph'], 0),  // PHO-to-graph
    const _StressItem(['Ja','pa','nese'], 2),    // Ja-pa-NESE
    const _StressItem(['e','du','ca','tion'], 2),// e-du-CA-tion
    const _StressItem(['in','ter','est','ing'], 0), // IN-ter-est-ing
  ];
  int idx = 0, score = 0;

  @override void initState() { super.initState(); bank.shuffle(r); }

  void _pick(int i) {
    final it = bank[idx];
    final ok = i == it.stress; if (ok) score++;
    final stressed = List.generate(it.syl.length, (n) => n==it.stress ? it.syl[n].toUpperCase() : it.syl[n]).join('-');

    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(ok ? 'Benar! 🎉' : 'Belum tepat'),
      content: Text(ok ? 'Stress di: ${it.syl[i].toUpperCase()}' : 'Yang benar: $stressed'),
      actions: [TextButton(onPressed: () {
        Navigator.pop(context);
        if (idx < bank.length - 1) setState(() => idx++); else {
          showDialog(context: context, builder: (_) => AlertDialog(
            title: const Text('Selesai'), content: Text('Skor: $score / ${bank.length}'),
            actions: [TextButton(onPressed: () { Navigator.pop(context); setState(() { idx=0; score=0; bank.shuffle(r); }); }, child: const Text('Main Lagi'))],
          ));
        }
      }, child: const Text('OK'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final it = bank[idx];
    const c = Colors.orange;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      children: [
        _titlePill('Word Stress Tap', c),
        _info(Icons.grading, 'Tap suku kata yang mendapat STRESS.', c),
        const SizedBox(height: 10),
        Center(
          child: Wrap(
            spacing: 8, runSpacing: 8,
            children: List.generate(it.syl.length, (i) =>
                ChoiceChip(label: Text(it.syl[i]), selected: false, onSelected: (_) => _pick(i))),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: c.withValues(alpha:0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: c.withValues(alpha:0.25))),
            child: Text('Skor: $score', style: primaryTextStyle),
          ),
        ),
      ],
    );
  }
}
