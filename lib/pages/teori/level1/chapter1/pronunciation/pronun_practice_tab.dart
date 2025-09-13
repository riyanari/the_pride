import 'dart:async';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class PronunPracticeTab extends StatefulWidget {
  final AudioService audioService;
  final String title;
  const PronunPracticeTab({
    super.key,
    required this.audioService,
    required this.title,
  });

  @override
  State<PronunPracticeTab> createState() => _PronunPracticeTabState();
}

/// ===== Data Models =====
class ShadowLine {
  final String text;
  final String audio;
  const ShadowLine(this.text, this.audio);
}

class MinimalPair {
  final String aWord;
  final String bWord;
  final String aAudio;
  final String bAudio;
  final String contrast; // e.g. /ɪ/ vs /iː/
  const MinimalPair({
    required this.aWord,
    required this.bWord,
    required this.aAudio,
    required this.bAudio,
    required this.contrast,
  });
}

class SyllableItem {
  final String word;
  final int count;
  const SyllableItem(this.word, this.count);
}

class StressItem {
  final String word;
  final List<String> syl;
  final int stress; // index suku kata yang ditekan (0-based)
  const StressItem(this.word, this.syl, this.stress);
}

class _PronunPracticeTabState extends State<PronunPracticeTab> {
  final Random _random = Random();
  final PageController _pageController = PageController();

  /// ---------- Shadowing ----------
  final List<ShadowLine> _shadowLines = const [
    ShadowLine('Good morning!', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    ShadowLine('How are you today?', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    ShadowLine('I\'d like a cup of coffee, please.', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    ShadowLine('Could you say that again?', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    ShadowLine('Thanks for your help!', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
  ];

  /// ---------- Minimal Pairs (Listen & Choose) ----------
  final List<MinimalPair> _pairs = const [
    MinimalPair(
      aWord: 'ship',
      bWord: 'sheep',
      contrast: '/ɪ/ vs /iː/',
      aAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      bAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
    MinimalPair(
      aWord: 'full',
      bWord: 'fool',
      contrast: '/ʊ/ vs /uː/',
      aAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      bAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
    MinimalPair(
      aWord: 'bet',
      bWord: 'bat',
      contrast: '/e/ vs /æ/',
      aAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      bAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
    MinimalPair(
      aWord: 'cot',
      bWord: 'caught',
      contrast: '/ɒ/ vs /ɔː/',
      aAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      bAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
  ];

  int _mpIndex = 0;          // index pasangan saat ini
  bool _mpPlayA = true;      // yang diputar: kata A atau B?
  int _mpScore = 0;          // skor

  /// ---------- Syllable Count ----------
  final List<SyllableItem> _syllables = const [
    SyllableItem('cat', 1),
    SyllableItem('table', 2),
    SyllableItem('computer', 3),
    SyllableItem('photograph', 3),   // (pho-to-graph)
    SyllableItem('banana', 3),
    SyllableItem('university', 5),
  ];

  int _syIndex = 0;
  int _syScore = 0;

  /// ---------- Word Stress Tap ----------
  final List<StressItem> _stressBank = const [
    StressItem('banana', ['ba','na','na'], 1), // ba-NA-na
    StressItem('computer', ['com','pu','ter'], 1), // com-PU-ter
    StressItem('photograph', ['pho','to','graph'], 0), // PHO-to-graph
    StressItem('Japanese', ['Ja','pa','nese'], 2), // Ja-pa-NESE
    StressItem('education', ['e','du','ca','tion'], 2), // e-du-CA-tion
    StressItem('interesting', ['in','ter','est','ing'], 0), // IN-ter-est-ing
  ];

  int _wsIndex = 0;
  int _wsScore = 0;

  @override
  void initState() {
    super.initState();
    _shuffleAll();
    // Auto-play minimal pair pertama (opsional):
    WidgetsBinding.instance.addPostFrameCallback((_) => _mpPlay());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _shuffleAll() {
    setState(() {
      _mpIndex = 0;
      _mpScore = 0;
      _syIndex = 0;
      _syScore = 0;
      _wsIndex = 0;
      _wsScore = 0;

      _syllables.shuffle(_random);
      _stressBank.shuffle(_random);
      _mpIndex = 0;
      _mpPlayA = _random.nextBool();
    });
  }

  /// ====== Shadowing ======
  Widget _shadowingSection(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('1) Shadowing (listen → imitate)', color),
        const SizedBox(height: 8),
        ...List.generate(_shadowLines.length, (i) {
          final s = _shadowLines[i];
          return _ShadowPracticeTile(
            line: s,
            color: color,
            audioService: widget.audioService,
          );
        }),
        const SizedBox(height: 8),
        _infoBadge(
          icon: Icons.info_outline,
          text: 'Tips: Play → tirukan 2–3× → Record (hold) → Play Yours untuk bandingkan. Beri nilai bintang untuk tracking progres.',
          color: color,
        ),
      ],
    );
  }

  /// ====== Minimal Pairs Game ======
  void _mpPlay() {
    final p = _pairs[_mpIndex];
    final audio = _mpPlayA ? p.aAudio : p.bAudio;
    widget.audioService.playSound(audio);
  }

  void _mpAnswer(bool chooseA) {
    final p = _pairs[_mpIndex];
    final isRight = (chooseA && _mpPlayA) || (!chooseA && !_mpPlayA);

    if (isRight) {
      setState(() {
        _mpScore++;
      });
    }

    AwesomeDialog(
      context: context,
      dialogType: isRight ? DialogType.success : DialogType.info,
      title: isRight ? 'Benar! 🎉' : 'Belum tepat',
      desc: isRight
          ? 'Kamu mendengar: ${_mpPlayA ? p.aWord : p.bWord} (${p.contrast})'
          : 'Jawaban benar: ${_mpPlayA ? p.aWord : p.bWord} (${p.contrast})',
      btnOkOnPress: () {
        if (_mpIndex < _pairs.length - 1) {
          setState(() {
            _mpIndex++;
            _mpPlayA = _random.nextBool();
          });
          _mpPlay();
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Minimal Pairs — Selesai',
            desc: 'Skor: $_mpScore / ${_pairs.length}',
            btnOkText: 'Main Lagi',
            btnOkOnPress: () {
              setState(() {
                _mpScore = 0;
                _mpIndex = 0;
                _mpPlayA = _random.nextBool();
              });
              _mpPlay();
            },
          ).show();
        }
      },
    ).show();
  }

  Widget _minimalPairsSection(Color color) {
    final p = _pairs[_mpIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('2) Minimal Pairs — Listen & Choose', color),
        const SizedBox(height: 6),
        _infoBadge(
          icon: Icons.hearing,
          text: 'Dengar audio, lalu pilih kata yang kamu dengar. Kontras: ${p.contrast}',
          color: color,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _mpPlay,
                icon: const Icon(Icons.volume_up),
                label: const Text('Play'),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha:0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha:0.25)),
              ),
              child: Text('Skor: $_mpScore', style: primaryTextStyle),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            _bigChoiceButton(p.aWord, () => _mpAnswer(true)),
            _bigChoiceButton(p.bWord, () => _mpAnswer(false)),
          ],
        ),
      ],
    );
  }

  /// ====== Syllable Count Game ======
  void _syAnswer(int pick) {
    final it = _syllables[_syIndex];
    final isRight = pick == it.count;

    if (isRight) {
      setState(() {
        _syScore++;
      });
    }

    AwesomeDialog(
      context: context,
      dialogType: isRight ? DialogType.success : DialogType.info,
      title: isRight ? 'Benar! 🎉' : 'Belum tepat',
      desc: isRight ? 'Jumlah suku kata: ${it.count}' : 'Yang benar: ${it.count}',
      btnOkOnPress: () {
        if (_syIndex < _syllables.length - 1) {
          setState(() => _syIndex++);
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Syllable Count — Selesai',
            desc: 'Skor: $_syScore / ${_syllables.length}',
            btnOkText: 'Main Lagi',
            btnOkOnPress: () {
              setState(() {
                _syScore = 0;
                _syIndex = 0;
                _syllables.shuffle(_random);
              });
            },
          ).show();
        }
      },
    ).show();
  }

  Widget _syllableSection(Color color) {
    final it = _syllables[_syIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('3) Syllable Count', color),
        const SizedBox(height: 6),
        _infoBadge(
          icon: Icons.touch_app,
          text: 'Tentukan jumlah suku kata untuk kata berikut.',
          color: color,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha:0.25)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 6, offset: const Offset(0,2))],
          ),
          child: Center(
            child: Text(
                it.word,
                style: primaryTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold)
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: List.generate(6, (i) => i + 1) // 1..6
              .map((n) => ChoiceChip(
            label: Text('$n syllable${n==1?'':'s'}'),
            selected: false,
            onSelected: (_) => _syAnswer(n),
          ))
              .toList(),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha:0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha:0.25)),
            ),
            child: Text('Skor: $_syScore', style: primaryTextStyle),
          ),
        ),
      ],
    );
  }

  /// ====== Word Stress Tap ======
  void _wsPick(int pick) {
    final it = _stressBank[_wsIndex];
    final ok = pick == it.stress;

    if (ok) {
      setState(() {
        _wsScore++;
      });
    }

    final stressed = List.generate(
        it.syl.length,
            (i) => i == it.stress ? it.syl[i].toUpperCase() : it.syl[i]
    ).join('-');

    AwesomeDialog(
      context: context,
      dialogType: ok ? DialogType.success : DialogType.info,
      title: ok ? 'Benar! 🎉' : 'Belum tepat',
      desc: ok ? 'Stress di: ${it.syl[pick].toUpperCase()}' : 'Yang benar: $stressed',
      btnOkOnPress: () {
        if (_wsIndex < _stressBank.length - 1) {
          setState(() => _wsIndex++);
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Word Stress — Selesai',
            desc: 'Skor: $_wsScore / ${_stressBank.length}',
            btnOkText: 'Main Lagi',
            btnOkOnPress: () {
              setState(() {
                _wsIndex = 0;
                _wsScore = 0;
                _stressBank.shuffle(_random);
              });
            },
          ).show();
        }
      },
    ).show();
  }

  Widget _wordStressSection(Color color) {
    final it = _stressBank[_wsIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('4) Word Stress Tap', color),
        const SizedBox(height: 6),
        _infoBadge(
          icon: Icons.grading,
          text: 'Tap suku kata yang mendapat STRESS (tekanan).',
          color: color,
        ),
        const SizedBox(height: 10),
        Center(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < it.syl.length; i++)
                ChoiceChip(
                  label: Text(it.syl[i]),
                  selected: false,
                  onSelected: (_) => _wsPick(i),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha:0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha:0.25)),
            ),
            child: Text('Skor: $_wsScore', style: primaryTextStyle),
          ),
        ),
      ],
    );
  }

  /// ===== UI helpers =====
  Widget _sectionTitle(String text, Color color) => Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha:0.3)),
        ),
        child: Text(
            text,
            style: primaryTextStyle.copyWith(fontWeight: FontWeight.bold)
        ),
      ),
    ],
  );

  Widget _infoBadge({required IconData icon, required String text, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha:0.25), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
                text,
                style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800])
            ),
          ),
        ],
      ),
    );
  }

  Widget _bigChoiceButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: 150,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
            text,
            style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 18)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> sectionColors = [
      Colors.green,
      Colors.indigo,
      Colors.deepPurple,
      Colors.orange,
    ];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          // title: Text(widget.title),
          bottom: TabBar(
            isScrollable: true,
            tabs: const [
              Tab(text: 'Shadowing'),
              Tab(text: 'Minimal Pairs'),
              Tab(text: 'Syllable Count'),
              Tab(text: 'Word Stress'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(_shadowingSection(sectionColors[0])),
            _buildTabContent(_minimalPairsSection(sectionColors[1])),
            _buildTabContent(_syllableSection(sectionColors[2])),
            _buildTabContent(_wordStressSection(sectionColors[3])),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _shuffleAll,
          child: const Icon(Icons.refresh),
          tooltip: 'Reset & Shuffle',
        ),
      ),
    );
  }

  Widget _buildTabContent(Widget content) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: content,
    );
  }
}

/// ===================================================================
/// Shadowing tile: Play model, Record, Play yours + rating bintang
/// ===================================================================
class _ShadowPracticeTile extends StatefulWidget {
  final ShadowLine line;
  final Color color;
  final AudioService audioService;
  const _ShadowPracticeTile({
    required this.line,
    required this.color,
    required this.audioService,
  });

  @override
  State<_ShadowPracticeTile> createState() => _ShadowPracticeTileState();
}

class _ShadowPracticeTileState extends State<_ShadowPracticeTile> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _localPlayer = AudioPlayer();
  bool _isRecording = false;
  String? _recPath;
  Amplitude? _amp;
  int _stars = 0;

  StreamSubscription<Amplitude>? _ampSub;

  @override
  void dispose() {
    _ampSub?.cancel();
    _localPlayer.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecord() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      await _ampSub?.cancel();
      _ampSub = null;
      setState(() {
        _isRecording = false;
        _recPath = path;
        _amp = null;
      });
    } else {
      if (await _recorder.hasPermission()) {
        // stop semua audio sebelum rekam
        await _localPlayer.stop();
        // mulai rekaman
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ), path: '',
        );
        _ampSub?.cancel();
        _ampSub = _recorder
            .onAmplitudeChanged(const Duration(milliseconds: 120))
            .listen((amp) => setState(() => _amp = amp));
        setState(() => _isRecording = true);
      }
    }
  }

  Future<void> _playModel() async {
    // stop rekaman & playback lokal
    if (_isRecording) await _toggleRecord();
    await _localPlayer.stop();
    await widget.audioService.playSound(widget.line.audio);
  }

  Future<void> _playMine() async {
    if (_recPath == null) return;
    if (_isRecording) await _toggleRecord();
    await _localPlayer.stop();
    await _localPlayer.play(UrlSource(_recPath!));
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    final barDb = (_amp?.current ?? -45).clamp(-45, 0); // dB ~ [-45..0]
    final barPct = (barDb + 45) / 45; // 0..1

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha:0.25)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.line.text, style: primaryTextStyle),
          const SizedBox(height: 10),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _playModel,
                icon: const Icon(Icons.volume_up),
                label: const Text('Model'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecording ? Colors.red : null,
                ),
                onPressed: _toggleRecord,
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                label: Text(_isRecording ? 'Stop' : 'Record'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _recPath == null ? null : _playMine,
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('Yours'),
              ),
            ],
          ),

          if (_isRecording) ...[
            const SizedBox(height: 8),
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: c.withValues(alpha:0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                widthFactor: barPct,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 8),
          Row(
            children: [
              for (int i = 1; i <= 5; i++)
                IconButton(
                  iconSize: 22,
                  padding: EdgeInsets.zero,
                  onPressed: () => setState(() => _stars = i),
                  icon: Icon(
                    i <= _stars ? Icons.star : Icons.star_border,
                    color: i <= _stars ? Colors.amber : Colors.grey,
                  ),
                  tooltip: 'Nilai ${i}★',
                ),
              const SizedBox(width: 6),
              Text(_stars == 0 ? 'Rate your imitation' : 'Rated: $_stars★'),
              const Spacer(),
              if (_recPath != null)
                Icon(Icons.check_circle, color: Colors.green.shade500, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}