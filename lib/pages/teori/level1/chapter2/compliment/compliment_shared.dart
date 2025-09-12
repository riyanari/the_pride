import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

// Audio placeholder (ganti dengan asset/URL kamu)
const kComplimentAudioUrl =
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }
class Phrase { final String phrase; final String? ipa; final String note; final List<String> tags;
const Phrase({required this.phrase, this.ipa, required this.note, this.tags = const []}); }
class Pair { final int id; final String compliment; final List<String> responses; final String explain;
const Pair({required this.id, required this.compliment, required this.responses, required this.explain}); }
class Choice { final int id; final String text; final int pairId; const Choice({required this.id, required this.text, required this.pairId}); }
class MCQItem { final String prompt; final List<String> options; final int correct; final String explain;
const MCQItem({required this.prompt, required this.options, required this.correct, required this.explain}); }
class Vocab { final String term; final String meaning; final String example; const Vocab(this.term, this.meaning, this.example); }
class Formula { final String title; final String pattern; final List<String> examples;
const Formula({required this.title, required this.pattern, required this.examples}); }
class WordBank {
  const WordBank({
    required this.openers, required this.heads, required this.intensifiers,
    required this.targets, required this.reasons, required this.followups,
    required this.thanks, required this.appreciation, required this.modesty,
  });
  final List<String> openers, heads, intensifiers, targets, reasons, followups;
  final List<String> thanks, appreciation, modesty;
}

// ===== Helpers UI =====
Widget sectionTitle(String text, Color color) => Row(
  children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Text(text, style: primaryTextStyle.copyWith(fontWeight: FontWeight.bold)),
    ),
  ],
);

Widget tipCard(Tip tip, Color color) => Container(
  margin: const EdgeInsets.only(bottom: 10),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: color.withValues(alpha:0.25), width: 1),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
  ),
  child: ListTile(
    leading: Icon(Icons.info_outline, color: color),
    title: Text(tip.title, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
    subtitle: Text(tip.text, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800])),
  ),
);

Widget phraseCard(Phrase p, {required Color color, required AudioService audio, String audioUrl = kComplimentAudioUrl}) => Container(
  margin: const EdgeInsets.only(bottom: 10),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: color.withValues(alpha:0.25), width: 1),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
  ),
  child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(p.phrase, style: primaryTextStyle.copyWith(fontWeight: semiBold))),
            IconButton(
              tooltip: 'Play',
              onPressed: () => audio.playSound(audioUrl),
              icon: Icon(Icons.volume_up, color: color),
            ),
          ],
        ),
        if (p.ipa != null)
          Text(p.ipa!, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
        const SizedBox(height: 6),
        Text(p.note, style: primaryTextStyle.copyWith(fontSize: 12)),
        if (p.tags.isNotEmpty) ...[
          const SizedBox(height: 6),
          Wrap(
            spacing: 6, runSpacing: -6,
            children: [
              for (final t in p.tags)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha:0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha:0.25)),
                  ),
                  child: Text(t, style: primaryTextStyle.copyWith(fontSize: 12)),
                ),
            ],
          ),
        ],
      ],
    ),
  ),
);

Widget infoBadge({required IconData icon, required String text, Color? color}) {
  final c = color ?? Colors.indigo;
  return Container(
    margin: const EdgeInsets.only(top: 4, bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: c.withValues(alpha:0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: c.withValues(alpha:0.25), width: 1),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: c, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]))),
      ],
    ),
  );
}

Widget pickerRow(String label, Color color, List<String> options, ValueChanged<String> onPick, String current) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(label, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
    const SizedBox(height: 6),
    Wrap(
      spacing: 8, runSpacing: -6,
      children: [
        for (final o in options)
          ChoiceChip(
            label: Text(o),
            selected: current == o,
            onSelected: (_) => onPick(o),
            selectedColor: color.withValues(alpha:0.18),
          ),
      ],
    ),
    const SizedBox(height: 10),
  ],
);

Widget vocabGrid(List<Vocab> items, Color color) => GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.3,
  ),
  itemCount: items.length,
  itemBuilder: (context, i) {
    final v = items[i];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha:0.25)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(v.term, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
            const SizedBox(height: 2),
            Text(v.meaning, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800])),
            const Spacer(),
            Text('e.g. ${v.example}', style: primaryTextStyle.copyWith(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  },
);

Widget formulaCard(Formula f, Color color) => Container(
  margin: const EdgeInsets.only(bottom: 10),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: color.withValues(alpha:0.25)),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
  ),
  child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(f.title, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha:0.06),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha:0.2)),
          ),
          child: Text(f.pattern, style: primaryTextStyle.copyWith(fontSize: 12)),
        ),
        const SizedBox(height: 8),
        Text('Contoh:', style: primaryTextStyle.copyWith(fontWeight: semiBold)),
        const SizedBox(height: 4),
        for (final ex in f.examples)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(ex, style: primaryTextStyle.copyWith(fontSize: 12))),
              ],
            ),
          ),
      ],
    ),
  ),
);

Widget wordBankCard(WordBank wb, Color color) {
  Widget chips(String title, List<String> items) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
      const SizedBox(height: 6),
      Wrap(
        spacing: 8, runSpacing: -6,
        children: [
          for (final s in items)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha:0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha:0.25)),
              ),
              child: Text(s, style: primaryTextStyle.copyWith(fontSize: 12)),
            ),
        ],
      ),
      const SizedBox(height: 8),
    ],
  );

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha:0.25)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chips('Openers', wb.openers),
          chips('Compliment Heads', wb.heads),
          chips('Intensifiers/Softeners', wb.intensifiers),
          chips('Targets', wb.targets),
          chips('Reasons/Details', wb.reasons),
          chips('Follow-ups', wb.followups),
          const Divider(),
          chips('Thanks', wb.thanks),
          chips('Appreciation', wb.appreciation),
          chips('Modesty/Credit', wb.modesty),
        ],
      ),
    ),
  );
}
