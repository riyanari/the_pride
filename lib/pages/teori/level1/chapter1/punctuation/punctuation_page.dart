import 'package:flutter/material.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:the_pride/components/custom_page_view.dart';

import 'punctuation1_tab.dart';
import 'puntuation2_tab.dart';

/// PunctuationPage
/// Versi **HALAMAN** (bukan tab) untuk pembelajaran tanda baca.
/// Memuat: kategori tanda baca, ringkasan aturan & contoh (BE/AE),
/// serta quick quiz dengan skor dan feedback.
class PunctuationPage extends StatefulWidget {
  const PunctuationPage({super.key});

  @override
  State<PunctuationPage> createState() => _PunctuationPageState();
}

class _PunctuationPageState extends State<PunctuationPage> {
  @override
  Widget build(BuildContext context) {
    final List<String> _pageTitles = ['Punctuation 1', 'Punctuation 2'];

    return Scaffold(
      appBar: CustomAppBar("Punctuation", iconSize: 16.0),
      body: CustomPageView(
        pageTitles: _pageTitles,
        pages: [PunctuationSymbolQuizTab(), Punctuation1Tab()],
        onFinish: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
