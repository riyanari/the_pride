import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'components/course_tail.dart';

class TeoriPage extends StatelessWidget {
  const TeoriPage({super.key});

  List<Map<String, dynamic>> dataKursusDiikuti() {
    return [
      {
        'image': 'assets/level1_page.png',
        'level': 'Level 1',
        'name': 'Page (The Beginner)',
        'kd_kelas': 'ENG-101',
        'progress': 100,
        'nav': 'level1_page',
      },
      {
        'image': 'assets/level2_squire.png',
        'level': 'Level 2',
        'name': 'Squire (The Apprentice)',
        'kd_kelas': 'ENG-201',
        'progress': 40, // 35% (integer)
        'nav': 'level2_squire',
      },
      {
        'image': 'assets/level3_knight.png',
        'level': 'Level 3',
        'name': 'Knight (The Skilled Warrior)',
        'kd_kelas': 'ENG-301',
        'progress': 0, // 0% (integer)
        'nav': 'level3_knight',
      },
      {
        'image': 'assets/level4_lord.png',
        'level': 'Level 4',
        'name': 'Lord / Grandmaster Knight (The Master of Language)',
        'kd_kelas': 'ENG-401',
        'progress': 0, // 0% (integer)
        'nav': 'level4_lord',
      },
    ];
  }

  List<Map<String, dynamic>> dataSemuaKursus() {
    return [
      {
        'image': 'assets/level1_page.png',
        'level': 'Level 1',
        'name': 'Page (The Beginner)',
      },
      {
        'image': 'assets/level2_squire.png',
        'level': 'Level 2',
        'name': 'Squire (The Apprentice)',
      },
      {
        'image': 'assets/level3_knight.png',
        'level': 'Level 3',
        'name': 'Knight (The Skilled Warrior)',
      },
      {
        'image': 'assets/level4_lord.png',
        'level': 'Level 4',
        'name': 'Lord / Grandmaster Knight (The Master of Language)',
      },
      {
        'image': 'assets/toefl.png',
        'level': '',
        'name': 'Toefl',
      },
      {
        'image': 'assets/toeic.png',
        'level': '',
        'name': 'Toeic',
      },
      {
        'image': 'assets/ielts.png',
        'level': '',
        'name': 'Ielts',
      },
      {
        'image': 'assets/duolingo.png',
        'level': '',
        'name': 'Duolingo Preparation Test',
      },
    ];
  }

  Widget header(){
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kBackgroundPrimaryColor,
          ),
          child: Image.asset("assets/lion_logo.png", height: 20, width: 20),
        ),
        SizedBox(width: 10,),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, Riyan!",
              style: primaryTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: semiBold
              ),
            ),
            Text(
              "Mau belajar apa hari ini?",
              style: primaryTextStyle.copyWith(
                fontSize: 12,
              ),
            )
          ],
        ),
        Spacer(),
        Icon(Icons.notifications_none_sharp, size: 30, color: kPrimaryColor,)
      ],
    );
  }

  Widget kursusDiikuti() {
    final courses = dataKursusDiikuti();
    // final repo = CourseRepository();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kursus yang diikuti",
          style: primaryTextStyle.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return CourseTile(course: courses[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget allKursus(){
    final allCourses = dataSemuaKursus();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Semua kursus",
          style: primaryTextStyle.copyWith(
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.92,
          ),
          itemCount: allCourses.length,
          itemBuilder: (context, index) {
            final course = allCourses[index];
            final String level = (course['level'] as String?)?.trim() ?? '';
            final String name  = (course['name'] as String?)?.trim() ?? '';
            final bool hasLevel = level.isNotEmpty;

            // Tentukan warna berdasarkan kolom (kiri/kanan)
            // Index genap: kolom kiri, Index ganjil: kolom kanan
            const crossAxisCount = 2;      // karena grid kamu 2 kolom
            final row = index ~/ crossAxisCount;
            final col = index % crossAxisCount;

            // Baris genap: [abu, sekunder], baris ganjil: [sekunder, abu]
            final backgroundColor = (row.isEven)
                ? (col == 0 ? kBoxGreyColor : kSecondaryColor)
                : (col == 0 ? kSecondaryColor : kBoxGreyColor);

            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar kursus
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.22,
                        width: MediaQuery.of(context).size.width * 0.22,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                          ),
                          color: kBackgroundPrimaryColor,
                          image: DecorationImage(
                            image: AssetImage(course['image']),
                            fit: BoxFit.fill,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xffc9c9c9),
                              blurRadius: 10,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset("assets/lock.png"),
                      )
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Konten teks
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Level (jika ada)
                            Text(
                              hasLevel ? level : name,
                              style: whiteTextStyle.copyWith(
                                fontSize: 10,
                                fontWeight: medium,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Nama kursus
                            Text(
                              course['name'],
                              style: whiteTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: semiBold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset("assets/ic_right.png", height: 20),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                const SizedBox(height: 24),
                kursusDiikuti(),
                allKursus(),

              ],
            ),
          ),
        ),
      )
    );
  }
}
