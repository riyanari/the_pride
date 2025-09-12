import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

class PronunciationTestPage extends StatefulWidget {
  const PronunciationTestPage({super.key});

  @override
  State<PronunciationTestPage> createState() => _PronunciationTestPageState();
}

class _PronunciationTestPageState extends State<PronunciationTestPage> {
  final AudioService _audioService = AudioService();
  final List<String> _userAnswers = List.filled(5, '');
  final List<TextEditingController> _controllers = List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());
  bool _showResults = false;

  // Data untuk soal tes
  final List<Map<String, dynamic>> _questions = [
    {
      'audio': 'zebra_audio.mp3',
      'phoneticBE': "ðıs 'zeb.rə hæz bi:n bə:t baı ðə zu:",
      'phoneticAE': "ðıs 'zi:.brə hæz bi:n ba:t baı ðə zu:",
      'correctAnswer': "This zebra has been bought by the zoo",
      'hint': "Binatang belang yang digigit di kebun binatang"
    },
    {
      'audio': 'color_audio.mp3',
      'phoneticBE': "red ız mai fer.vr.ıt 'kʌl.ə",
      'phoneticAE': "red ız mai 'feɪ.vr.ət 'kʌl.ɚ",
      'correctAnswer': "Red is my favorite color",
      'hint': "Warna primer yang paling disukai"
    },
    {
      'audio': 'beer_audio.mp3',
      'phoneticBE': "ði: 'ɪŋ.glɪʃ drɪŋk ə lɒt əv bɪə",
      'phoneticAE': "ði: 'ɪŋ.glɪʃ drɪŋk ə lɑ:t əv bɪr",
      'correctAnswer': "The English drink a lot of beer",
      'hint': "Kebiasaan minum orang Inggris"
    },
    {
      'audio': 'runner_audio.mp3',
      'phoneticBE': "ðə 'rʌn.ə krɒst ðə 'fɪ.nɪʃ laɪn",
      'phoneticAE': "ðə 'rʌn.ɚ krɑ:st ðə 'fɪ.nɪʃ laɪn",
      'correctAnswer': "The runner crossed the finish line",
      'hint': "Pelari yang mencapai garis akhir"
    },
    {
      'audio': 'plane_audio.mp3',
      'phoneticBE': "aɪ left 'sʌm.wʌn ɒn ðə pleɪn",
      'phoneticAE': "aɪ left 'sʌm.wʌn ɑ:n ðə pleɪn",
      'correctAnswer': "I left someone on the plane",
      'hint': "Meninggalkan seseorang di pesawat"
    },
  ];

  @override
  void initState() {
    super.initState();
    // Setup focus nodes untuk beralih ke field berikutnya
    for (int i = 0; i < _focusNodes.length - 1; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && _userAnswers[i].isNotEmpty) {
          FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _checkAnswers() {
    setState(() {
      _showResults = true;
    });
  }

  void _resetTest() {
    setState(() {
      _showResults = false;
      for (var controller in _controllers) {
        controller.clear();
      }
      _userAnswers.fillRange(0, _userAnswers.length, '');
    });
  }

  Widget _buildQuestion(int index) {
    final question = _questions[index];
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan nomor soal
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tulislah ortografi dari pelafalan berikut:',
                  style: primaryTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Pelafalan British
          Text(
            'British Pronunciation:',
            style: primaryTextStyle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            question['phoneticBE'],
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),

          // Pelafalan American
          Text(
            'American Pronunciation:',
            style: primaryTextStyle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            question['phoneticAE'],
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),

          // Hint
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kSecondaryColor.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, size: 18, color: kSecondaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hint: ${question['hint']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tombol putar audio
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _audioService.playSound(question['audio']),
              icon: Icon(Icons.volume_up, size: 18),
              label: Text('Dengarkan Pelafalan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Input jawaban
          TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            onChanged: (value) {
              setState(() {
                _userAnswers[index] = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Tulisan ortografi',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 8),

          // Tampilkan hasil jika sudah selesai
          if (_showResults) ...[
            const SizedBox(height: 16),
            Text(
              'Jawaban Benar:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              question['correctAnswer'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _userAnswers[index].toLowerCase() == question['correctAnswer'].toLowerCase()
                  ? '✅ Benar!'
                  : '❌ Masih perlu latihan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _userAnswers[index].toLowerCase() == question['correctAnswer'].toLowerCase()
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResults() {
    int correctAnswers = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i].toLowerCase() == _questions[i]['correctAnswer'].toLowerCase()) {
        correctAnswers++;
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            correctAnswers == _questions.length ? Icons.celebration : Icons.auto_awesome,
            size: 64,
            color: correctAnswers == _questions.length ? Colors.amber : kPrimaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            'Hasil Tes Pelafalan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Anda menjawab $correctAnswers dari ${_questions.length} soal dengan benar',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (correctAnswers == _questions.length)
            Text(
              'Selamat! Pengucapan dan penulisan Anda sangat baik!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          else if (correctAnswers >= _questions.length / 2)
            Text(
              'Bagus! Teruslah berlatih untuk meningkatkan kemampuan.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            )
          else
            Text(
              'Jangan menyerah! Pelafalan bahasa Inggris butuh latihan terus-menerus.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _resetTest,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar("Tes Pelafalan dan Ortografi", iconSize: 16.0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Instruksi tes
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Instruksi:',
                            style: primaryTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Dengarkan pelafalan dan lihat notasi fonetik, kemudian tuliskan ejaan yang benar dalam bahasa Inggris. Setelah selesai, klik "Periksa Jawaban" untuk melihat hasil.',
                            style: primaryTextStyle,
                          ),
                        ],
                      ),
                    ),

                    // Daftar soal
                    if (!_showResults)
                      ...List.generate(_questions.length, (index) => _buildQuestion(index))
                    else
                      _buildResults(),
                  ],
                ),
              ),
            ),

            // Tombol periksa jawaban
            if (!_showResults)
              Container(
                padding: const EdgeInsets.only(top: 16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    bool allAnswered = _userAnswers.every((answer) => answer.isNotEmpty);
                    if (allAnswered) {
                      _checkAnswers();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Harap jawab semua soal terlebih dahulu'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Periksa Jawaban'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}