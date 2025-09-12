import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/time_shared.dart';

class TimeSpellingGame extends StatefulWidget {
  /// Opsional: kirim daftar soalmu sendiri (gambar + jam).
  /// Jika null, akan pakai contoh bawaan di bawah.
  const TimeSpellingGame({super.key, this.questions});

  final List<ClockQ>? questions;

  @override
  State<TimeSpellingGame> createState() => _TimeSpellingGameState();
}

class ClockQ {
  /// path bisa asset (assets/...) atau URL (http/https)
  final String? imagePath;
  /// 0–23 (24-jam)
  final int hour;
  /// 0–59
  final int minute;

  const ClockQ({this.imagePath, required this.hour, required this.minute});
}

class _TimeSpellingGameState extends State<TimeSpellingGame> {
  final r = Random();
  late List<ClockQ> _items;
  int _index = 0;
  int _score = 0;

  final _ctrl = TextEditingController();
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _setup() {
    // Ambil list soal (pakai default kalau null), lalu copy ke list baru yang bisa dimodifikasi
    final base = widget.questions ?? const [
      ClockQ(imagePath: null, hour: 7,  minute: 15),
      ClockQ(imagePath: null, hour: 12, minute: 0),
      ClockQ(imagePath: null, hour: 5,  minute: 45),
      ClockQ(imagePath: null, hour: 9,  minute: 30),
      ClockQ(imagePath: null, hour: 3,  minute: 10),
      ClockQ(imagePath: null, hour: 10, minute: 20),
    ];

    _items = List<ClockQ>.of(base); // <-- salinan mutable
    _items.shuffle(r);

    _index = 0;
    _score = 0;
    _ctrl.clear();
    _showHint = false;
    setState(() {});
  }


  ClockQ get _q => _items[_index];

  /// ==== Normalisasi jawaban user ====
  String _norm(String s) {
    final t = s
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r"^it'?s\s+"), '') // buang "it's"
        .replaceAll(RegExp(r'\b(am|pm)\b'), '') // buang am/pm bila ada
        .replaceAll('-', ' ')                   // samakan "twenty-five" & "twenty five"
        .replaceAll(RegExp(r'[.,!]+'), '')      // buang tanda baca umum
        .replaceAll(RegExp(r'\s+'), ' ');       // rapikan spasi
    return t;
  }


  /// ==== Semua jawaban yang diterima untuk sebuah jam ====
  Set<String> _answersFor(int hour24, int minute) {
    final set = <String>{};

    final hw    = _hourWord12(hour24);
    final next  = _hourWord12((hour24 + 1) % 24);
    final uk    = _phraseUK(hour24, minute);
    final usDig = _digitalUS(hour24, minute);

    // Selalu terima bentuk UK & US-digital
    set.add(_norm(uk));
    set.add(_norm(usDig));

    // Sinonim & variasi umum
    if (minute == 0) {
      set.add(_norm(hw)); // "seven"
      if (hour24 == 12) set.add(_norm('noon'));
      if (hour24 == 0)  set.add(_norm('midnight'));
    } else {
      // UK: quarter/half tanpa 'a'
      if (minute == 15) {
        set.add(_norm('quarter past $hw'));
        set.add(_norm('fifteen past $hw'));
        // AmE: after
        set.add(_norm('quarter after $hw'));
        set.add(_norm('fifteen after $hw'));
      } else if (minute == 30) {
        set.add(_norm('half past $hw'));
        set.add(_norm('thirty past $hw')); // jarang, tapi boleh
      } else if (minute == 45) {
        set.add(_norm('quarter to $next'));
        set.add(_norm('fifteen to $next'));
      } else if (minute < 30) {
        final m = _numWord(minute);
        set.add(_norm('$m past $hw'));   // BrE
        set.add(_norm('$m after $hw'));  // AmE
        // US digital sinonim (sudah ditambah): seven fifteen, dst.
      } else {
        final to = 60 - minute;
        final mTo = _numWord(to);
        set.add(_norm('$mTo to $next')); // BrE
        // US digital sinonim (sudah ditambah): seven forty five, dst.
      }
    }

    return set;
  }

  // 1..12 → one..twelve (kita sudah punya hourName, pakai itu)
  String _hourWord12(int h24) {
    int h12 = h24 % 12;
    if (h12 == 0) h12 = 12;
    return hourName(h12); // dari time_shared.dart (one..twelve)
  }

// 0..59 → words
  String _numWord(int n) {
    const u = [
      'zero','one','two','three','four','five','six','seven','eight','nine','ten',
      'eleven','twelve','thirteen','fourteen','fifteen','sixteen','seventeen',
      'eighteen','nineteen'
    ];
    const tens = ['', '', 'twenty','thirty','forty','fifty'];
    if (n < 20) return u[n];
    final t = tens[n ~/ 10];
    final r = n % 10;
    return r == 0 ? t : '$t ${u[r]}'; // "twenty five"
  }

// British-style (past/to), full words
  String _phraseUK(int h24, int m) {
    final hw = _hourWord12(h24);
    final next = _hourWord12((h24 + 1) % 24);
    if (m == 0)   return "$hw o'clock";
    if (m == 15)  return 'a quarter past $hw';
    if (m == 30)  return 'half past $hw';
    if (m == 45)  return 'a quarter to $next';
    if (m < 30)   return '${_numWord(m)} past $hw';
    final to = 60 - m;
    return '${_numWord(to)} to $next';
  }

// American-style digital words: "seven fifteen", "seven oh five"
  String _digitalUS(int h24, int m) {
    final hw = _hourWord12(h24);
    if (m == 0) return "$hw o'clock";
    if (m < 10) return '$hw oh ${_numWord(m)}'; // seven oh five
    return '$hw ${_numWord(m)}';                // seven fifteen, seven thirty
  }


  void _check() {
    // Tolak jika ada angka
    if (RegExp(r'\d').hasMatch(_ctrl.text)) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        title: 'Gunakan kata, ya!',
        desc: 'Tulis waktu dengan KATA, misalnya:\n'
            '• quarter past seven (BrE)\n'
            '• fifteen after seven / seven fifteen (AmE)',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    final ok = _answersFor(_q.hour, _q.minute).contains(_norm(_ctrl.text));
    if (ok) _score++;

    AwesomeDialog(
      context: context,
      dialogType: ok ? DialogType.success : DialogType.info,
      title: ok ? 'Benar! 🎉' : 'Belum tepat',
      desc: ok
          ? 'Bagus! Lanjut soal berikutnya.'
          : 'Contoh jawaban:\n• ${_phraseUK(_q.hour, _q.minute)}\n• ${_digitalUS(_q.hour, _q.minute)}',
      btnOkOnPress: _next,
    ).show();
  }


  void _next() {
    if (_index < _items.length - 1) {
      setState(() {
        _index++;
        _ctrl.clear();
        _showHint = false;
      });
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Selesai',
        desc: 'Skor: $_score / ${_items.length}',
        btnOkText: 'Main Lagi',
        btnOkOnPress: _setup,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.brown;
    final width = MediaQuery.of(context).size.width;

    // final hhmm = '${twoDigits(_q.hour)}:${twoDigits(_q.minute)}';
    // final phrase = timePhrase(_q.hour, _q.minute);

    final hhmm = '${twoDigits(_q.hour)}:${twoDigits(_q.minute)}';
    final hintUK = _phraseUK(_q.hour, _q.minute);
    final hintUS = _digitalUS(_q.hour, _q.minute);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text('Spelling', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withOpacity(0.25)),
                ),
                child: Text('Skor: $_score', style: primaryTextStyle),
              ),
              IconButton(
                tooltip: 'Acak ulang',
                onPressed: _setup,
                icon: const Icon(Icons.shuffle),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Petunjuk + Hint
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.withOpacity(0.25)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0,2))],
            ),
            child: Row(
              children: [
                const Icon(Icons.edit, color: Colors.indigo, size: 18),
                const SizedBox(width: 8),
                // di widget petunjuk:
                Expanded(
                  child: Text(
                    'Lihat gambar jam, lalu TULIS cara membacanya. '
                        'Contoh: “a quarter past seven” atau “seven fifteen”.',
                    style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]),
                  ),
                ),
                IconButton(
                  tooltip: _showHint ? 'Sembunyikan hint' : 'Tampilkan hint',
                  onPressed: () => setState(() => _showHint = !_showHint),
                  icon: Icon(_showHint ? Icons.lightbulb : Icons.lightbulb_outline, color: Colors.indigo),
                ),
              ],
            ),
          ),
          if (_showHint) ...[
            const SizedBox(height: 6),
            Text(
              'Hint: $hintUK  •  $hintUS',
              style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700]),
            ),
          ],


          // Konten scrollable (biar aman saat keyboard muncul)
          Expanded(
            child: ListView(
              children: [
                // Gambar jam / placeholder
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: width * 0.9,
                      maxHeight: 280,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1, // kotak
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _q.imagePath == null
                            ? _DigitalPlaceholder(hhmm: hhmm, color: color)
                            : _q.imagePath!.startsWith('http')
                            ? Image.network(_q.imagePath!, fit: BoxFit.cover)
                            : Image.asset(_q.imagePath!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Text field jawaban
                TextField(
                  controller: _ctrl,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _check(),
                  decoration: InputDecoration(
                    labelText: 'Tulis jawabanmu di sini',
                    hintText: 'mis. a quarter past seven',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(
                      tooltip: 'Bersihkan',
                      onPressed: _ctrl.clear,
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // Tombol aksi
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _check,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Cek Jawaban'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: _next,
                icon: const Icon(Icons.navigate_next),
                label: const Text('Lewati / Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DigitalPlaceholder extends StatelessWidget {
  const _DigitalPlaceholder({required this.hhmm, required this.color});
  final String hhmm;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.06),
      child: Center(
        child: Text(
          hhmm,
          style: primaryTextStyle.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 48,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
