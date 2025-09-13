import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';
import 'pronun_practice_shared.dart';

class ShadowingPracticePage extends StatelessWidget {
  final AudioService audioService;
  const ShadowingPracticePage({super.key, required this.audioService});

  static final lines = <ShadowLine>[
    const ShadowLine('Good morning!', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    const ShadowLine('How are you today?', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    const ShadowLine('I’d like a cup of coffee, please.', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    const ShadowLine('Could you say that again?', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    const ShadowLine('Thanks for your help!', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
  ];

  @override
  Widget build(BuildContext context) {
    const color = Colors.green;
    return Scaffold(
      // appBar: AppBar(title: const Text('Shadowing')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        children: [
          sectionTitle('Shadowing (listen → imitate)', color),
          const SizedBox(height: 8),
          infoBadge(
            icon: Icons.info_outline,
            text: 'Play → tirukan 2–3× → Record (hold) → Play Yours untuk bandingkan. Beri nilai bintang untuk tracking progres.',
            color: color,
          ),
          const SizedBox(height: 8),
          for (final s in lines)
            ShadowPracticeTile(line: s, color: color, audioService: audioService),
        ],
      ),
    );
  }
}

/// ==== Tile untuk 1 kalimat ====
class ShadowPracticeTile extends StatefulWidget {
  final ShadowLine line;
  final Color color;
  final AudioService audioService;
  const ShadowPracticeTile({
    super.key,
    required this.line,
    required this.color,
    required this.audioService,
  });

  @override
  State<ShadowPracticeTile> createState() => _ShadowPracticeTileState();
}

class _ShadowPracticeTileState extends State<ShadowPracticeTile> {
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
      await _ampSub?.cancel(); _ampSub = null;
      setState(() { _isRecording = false; _recPath = path; _amp = null; });
    } else {
      if (await _recorder.hasPermission()) {
        await _localPlayer.stop();
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ), path: '',
        );
        _ampSub?.cancel();
        _ampSub = _recorder.onAmplitudeChanged(const Duration(milliseconds: 120))
            .listen((amp) => setState(() => _amp = amp));
        setState(() => _isRecording = true);
      }
    }
  }

  Future<void> _playModel() async {
    if (_isRecording) await _toggleRecord();
    await _localPlayer.stop();
    await widget.audioService.playSound(widget.line.audio);
  }

  Future<void> _playMine() async {
    if (_recPath == null) return;
    if (_isRecording) await _toggleRecord();
    await _localPlayer.stop();
    await _localPlayer.play(DeviceFileSource(_recPath!));
  }

  final compactOutlined = OutlinedButton.styleFrom(
    visualDensity: VisualDensity.compact,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    minimumSize: const Size(0, 40),
      foregroundColor: kWhiteColor,
      backgroundColor: kSecondaryColor
  );

  final compactElevatedBase = ElevatedButton.styleFrom(
    visualDensity: VisualDensity.compact,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    minimumSize: const Size(0, 40),
    foregroundColor: kWhiteColor,
    backgroundColor: kSecondaryColor
  );

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    final barDb = (_amp?.current ?? -45).clamp(-45, 0);
    final barPct = (barDb + 45) / 45;

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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _playModel,
                icon: const Icon(Icons.volume_up),
                label: const Text('Model'),
                style: compactOutlined,
              ),
              ElevatedButton.icon(
                style: compactElevatedBase.copyWith(
                  backgroundColor: WidgetStatePropertyAll(
                    _isRecording ? Colors.red : kSecondaryColor,
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    _isRecording ? Colors.white : kWhiteColor,
                  ),
                ),
                onPressed: _toggleRecord,
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                label: Text(_isRecording ? 'Stop' : 'Record'),
              ),
              OutlinedButton.icon(
                onPressed: _recPath == null ? null : _playMine,
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('Yours'),
                style: compactOutlined,
              ),
            ],
          ),
          if (_isRecording) ...[
            const SizedBox(height: 8),
            Container(
              height: 6,
              decoration: BoxDecoration(color: c.withValues(alpha:0.15), borderRadius: BorderRadius.circular(4)),
              child: FractionallySizedBox(
                widthFactor: barPct, alignment: Alignment.centerLeft,
                child: Container(decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(4))),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              for (int i = 1; i <= 5; i++)
                IconButton(
                  iconSize: 22, padding: EdgeInsets.zero,
                  onPressed: () => setState(() => _stars = i),
                  icon: Icon(i <= _stars ? Icons.star : Icons.star_border, color: i <= _stars ? Colors.amber : Colors.grey),
                  tooltip: 'Nilai ${i}★',
                ),
              const SizedBox(width: 6),
              const Spacer(),
              if (_recPath != null) Icon(Icons.check_circle, color: Colors.green.shade500, size: 18),
            ],
          ),
          Text(_stars == 0 ? 'Rate your imitation' : 'Rated: $_stars★'),
        ],
      ),
    );
  }
}
