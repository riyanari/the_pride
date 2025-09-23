import 'package:flutter/material.dart';
import 'package:the_pride/models/reward_model.dart';

import '../../../theme/theme.dart';

class FavoriteRewardTail extends StatelessWidget {
  final RewardModel reward;

  const FavoriteRewardTail({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      // margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: kBoxGreyColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.35),
            blurRadius: 8,
            offset: const Offset(8, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian gambar dengan background putih
          Stack(
            alignment: Alignment.center,
            children: [
              // Container putih hanya di belakang gambar
              Container(
                margin: const EdgeInsets.only(bottom: 45, left: 17, right: 17),
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              // Gambar baju
              Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  reward.imagePath.isNotEmpty ? reward.imagePath : "assets/no_img.png",
                  height: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // fallback kalau file benar-benar tidak ada
                    return Image.asset(
                      "assets/no_img.png",
                      height: 140,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),

            ],
          ),

          // Judul produk
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              reward.name,
              style: whiteTextStyle.copyWith(fontSize: 12, fontWeight: bold),
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "${reward.sold} Terjual",
              style: whiteTextStyle.copyWith(
                fontSize: 8,
                fontWeight: regular, // kalau ada di theme kamu
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Bagian poin + tombol
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset("assets/ic_coin_white.png", width: 14),
                    const SizedBox(width: 4),
                    Text(
                      "${reward.points} Pts",
                      style: whiteTextStyle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Image.asset("assets/ic_keranjang.png", width: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
