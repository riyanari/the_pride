import 'package:flutter/material.dart';
import '../gesture_shared.dart';

class GesturePenjelasanTab extends StatelessWidget {
  const GesturePenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    const struktur = [
      Tip('Kategori Umum', 'positive (apresiasi), negative (penolakan), neutral (informasi), greeting (sapaan), cultural (khusus budaya).'),
      Tip('Etika', 'Perhatikan jarak, kontak mata, ekspresi; hindari menunjuk langsung atau gesture agresif.'),
      Tip('Konteks', 'Formal (jabat tangan ringan), informal (high-five/fist bump), lintas budaya (bow).'),
      Tip('Kombinasi Verbal', 'Padukan dengan frasa singkat: “Nice to meet you” + handshake, “Thanks” + nod.'),
    ];
    const doDont = [
      Tip('Do', 'Senyum, angguk ringan, kontak mata secukupnya, lambaian ramah.'),
      Tip('Don’t', 'Menunjuk orang, “OK sign” tanpa tahu budaya, menyilangkan tangan ketika menerima feedback.'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Struktur & Prinsip', Colors.purple),
          const SizedBox(height: 8),
          for (final t in struktur) tipCard(t, Colors.purple),
          const SizedBox(height: 16),
          sectionTitle('Do & Don’t', Colors.orange),
          const SizedBox(height: 8),
          for (final t in doDont) tipCard(t, Colors.orange),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.public, text: 'Catatan budaya: “OK sign” dapat ofensif di sebagian negara; gesture V (punggung tangan keluar) ofensif di UK/Australia.'),
        ],
      ),
    );
  }
}
