import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

// pastikan import style, warna, dll sesuai project kamu

class CourseTile extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseTile({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final progress = course['progress'] as int;
    final isCompleted = progress == 100;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, course['nav']);
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: kBoxGreyColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(8, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar kursus
                Stack(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        color: kBackgroundPrimaryColor,
                        image: DecorationImage(
                          image: AssetImage(course['image']),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    if (isCompleted)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),

                // Konten teks & progress
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  course['level'],
                                  style: whiteTextStyle.copyWith(fontSize: 8),
                                ),
                                Text(
                                  course['kd_kelas'],
                                  style: whiteTextStyle.copyWith(fontSize: 8),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              course['name'],
                              style: whiteTextStyle.copyWith(
                                fontSize: 10,
                                fontWeight: semiBold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),

                        isCompleted
                            ? Container(
                          padding:
                          const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 12),
                              SizedBox(width: 4),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                            : Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                value: progress / 100,
                                backgroundColor: kWhiteColor,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    kSecondaryColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$progress%',
                              style: whiteTextStyle.copyWith(
                                fontSize: 10,
                                fontWeight: semiBold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
