import 'package:flutter/material.dart';

import '../../theme/theme.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kursus yang diikuti",
          style: primaryTextStyle.copyWith(
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final course = courses[index];
              final progress = course['progress'] as int;
              final isCompleted = progress == 100;
              // final isLocked = progress == 0;

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, course['nav']);
                },
                child: Container(
                  width: 170,
                  margin: EdgeInsets.only(bottom: 20),
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
                          // Gambar kursus dengan badge completed jika 100%
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
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          // Konten teks dan progress bar
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Bagian atas: level, nama, kode kelas
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            course['level'],
                                            style: whiteTextStyle.copyWith(
                                              fontSize: 8,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            course['kd_kelas'],
                                            style: whiteTextStyle.copyWith(
                                              fontSize: 8,
                                            ),
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

                                  // Bagian bawah: progress bar atau status completed
                                  isCompleted
                                      ? Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 4),
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
                                          value: progress / 100, // Convert integer to double for progress bar
                                          backgroundColor: kWhiteColor,
                                          valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '$progress%', // Langsung menggunakan integer
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

                      // Overlay untuk kursus yang belum dimulai (progress 0%)
                      // if (isLocked)
                      //   Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.black.withValues(alpha: 0.5),
                      //       borderRadius: BorderRadius.circular(18),
                      //     ),
                      //     child: Center(
                      //       child: Container(
                      //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      //         decoration: BoxDecoration(
                      //           color: Colors.grey[700],
                      //           borderRadius: BorderRadius.circular(8),
                      //         ),
                      //         child: Text(
                      //           'Locked',
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              );
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
