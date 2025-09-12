import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/level1/chapter3/jobs/jobs_shared.dart';

class JobsPenjelasanTab extends StatelessWidget {
  const JobsPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      Tip('Rumus Dasar',
          '• I am a/an + job: “I am a teacher.”\n'
              '• He/She is a/an + job: “She is an engineer.”\n'
              '• Work as + job: “He works as a designer.”\n'
              '• Work at/in + place/field: “She works at a bank / in education.”'),
      Tip('a vs an',
          'Gunakan “an” sebelum bunyi vokal: an engineer, an artist; “a” sebelum bunyi konsonan: a nurse, a teacher.'),
      Tip('Plural',
          'Tambahkan -s/-es: teachers, nurses. Professions tidak memakai artikel saat jamak umum: “Doctors save lives.”'),
      Tip('Verb Agreement',
          'Pakai -s untuk he/she/it: “She works”, “He teaches”.'),
      Tip('Tanya Jawab',
          'Q: What do you do? A: I am a programmer.\n'
              'Q: Where do you work? A: I work at a hospital.\n'
              'Q: What field are you in? A: I am in education/tech.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Penjelasan & Rumus', Colors.purple),
          const SizedBox(height: 8),
          for (final t in items) tipCard(t, Colors.purple),
          const SizedBox(height: 16),
          infoBadge(icon: Icons.tips_and_updates, text: '“Profession” sering memerlukan lisensi/pendidikan (doctor, architect, lawyer). “Job” bisa lebih luas & fleksibel.'),
        ],
      ),
    );
  }
}
