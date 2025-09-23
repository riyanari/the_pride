import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:the_pride/models/reward_model.dart';
import '../../../theme/theme.dart';

class RewardTail extends StatelessWidget {
  final RewardModel reward;

  const RewardTail({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      width: double.infinity,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bagian gambar
          Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: -15 * math.pi / 180, // rotasi 15 derajat searah jarum jam
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                ),
              ),
              Image.asset(
                reward.imagePath.isNotEmpty ? reward.imagePath : "assets/no_img.png",
                height: 90,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // fallback kalau file benar-benar tidak ada
                  return Image.asset(
                    "assets/no_img.png",
                    height: 80,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ],
          ),

          // Container(
          //   height: 90,
          //   width: 90,
          //   margin: const EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //     color: kWhiteColor,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Center(
          //     child: Image.asset(
          //       reward.imagePath.isNotEmpty
          //           ? reward.imagePath
          //           : "assets/no_img.png",
          //       height: 60,
          //       fit: BoxFit.contain,
          //       errorBuilder: (context, error, stackTrace) {
          //         return Image.asset(
          //           "assets/no_img.png",
          //           height: 60,
          //           fit: BoxFit.contain,
          //         );
          //       },
          //     ),
          //   ),
          // ),
          SizedBox(width: 10,),

          // Bagian teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama reward
                Text(
                  reward.name,
                  style: whiteTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: bold,
                  ),
                ),
                const SizedBox(height: 4),

                // Deskripsi singkat
                Text(
                  reward.description,
                  style: whiteTextStyle.copyWith(fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Poin + Tombol Tukar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${reward.points} Pts",
                      style: whiteTextStyle.copyWith(fontSize: 12),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        "Tukar",
                        style: whiteTextStyle.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
