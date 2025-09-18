import 'dart:math';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PuncMatchGame extends StatefulWidget {
  const PuncMatchGame({super.key});
  @override
  State<PuncMatchGame> createState() => _PuncMatchGameState();
}

class _Pair { final String key; final String value; final String explain; const _Pair(this.key, this.value, this.explain); }
class _Choice { final int id; final String text; final String key; const _Choice(this.id, this.text, this.key); }

class _PuncMatchGameState extends State<PuncMatchGame> {
  final r = Random();
  late List<_Pair> _pairs;
  late List<_Choice> _choices;
  late Map<String, Color> _marks;
  int? _selectedId;

  @override
  void initState() { super.initState(); _setup(); }

  void _setup() {
    final data = <_Pair>[
      _Pair('Semicolon ;', 'link related clauses', 'Menghubungkan dua independent clause terkait.'),
      _Pair('Colon :', 'introduce a list/explanation', 'Memperkenalkan daftar/penjelasan setelah klausa lengkap.'),
      _Pair('Comma ,', 'separate items / clauses', 'Memisahkan item daftar, atau clause dengan conjunction.'),
      _Pair('Dash —', 'add emphasis/aside', 'Memberi selingan atau penekanan gaya.'),
      _Pair('Apostrophe ’', 'possession/contraction', 'Kepemilikan (John’s) atau kontraksi (don’t).'),
      _Pair('Quotation " "', 'direct speech/quotes', 'Menandai ucapan langsung atau kutipan.'),
    ]..shuffle(r);

    _pairs = data;
    int id = 1;
    _choices = _pairs.map((p) => _Choice(id++, p.value, p.key)).toList()..shuffle(r);
    _marks = {for (final p in _pairs) p.key: Colors.grey.withValues(alpha:0.3)};
    _selectedId = null;
    setState(() {});
  }

  void _onTap(_Pair p) {
    if (_selectedId == null) return;
    final c = _choices.firstWhere((e) => e.id == _selectedId);
    final ok = c.text == p.value;
    setState(() {
      _marks[p.key] = ok ? Colors.green : Colors.red;
    });
    AwesomeDialog(
      context: context,
      dialogType: ok ? DialogType.success : DialogType.info,
      title: ok ? 'Cocok!' : 'Belum tepat',
      desc: p.explain,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.deepPurple;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Game: Match', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _pairs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final p = _pairs[i];
                return InkWell(
                  onTap: () => _onTap(p),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _marks[p.key]!),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 6, offset: const Offset(0,2))],
                    ),
                    child: ListTile(
                      title: Text(p.key),
                      trailing: const Icon(Icons.style, color: Colors.deepPurple),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const Text('Pilih Fungsi:'),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in _choices)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(c.text),
                      selected: _selectedId == c.id,
                      onSelected: (_) => setState(() => _selectedId = c.id),
                      selectedColor: color.withValues(alpha:0.18),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
