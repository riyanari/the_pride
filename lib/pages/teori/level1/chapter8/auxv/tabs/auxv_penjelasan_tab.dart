import 'package:flutter/material.dart';
import '../auxv_shared.dart';

class AuxVPenjelasanTab extends StatelessWidget {
  const AuxVPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Fungsi & Pola', Colors.indigo),
          const SizedBox(height: 8),
          infoBadge(
            icon: Icons.rule,
            text: 'BE: nominal (is/are), progressive (am/is/are V-ing), passive (is/are V3).\n'
                'DO: bantu present/past simple untuk tanya/negatif.\n'
                'HAVE: perfect (have/has/had + V3).',
          ),
          const SizedBox(height: 12),
          sectionTitle('Pertanyaan', Colors.orange),
          const SizedBox(height: 8),
          infoBadge(
            icon: Icons.help_outline,
            text: '• Do you like coffee?\n• Does she work here?\n• Did you see it?\n• Are they ready?\n• Have you finished?',
          ),
          const SizedBox(height: 12),
          sectionTitle('Negatif', Colors.green),
          const SizedBox(height: 8),
          infoBadge(
            icon: Icons.remove_circle_outline,
            text: '• I do not (don’t) know.\n• He does not (doesn’t) like it.\n• They were not (weren’t) late.\n• She has not (hasn’t) arrived.',
          ),
        ],
      ),
    );
  }
}
