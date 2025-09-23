// pages/checkout_success_page.dart
import 'package:flutter/material.dart';
import 'package:the_pride/models/reward_model.dart';
import 'package:the_pride/theme/theme.dart';

class CheckoutSuccessPage extends StatelessWidget {
  final RewardModel reward;
  final String specification;
  final int quantity;
  final int totalPoints;

  const CheckoutSuccessPage({
    super.key,
    required this.reward,
    required this.specification,
    required this.quantity,
    required this.totalPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon sukses
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha:0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 24),

              // Judul sukses
              Text(
                'Penukaran Berhasil!',
                style: primaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Reward Anda sedang diproses',
                style: primaryTextStyle.copyWith(
                  color: kGreyColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Detail reward
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha:0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Gambar reward
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(reward.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      reward.name,
                      style: primaryTextStyle.copyWith(
                        fontWeight: bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Spesifikasi: $specification',
                      style: primaryTextStyle.copyWith(fontSize: 12),
                    ),
                    Text(
                      'Jumlah: $quantity',
                      style: primaryTextStyle.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/ic_coins_black.png", height: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$totalPoints Pts',
                          style: primaryTextStyle.copyWith(
                            fontWeight: bold,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Informasi estimasi
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '📦 Estimasi Pengiriman',
                      style: primaryTextStyle.copyWith(
                        fontWeight: bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Reward akan dikirim dalam 3-5 hari kerja',
                      style: primaryTextStyle.copyWith(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Tombol-tombol aksi
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Kembali ke halaman utama
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/main',
                                (route) => false
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Kembali ke Beranda',
                        style: whiteTextStyle.copyWith(
                          fontWeight: bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // Lihat riwayat penukaran
                      Navigator.pushNamed(context, '/exchange-history');
                    },
                    child: Text(
                      'Lihat Riwayat Penukaran',
                      style: primaryTextStyle.copyWith(
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}