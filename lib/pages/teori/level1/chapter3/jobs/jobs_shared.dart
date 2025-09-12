import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kJobsAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip { final String title; final String text; const Tip(this.title, this.text); }

class JobVocab {
  final String term;       // EN
  final String indo;       // ID
  final String category;   // healthcare/education/tech/service/creative/public/business/trade/transport/law
  final String example;    // contoh EN
  final String? ipa;       // optional
  final String? audio;     // optional
  final String? imageAsset;// optional path (assets/images/jobs/xxx.png)
  const JobVocab({
    required this.term,
    required this.indo,
    required this.category,
    required this.example,
    this.ipa,
    this.audio,
    this.imageAsset,
  });
}

class MCQItem {
  final String prompt;
  final List<String> options;
  final int correct;
  final String explain;
  const MCQItem({required this.prompt, required this.options, required this.correct, required this.explain});
}

class Pair { final String left; final String right; final String explain; const Pair({required this.left, required this.right, required this.explain}); }
class Choice { final int id; final String text; final String key; const Choice({required this.id, required this.text, required this.key}); }

/// ===== Categories =====
const _HC = 'healthcare', _ED = 'education', _TE = 'tech', _SE = 'service', _CR = 'creative',
    _PS = 'public', _BU = 'business', _TR = 'trade', _TP = 'transport', _LW = 'law';
final List<String> kJobsCategories = const [_HC, _ED, _TE, _SE, _CR, _PS, _BU, _TR, _TP, _LW];

/// ===== Vocabulary (isi imageAsset sesuai aset kamu) =====
final List<JobVocab> kJobsVocab = [
  JobVocab(term: 'teacher', indo: 'guru', category: _ED, example: 'My mother is a teacher.', ipa: '/ˈtiːtʃə/', imageAsset: 'assets/images/jobs/teacher.png'),
  JobVocab(term: 'student', indo: 'siswa/mahasiswa', category: _ED, example: 'She is a university student.', ipa: '/ˈstjuːdənt/', imageAsset: 'assets/images/jobs/student.png'),
  JobVocab(term: 'doctor', indo: 'dokter', category: _HC, example: 'The doctor works at a hospital.', ipa: '/ˈdɒktə/', imageAsset: 'assets/images/jobs/doctor.png'),
  JobVocab(term: 'nurse', indo: 'perawat', category: _HC, example: 'The nurse is very kind.', ipa: '/nɜːs/', imageAsset: 'assets/images/jobs/nurse.png'),
  JobVocab(term: 'dentist', indo: 'dokter gigi', category: _HC, example: 'I will see the dentist tomorrow.', ipa: '/ˈdɛntɪst/', imageAsset: 'assets/images/jobs/dentist.png'),
  JobVocab(term: 'pharmacist', indo: 'apoteker', category: _HC, example: 'Ask the pharmacist for advice.', ipa: '/ˈfɑːməsɪst/', imageAsset: 'assets/images/jobs/pharmacist.png'),
  JobVocab(term: 'engineer', indo: 'insinyur', category: _TE, example: 'My brother is a software engineer.', ipa: '/ˌendʒɪˈnɪə/', imageAsset: 'assets/images/jobs/engineer.png'),
  JobVocab(term: 'programmer', indo: 'pemrogram', category: _TE, example: 'He works as a programmer.', ipa: '/ˈprəʊɡræmə/', imageAsset: 'assets/images/jobs/programmer.png'),
  JobVocab(term: 'designer', indo: 'desainer', category: _CR, example: 'She is a graphic designer.', ipa: '/dɪˈzaɪnə/', imageAsset: 'assets/images/jobs/designer.png'),
  JobVocab(term: 'artist', indo: 'seniman', category: _CR, example: 'The artist paints every day.', ipa: '/ˈɑːtɪst/', imageAsset: 'assets/images/jobs/artist.png'),
  JobVocab(term: 'musician', indo: 'musisi', category: _CR, example: 'He is a jazz musician.', ipa: '/mjuːˈzɪʃn/', imageAsset: 'assets/images/jobs/musician.png'),
  JobVocab(term: 'chef', indo: 'koki', category: _SE, example: 'The chef works in a restaurant.', ipa: '/ʃɛf/', imageAsset: 'assets/images/jobs/chef.png'),
  JobVocab(term: 'waiter', indo: 'pelayan (laki-laki)', category: _SE, example: 'The waiter took our order.', ipa: '/ˈweɪtə/', imageAsset: 'assets/images/jobs/waiter.png'),
  JobVocab(term: 'waitress', indo: 'pelayan (perempuan)', category: _SE, example: 'The waitress is friendly.', ipa: '/ˈweɪtrəs/', imageAsset: 'assets/images/jobs/waitress.png'),
  JobVocab(term: 'police officer', indo: 'polisi', category: _PS, example: 'A police officer helped us.', ipa: '/pəˈliːs ˌɒfɪsə/', imageAsset: 'assets/images/jobs/police.png'),
  JobVocab(term: 'firefighter', indo: 'pemadam kebakaran', category: _PS, example: 'Firefighters are brave.', ipa: '/ˈfaɪəˌfaɪtə/', imageAsset: 'assets/images/jobs/firefighter.png'),
  JobVocab(term: 'pilot', indo: 'pilot', category: _TP, example: 'The pilot flew the plane safely.', ipa: '/ˈpaɪlət/', imageAsset: 'assets/images/jobs/pilot.png'),
  JobVocab(term: 'flight attendant', indo: 'pramugari/a', category: _TP, example: 'The flight attendant smiled.', ipa: '/ˈflaɪt əˌtendənt/', imageAsset: 'assets/images/jobs/attendant.png'),
  JobVocab(term: 'driver', indo: 'sopir', category: _TP, example: 'The bus driver is careful.', ipa: '/ˈdraɪvə/', imageAsset: 'assets/images/jobs/driver.png'),
  JobVocab(term: 'farmer', indo: 'petani', category: _TR, example: 'Farmers grow crops.', ipa: '/ˈfɑːmə/', imageAsset: 'assets/images/jobs/farmer.png'),
  JobVocab(term: 'mechanic', indo: 'montir', category: _TR, example: 'The mechanic fixed my car.', ipa: '/mɪˈkænɪk/', imageAsset: 'assets/images/jobs/mechanic.png'),
  JobVocab(term: 'electrician', indo: 'tukang listrik', category: _TR, example: 'Call an electrician.', ipa: '/ɪˌlekˈtrɪʃn/', imageAsset: 'assets/images/jobs/electrician.png'),
  JobVocab(term: 'plumber', indo: 'tukang pipa', category: _TR, example: 'We need a plumber.', ipa: '/ˈplʌmə/', imageAsset: 'assets/images/jobs/plumber.png'),
  JobVocab(term: 'carpenter', indo: 'tukang kayu', category: _TR, example: 'The carpenter made a table.', ipa: '/ˈkɑːpɪntə/', imageAsset: 'assets/images/jobs/carpenter.png'),
  JobVocab(term: 'architect', indo: 'arsitek', category: _BU, example: 'She is an architect.', ipa: '/ˈɑːkɪtekt/', imageAsset: 'assets/images/jobs/architect.png'),
  JobVocab(term: 'accountant', indo: 'akuntan', category: _BU, example: 'The accountant checks the books.', ipa: '/əˈkaʊntənt/', imageAsset: 'assets/images/jobs/accountant.png'),
  JobVocab(term: 'banker', indo: 'bankir', category: _BU, example: 'He works as a banker.', ipa: '/ˈbæŋkə/', imageAsset: 'assets/images/jobs/banker.png'),
  JobVocab(term: 'cashier', indo: 'kasir', category: _SE, example: 'The cashier gave me change.', ipa: '/kæˈʃɪə/', imageAsset: 'assets/images/jobs/cashier.png'),
  JobVocab(term: 'businessperson', indo: 'pebisnis', category: _BU, example: 'She is a successful businessperson.', ipa: '/ˈbɪznɪsˌpɜːsn/', imageAsset: 'assets/images/jobs/business.png'),
  JobVocab(term: 'lawyer', indo: 'pengacara', category: _LW, example: 'The lawyer explained the case.', ipa: '/ˈlɔːjə/', imageAsset: 'assets/images/jobs/lawyer.png'),
  JobVocab(term: 'judge', indo: 'hakim', category: _LW, example: 'The judge made a decision.', ipa: '/dʒʌdʒ/', imageAsset: 'assets/images/jobs/judge.png'),
  JobVocab(term: 'soldier', indo: 'prajurit', category: _PS, example: 'He is a soldier.', ipa: '/ˈsəʊldʒə/', imageAsset: 'assets/images/jobs/soldier.png'),
  JobVocab(term: 'journalist', indo: 'jurnalis', category: _CR, example: 'The journalist wrote an article.', ipa: '/ˈdʒɜːnəlɪst/', imageAsset: 'assets/images/jobs/journalist.png'),
  JobVocab(term: 'photographer', indo: 'fotografer', category: _CR, example: 'She is a photographer.', ipa: '/fəˈtɒɡrəfə/', imageAsset: 'assets/images/jobs/photographer.png'),
  JobVocab(term: 'writer', indo: 'penulis', category: _CR, example: 'He is a fiction writer.', ipa: '/ˈraɪtə/', imageAsset: 'assets/images/jobs/writer.png'),
  JobVocab(term: 'scientist', indo: 'ilmuwan', category: _TE, example: 'Scientists do research.', ipa: '/ˈsaɪəntɪst/', imageAsset: 'assets/images/jobs/scientist.png'),
];

/// ===== Helpers UI =====
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

Widget infoBadge({required IconData icon, required String text, Color? color}) {
  final c = color ?? Colors.indigo;
  return Container(
    margin: const EdgeInsets.only(top: 4, bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: c.withValues(alpha:0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: c.withValues(alpha:0.25)),
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

Widget tipCard(Tip tip, Color color) => Container(
  margin: const EdgeInsets.only(bottom: 10),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: color.withValues(alpha:0.25)),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
  ),
  child: ListTile(
    leading: Icon(Icons.info_outline, color: color),
    title: Text(tip.title, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
    subtitle: Text(tip.text, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800])),
  ),
);

Widget vocabTile(JobVocab v, {Color color = Colors.teal, AudioService? audio}) {
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (v.imageAsset != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Image.asset(
                  v.imageAsset!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  ),
                ),
              ),
            ),
          if (v.imageAsset != null) const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(v.term, style: primaryTextStyle.copyWith(fontWeight: semiBold),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              if (audio != null)
                IconButton(
                  tooltip: 'Play',
                  onPressed: () => audio.playSound(v.audio ?? kJobsAudioUrl),
                  icon: Icon(Icons.volume_up, color: color, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          Text(v.indo, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          if (v.ipa != null)
            Text(v.ipa!, style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(v.example, style: primaryTextStyle.copyWith(fontSize: 12), maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
  );
}

/// Utility
List<JobVocab> byCat(String cat) => kJobsVocab.where((e) => e.category == cat).toList();
T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
