import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

class AlphabetListenMCQGame extends StatefulWidget {
  const AlphabetListenMCQGame({
    super.key,
    required this.items,
    this.title = 'Listen & Choose',
  });

  /// items: [{'letter':'Aa','sound':'/eɪ/','audio':'...'}, ...]
  final List<Map<String, String>> items;
  final String title;

  @override
  State<AlphabetListenMCQGame> createState() => _AlphabetListenMCQGameState();
}

class _AlphabetListenMCQGameState extends State<AlphabetListenMCQGame> {
  final r = Random();
  final AudioService _audio = AudioService();

  late List<int> _order;     // urutan soal (index ke widget.items)
  late int _i;               // pointer soal saat ini (index ke _order)
  late int _score;           // skor
  late List<String> _choices; // 4 opsi untuk soal aktif (huruf)
  bool _locked = false;      // mencegah double tap saat dialog muncul

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  void _setup() {
    _order = List<int>.generate(widget.items.length, (i) => i)..shuffle(r);
    _i = 0;
    _score = 0;
    _buildChoices();
    _play();
    setState(() {});
  }

  /// Ambil huruf besar dari field 'letter' (mis. "Aa" -> "A")
  String _upperLetterOf(int idx) {
    final s = widget.items[idx]['letter'] ?? '';
    return s.isNotEmpty ? s.characters.first.toUpperCase() : '';
  }

  void _buildChoices() {
    final correctIdx = _order[_i];
    final correct = _upperLetterOf(correctIdx);

    // Ambil 3 distraktor unik
    final pool = List<int>.generate(widget.items.length, (i) => i)..remove(correctIdx);
    pool.shuffle(r);
    final distractors = pool
        .take(3)
        .map((j) => _upperLetterOf(j))
        .toSet()
        .toList();

    // Pastikan jumlahnya 3 (kalau ada duplikat huruf di data)
    while (distractors.length < 3) {
      final j = r.nextInt(widget.items.length);
      if (j == correctIdx) continue;
      final L = _upperLetterOf(j);
      if (!distractors.contains(L)) distractors.add(L);
    }

    _choices = [correct, ...distractors]..shuffle(r);
  }

  void _play() {
    final audio = widget.items[_order[_i]]['audio'];
    if (audio != null && audio.isNotEmpty) _audio.playSound(audio);
  }

  void _answer(String pick) {
    if (_locked) return;
    _locked = true;

    final correct = _upperLetterOf(_order[_i]);
    final isRight = pick == correct;
    if (isRight) _score++;

    AwesomeDialog(
      context: context,
      dialogType: isRight ? DialogType.success : DialogType.info,
      title: isRight ? 'Benar! 🎉' : 'Belum tepat',
      desc: isRight
          ? 'Good job. Itu bunyi huruf "$correct".'
          : 'Jawaban yang benar: "$correct".',
      btnOkOnPress: _next,
    ).show();
  }

  void _next() {
    _locked = false;
    if (_i < _order.length - 1) {
      setState(() {
        _i++;
        _buildChoices();
      });
      _play();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Selesai',
        desc: 'Skor: $_score / ${_order.length}',
        btnOkText: 'Main Lagi',
        btnOkOnPress: _setup,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.indigo;

    // final progressText = '${_i + 1}/${_order.length}';
    final sound = widget.items[_order[_i]]['sound'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(widget.title,
                    style: primaryTextStyle.copyWith(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha:0.25)),
                ),
                child: Text('Skor: $_score',
                    style: primaryTextStyle.copyWith(fontWeight: semiBold)),
              ),
              IconButton(
                tooltip: 'Acak ulang',
                onPressed: _setup,
                icon: const Icon(Icons.shuffle),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Petunjuk
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha:0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha:0.25)),
            ),
            child: Row(
              children: [
                Icon(Icons.volume_up, color: color, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tap tombol speaker lalu pilih huruf yang kamu dengar.',
                    style: primaryTextStyle.copyWith(fontSize: 12),
                  ),
                ),
                IconButton(
                  tooltip: 'Putar lagi',
                  onPressed: _play,
                  icon: Icon(Icons.replay, color: color),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tombol Play besar + info IPA (opsional)
          ElevatedButton.icon(
            onPressed: _play,
            icon: const Icon(Icons.volume_up),
            label: const Text('Play Sound'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
          if (sound.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(sound, style: primaryTextStyle.copyWith(color: Colors.grey[700])),
          ],
          const SizedBox(height: 16),

          // Opsi jawaban 2x2
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _choices
                .map(
                  (opt) => SizedBox(
                width: 140,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _answer(opt),
                  child: Text(
                    opt,
                    style: primaryTextStyle.copyWith(
                      fontWeight: semiBold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            )
                .toList(),
          ),

          const Spacer(),

          // Navigasi cepat
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _play,
                  icon: const Icon(Icons.hearing),
                  label: const Text('Dengar Lagi'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: _next,
                icon: const Icon(Icons.navigate_next),
                label: const Text('Lewati'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
