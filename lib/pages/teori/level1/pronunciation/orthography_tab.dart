import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';

/// OrthographyTab
///
/// Tab kuis ortografi berdasarkan kalimat IPA (BE/AE) yang kamu berikan.
/// Fitur:
/// - Pilih aksen yang ditampilkan: BE / AE / Both
/// - Input jawaban per nomor
/// - Cek jawaban (toleran huruf besar-kecil & tanda baca)
/// - Lihat kunci jawaban per nomor
/// - Submit semua → skor total + dialog hasil
class OrthographyTab extends StatefulWidget {
  const OrthographyTab({super.key, this.title = 'Orthography Test'});

  final String title;

  @override
  State<OrthographyTab> createState() => _OrthographyTabState();
}

class _OrthographyTabState extends State<OrthographyTab> {
  String _accentMode = 'Both'; // BE, AE, Both

  // Data soal (IPA + jawaban target)
  final List<_OrthoItem> _items = [
    _OrthoItem(
      number: 1,
      ipaBE: "ðıs 'zeb.rə hæz bi:n bə:t baı ðə zu:",
      ipaAE: "ðıs 'zi:.brə hæz bi:n ba:t baı ðə zu:",
      // Kedua aksen → ortografi sama
      answerBE: 'This zebra has been bought by the zoo',
      answerAE: 'This zebra has been bought by the zoo',
    ),
    _OrthoItem(
      number: 2,
      ipaBE: "red ız mai fer.vr.ıt 'køl.ə",
      ipaAE: "red iz mai feı.vr.ıt 'køla",
      answerBE: 'Red is my favourite colour',
      answerAE: 'Red is my favorite color',
    ),
    _OrthoItem(
      number: 3,
      ipaBE: "õi: 'ın.glıf drınk ə lot pv bıə r",
      ipaAE: "õi: 'ın.glıf drınk ə la:t a:v bır",
      answerBE: 'We English drink a lot of beer',
      answerAE: 'We English drink a lot of beer',
    ),
    _OrthoItem(
      number: 4,
      ipaAE: "õə 'ran.ər krost ðə 'fınıſın laın",
      ipaBE: "ðə 'ran.a kra:stðə 'fınıfın laın",
      answerBE: 'The runner crossed the finishing line',
      answerAE: 'The runner crossed the finishing line',
    ),
    _OrthoItem(
      number: 5,
      ipaBE: "ai left 'sAm.01n pn ðə plein",
      ipaAE: "ai left 'sAm.Oın a:n ðə plein",
      answerBE: 'I left some coins on the plane',
      answerAE: 'I left some coins on the plane',
    ),
  ];

  // Controllers untuk teks jawaban user
  late final List<TextEditingController> _controllers =
  List.generate(_items.length, (_) => TextEditingController());

  // Status cek per soal
  final Map<int, _CheckState> _checkStates = {};

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  String _normalize(String s) {
    // Lowercase, hilangkan non-alnum, kompres spasi
    final lower = s.toLowerCase();
    final noPunct = lower.replaceAll(RegExp(r"[^a-z0-9\s]"), ' ');
    return noPunct.replaceAll(RegExp(r"\s+"), ' ').trim();
  }

  bool _isCorrect(String user, _OrthoItem item) {
    final u = _normalize(user);

    // Tentukan daftar jawaban yang diterima berdasar mode aksen
    final accepted = <String>{};
    if (_accentMode == 'BE' || _accentMode == 'Both') {
      accepted.add(_normalize(item.answerBE));
    }
    if (_accentMode == 'AE' || _accentMode == 'Both') {
      accepted.add(_normalize(item.answerAE));
    }

    return accepted.contains(u);
  }

  void _checkAll() {
    int correct = 0;
    for (var i = 0; i < _items.length; i++) {
      final ok = _isCorrect(_controllers[i].text, _items[i]);
      _checkStates[_items[i].number] = _CheckState(checked: true, correct: ok);
      if (ok) correct++;
    }
    setState(() {});

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Hasil',
      desc: 'Skor kamu: $correct / ${_items.length}',
      btnOkText: 'OK',
      btnOkOnPress: () {},
    ).show();
  }

  void _resetAll() {
    for (final c in _controllers) c.clear();
    _checkStates.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: Column(
        children: [
          // Header & Accent selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: primaryTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   decoration: BoxDecoration(
              //     color: kSecondaryColor.withValues(alpha: 0.08),
              //     borderRadius: BorderRadius.circular(8),
              //     border: Border.all(
              //       color: kSecondaryColor.withValues(alpha: 0.25),
              //     ),
              //   ),
              //   child: DropdownButton<String>(
              //     value: _accentMode,
              //     icon: const Icon(Icons.arrow_drop_down, size: 16),
              //     elevation: 2,
              //     style: primaryTextStyle.copyWith(fontSize: 12, fontWeight: semiBold),
              //     underline: const SizedBox(),
              //     onChanged: (v) => setState(() => _accentMode = v!),
              //     items: const ['BE', 'AE', 'Both']
              //         .map((s) => DropdownMenuItem<String>(value: s, child: Text(s)))
              //         .toList(),
              //   ),
              // )
            ],
          ),
          const SizedBox(height: 12),

          // Daftar soal
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _items[index];
                final controller = _controllers[index];
                final state = _checkStates[item.number];

                Color borderColor;
                if (state == null || !state.checked) {
                  borderColor = Colors.grey.withValues(alpha: 0.4);
                } else {
                  borderColor = state.correct ? Colors.green : Colors.red;
                }

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('#${item.number}', style: primaryTextStyle.copyWith(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Text('Lafalkan lalu tuliskan ortografinya', style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Teks IPA sesuai mode
                        if (_accentMode == 'BE' || _accentMode == 'Both')
                          _IpaLine(label: 'BE', ipa: item.ipaBE ?? '-'),
                        if (_accentMode == 'AE' || _accentMode == 'Both')
                          _IpaLine(label: 'AE', ipa: item.ipaAE ?? '-'),

                        const SizedBox(height: 8),
                        TextField(
                          controller: controller,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Ketik jawaban ortografi di sini... ',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                final ok = _isCorrect(controller.text, item);
                                setState(() {
                                  _checkStates[item.number] = _CheckState(checked: true, correct: ok);
                                });
                              },
                              icon: const Icon(Icons.check_circle_outline, size: 18),
                              label: const Text('Cek'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () {
                                final be = item.answerBE;
                                final ae = item.answerAE;
                                final showBoth = _accentMode == 'Both' && be != ae;

                                final answerText = showBoth
                                    ? 'BE: $be\nAE: $ae'
                                    : (_accentMode == 'AE' ? ae : be);

                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  title: 'Kunci Jawaban',
                                  desc: answerText,
                                  btnOkOnPress: () {},
                                  btnOkText: 'Tutup',
                                ).show();
                              },
                              icon: const Icon(Icons.visibility_outlined, size: 18),
                              label: const Text('Lihat Kunci'),
                            ),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Hapus jawaban',
                              onPressed: () {
                                controller.clear();
                                setState(() => _checkStates[item.number] = _CheckState(checked: false, correct: false));
                              },
                              icon: const Icon(Icons.clear),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _checkAll,
                  icon: const Icon(Icons.playlist_add_check_outlined),
                  label: const Text('Submit Semua'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _resetAll,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _IpaLine extends StatelessWidget {
  const _IpaLine({required this.label, required this.ipa});
  final String label;
  final String ipa;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(label, style: primaryTextStyle.copyWith(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ipa,
              style: primaryTextStyle.copyWith(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}

class _OrthoItem {
  const _OrthoItem({
    required this.number,
    this.ipaBE,
    this.ipaAE,
    required this.answerBE,
    required this.answerAE,
  });

  final int number;
  final String? ipaBE;
  final String? ipaAE;
  final String answerBE;
  final String answerAE;
}

class _CheckState {
  _CheckState({required this.checked, required this.correct});
  final bool checked;
  final bool correct;
}
