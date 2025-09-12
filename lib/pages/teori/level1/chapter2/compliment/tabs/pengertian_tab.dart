import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';

import '../compliment_shared.dart';

class PengertianTab extends StatelessWidget {
  const PengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();

    final tips = const [
      Tip('Definisi', 'Compliment adalah pujian/ungkapan apresiasi untuk kualitas, performa, kepemilikan, atau usaha seseorang.'),
      Tip('Tujuan', 'Membangun keakraban, memotivasi, dan menjaga hubungan sosial dengan sopan.'),
      Tip('Konteks & Budaya', 'Pilih topik aman (usaha/kerja/hasil). Hindari yang sensitif (fisik/pribadi) jika belum akrab.'),
      Tip('Nada & Gesture', 'Senyum, kontak mata, dan intonasi yang hangat membantu ketulusan.'),
    ];

    final examples = const [
      Phrase(
        phrase: 'Great job on your presentation!',
        ipa: '/ɡreɪt dʒɒb ɒn jɔː ˌprɛzənˈteɪʃn̩/',
        note: 'Fokus pada hasil kerja (aman & profesional).',
        tags: ['work', 'safe topic'],
      ),
      Phrase(
        phrase: 'I love your idea. It\'s so creative.',
        ipa: '/aɪ lʌv jɔːr aɪˈdɪə | ɪts soʊ kriːˈeɪtɪv/',
        note: 'Tambahkan alasan/spesifik agar terdengar tulus.',
        tags: ['specific', 'positive'],
      ),
      Phrase(
        phrase: 'That was very kind of you to help.',
        ipa: '/ðæt wəz ˈvɛri kaɪnd əv juː tə hɛlp/',
        note: 'Apresiasi perilaku/karakter.',
        tags: ['character'],
      ),
    ];

    final vocab = const [
      Vocab('compliment', 'pujian', 'Thanks for the compliment!'),
      Vocab('sincere', 'tulus', 'A sincere compliment feels natural.'),
      Vocab('appreciate', 'menghargai/mengapresiasi', 'I really appreciate your help.'),
      Vocab('give credit', 'memberi kredit', 'Let\'s give credit to the whole team.'),
      Vocab('effort', 'usaha', 'I admire your effort.'),
      Vocab('impressive', 'mengagumkan', 'Your design is impressive.'),
      Vocab('polite', 'sopan', 'Use polite tone and body language.'),
      Vocab('follow-up', 'tindak lanjut', 'Add a friendly follow-up after thanking.'),
      Vocab('register', 'tingkat keformalan', 'Choose the right register for the context.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Konsep Dasar', Colors.blue),
          const SizedBox(height: 8),
          for (final t in tips) tipCard(t, Colors.blue),
          const SizedBox(height: 16),
          sectionTitle('Contoh Ungkapan', Colors.green),
          const SizedBox(height: 8),
          for (final p in examples) phraseCard(p, color: Colors.green, audio: audio, audioUrl: kComplimentAudioUrl),
          const SizedBox(height: 16),
          sectionTitle('Kosakata Kunci', Colors.indigo),
          const SizedBox(height: 8),
          vocabGrid(vocab, Colors.indigo),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.lightbulb_outline, text: 'Jaga ketulusan: sebutkan detail/alasannya ("because/what I like is…").'),
        ],
      ),
    );
  }
}
