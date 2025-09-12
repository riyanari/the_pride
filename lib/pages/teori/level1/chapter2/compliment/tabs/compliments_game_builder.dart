import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

import '../compliment_shared.dart';

class BuildComplimentGame extends StatefulWidget {
  const BuildComplimentGame({super.key});

  @override
  State<BuildComplimentGame> createState() => _BuildComplimentGameState();
}

class _BuildComplimentGameState extends State<BuildComplimentGame> {
  final AudioService _audio = AudioService();

  String _opener = 'I just wanted to say';
  String _softener = 'really';
  String _target = 'your presentation';
  String _adj = 'great';
  String _reason = 'especially the data visualization.';

  @override
  Widget build(BuildContext context) {
    final color = Colors.green;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Build a Compliment', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              IconButton(onPressed: _reset, icon: const Icon(Icons.refresh)),
            ],
          ),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.construction, text: 'Susun pujianmu: pilih komponen → generate. Tambahkan alasan agar terdengar tulus.'),
          const SizedBox(height: 8),
          pickerRow('Opener', color, const ['I just wanted to say', 'I really think', 'Can I just say'], (v) => setState(() => _opener = v), _opener),
          pickerRow('Softener', color, const ['really', 'so', 'absolutely', 'quite', 'pretty'], (v) => setState(() => _softener = v), _softener),
          pickerRow('Target', color, const ['your presentation', 'your idea', 'your report', 'your design', 'your help'], (v) => setState(() => _target = v), _target),
          pickerRow('Adjective', color, const ['great', 'impressive', 'creative', 'clear', 'thoughtful'], (v) => setState(() => _adj = v), _adj),
          pickerRow('Reason', color, const ['especially the data visualization.', 'because it solves the problem.', '—it really helped the team.', '—it was exactly what we needed.'], (v) => setState(() => _reason = v), _reason),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              final out = '$_opener, $_target was $_softener $_adj, $_reason';
              AwesomeDialog(
                context: context,
                dialogType: DialogType.noHeader,
                title: 'Your Compliment',
                desc: out,
                btnOkText: 'Copy',
                btnOkOnPress: () => Clipboard.setData(ClipboardData(text: out)),
                btnCancelText: 'Play',
                btnCancelOnPress: () => _audio.playSound(kComplimentAudioUrl),
              ).show();
            },
            icon: const Icon(Icons.bolt),
            label: const Text('Generate'),
          )
        ],
      ),
    );
  }

  void _reset() {
    setState(() {
      _opener = 'I just wanted to say';
      _softener = 'really';
      _target = 'your presentation';
      _adj = 'great';
      _reason = 'especially the data visualization.';
    });
  }
}
