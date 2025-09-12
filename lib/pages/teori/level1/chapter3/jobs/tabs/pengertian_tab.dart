import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/level1/chapter3/jobs/jobs_shared.dart';

class JobsPengertianTab extends StatelessWidget {
  const JobsPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    const tips = [
      Tip('Perbedaan “Job” vs “Profession”',
          'Job: pekerjaan/posisi yang menghasilkan uang (kadang sementara). '
              'Profession: karier berbasis keahlian/pendidikan formal (dokter, arsitek).'),
      Tip('Fungsi',
          'Memperkenalkan diri/ orang lain, menulis profil kerja, dan berbicara tentang tempat/ bidang pekerjaan.'),
      Tip('Topik Aman',
          'Gunakan pertanyaan umum seperti “What do you do?” atau “Where do you work?” sebelum detail sensitif (gaji, jabatan spesifik).'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Konsep Dasar', Colors.blue),
          const SizedBox(height: 8),
          for (final t in tips) tipCard(t, Colors.blue),
          const SizedBox(height: 16),
          infoBadge(icon: Icons.lightbulb_outline, text: 'Gunakan artikel a/an: a doctor, an engineer. “Work as” untuk jabatan, “work at/in” untuk tempat/bidang.'),
        ],
      ),
    );
  }
}
